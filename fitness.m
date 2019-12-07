% input
% vehicle_info = [vehicle No, EnteringTime, ChargingTime, ExitingTime, StartChargingTime]
% n = number of time spot
% load_grid = grid load data
function LS = fitness(vehicle_info,n,load_grid)

minutes = 12*60/(n-1); % minutes in one time interval
N = zeros(n,1); % number of cars that is being charged during this time spot
load_EV = zeros(n,1); % initiate load_EV vector
load_total = zeros(n,1); % initiate load_total vector
P = 6; % charing power of each vehicle [kw]

% find how many cars are being charged in each interval
for  i = 1:n
    for j = 1:size(vehicle_info,1)
        if vehicle_info(j,5) <= minutes*(i-1) && vehicle_info(j,3)+ vehicle_info(j,5) > minutes*(i-1)
            N(i) = N(i)+1;
        end
    end
    load_EV(i) = N(i) * P;
    load_total(i) = load_EV(i)+load_grid(i);
end 

load_average = sum(load_total)/n; % calculate average load

square_difference = zeros(n,1); % initiate square difference vector

for  i = 1:n
    square_difference(i) = load_total(i)^2-load_average^2;
end

% evaluate the least square function
LS = sum(square_difference)/n;
end

