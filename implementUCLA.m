%  M237 smart charging project
% ==============================

% penetration level 1
[GRIDdemand1,totalPower1,newTotalPower1,statTotalPower1] = smartCharging4(15,10);
% penetration level 2
[GRIDdemand2,totalPower2,newTotalPower2,statTotalPower2] = smartCharging4(15,20);
% penetration level 3
[GRIDdemand3,totalPower3,newTotalPower3,statTotalPower3] = smartCharging4(15,50);

t = linspace(8,20,49);
figure(1)
plot(t,GRIDdemand1,'k');
hold on
plot(t,totalPower1,'r','LineWidth',2);
hold on
plot(t,newTotalPower1,'b','LineWidth',2);
hold off
title('Power Demand in a day from 8am to 8pm');
xlabel('t');
ylabel('kW');
legend('without EV','before management','real time management','Location','Best');

figure(2)
plot(t,GRIDdemand2,'k');
hold on
plot(t,totalPower2,'r','LineWidth',2);
hold on
plot(t,newTotalPower2,'b','LineWidth',2);
hold off
title('Power Demand in a day from 8am to 8pm');
xlabel('t');
ylabel('kW');
legend('without EV','before management','real time management','Location','Best');

figure(3)
plot(t,GRIDdemand3,'k');
hold on
plot(t,totalPower3,'r','LineWidth',2);
hold on
plot(t,newTotalPower3,'b','LineWidth',2);
hold off
title('Power Demand in a day from 8am to 8pm');
xlabel('t');
ylabel('kW');
legend('without EV','before management','real time management','Location','Best');

figure(4)
variance = [var(totalPower1),var(newTotalPower1);...
    var(totalPower2),var(newTotalPower2);...
    var(totalPower3),var(newTotalPower3)];
bar(variance);




