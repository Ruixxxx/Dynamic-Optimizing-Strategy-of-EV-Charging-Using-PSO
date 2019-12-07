function [vehicle_info,vehicle] = vehicle_info3(n,vehicle_range)
%output vehicle info every moment

% n -- number of moments/iterations
% vehicle_range -- maximum number of vehicle each moment (can be different)

SOC = [10,90];                 % state of charging (need to be changed to time)
time_max = 12*60/n;                % max time each moment

vehicle = randi(vehicle_range,n-6,1); % number of vehicles each moment

vehicle_info = zeros(sum(vehicle),3); % [enteringTime,chargingTime,exitingTime] each moment

enteringTime = zeros(sum(vehicle),1);
for j = 1:n-6
    % jth moment
    for i = 1:vehicle(j)
        enteringTime(sum(vehicle(1:j-1))+i) = round(time_max * rand) + (j-1)*time_max;
    end 
end
chargingTime = randi(SOC,sum(vehicle),1);
exitingTime = zeros(sum(vehicle),1);
for i = 1:sum(vehicle)
    while exitingTime(i) < (enteringTime(i) + chargingTime(i))
        exitingTime(i) = round(12*60*rand);
    end
end

vehicle_info = vehicle_info + [enteringTime,chargingTime,exitingTime];

end
