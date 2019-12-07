function [GRIDdemand,totalPower,newTotalPower,statTotalPower] = smartCharging4(timeInterval,maxVehicle)

%% information specification
nOfIntervals = 12*60/timeInterval;
P = 6;

%% power demand information and EV information
% import the total power demand of UCLA in a day from 8 am to 8 pm per
% 15min
[GRIDdemand] = xlsread('total power demand UCLA',1,'C34:C82');

% generate the EV info at UCLA in a day from 8 am to 8 pm at 15min'
% interval
[vehicle_info,vehicle] = vehicle_info3(nOfIntervals,maxVehicle);

% calculate the EV charging demand
EVdemand = zeros(nOfIntervals+1,1);
for i = 0:nOfIntervals
%     nOfChargedEV = 0;
%     for j = 1:sum(vehicle)
%        if vehicle_info(j,1) <= i*timeInterval && (vehicle_info(j,1)+ vehicle_info(j,2)) > i*timeInterval
%            nOfChargedEV=nOfChargedEV + 1;
%        end
%     end
    nOfChargedEV = length(vehicle_info(find(vehicle_info(:,1) <= i*timeInterval & (vehicle_info(:,1)+ vehicle_info(:,2)) > i*timeInterval)));
    EVdemand(i+1) = nOfChargedEV*P;
end

% calculate the other loads
totalPower = GRIDdemand + EVdemand;


%% management process
% arrangement matrix
simulation = [linspace(1,sum(vehicle),sum(vehicle))',vehicle_info,12*60*ones(sum(vehicle),1)]; 
%[no,enteringTime,chargingTime,exitingTime,startTime]

% manage the real start charging time
for i = 1:nOfIntervals-6
    % accessible EV info
    knownEV_info = simulation(1:sum(vehicle(1:i)),:);
    
    [info,fv] = PSO2(40,1.49445,1.49445,1,400,knownEV_info,i,nOfIntervals+1,timeInterval,GRIDdemand);
    
    simulation(1:sum(vehicle(1:i)),:) = info;
end

newEVdemand = zeros(nOfIntervals+1,1);
for i = 0:nOfIntervals
    nOfChargedEV = length(simulation(find(simulation(:,5) <= i*timeInterval & (simulation(:,5)+ simulation(:,3)) > i*timeInterval)));
    newEVdemand(i+1) = nOfChargedEV*P;
end

newTotalPower = newEVdemand + GRIDdemand;

%% second management process
simulation2 = [linspace(1,sum(vehicle),sum(vehicle))',vehicle_info,12*60*ones(sum(vehicle),1)];
[info,fv] = PSO2(40,75,75,50,400,simulation2,1,nOfIntervals+1,timeInterval,GRIDdemand);
simulation2(1:sum(vehicle),:) = info;
newEVdemand2 = zeros(nOfIntervals+1,1);
for i = 0:nOfIntervals
    nOfChargedEV2 = length(simulation2(find(simulation2(:,5) <= i*timeInterval & (simulation2(:,5)+ simulation2(:,3)) > i*timeInterval)));
    newEVdemand2(i+1) = nOfChargedEV2*P;
end

statTotalPower = newEVdemand2 + GRIDdemand;


end

