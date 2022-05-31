function [] = show_results(ans)
%SHOW_RESULTS Summary of this function goes here
%   Detailed explanation goes here

global radius Ts

Data = ans.simulation_data;

reference = [Data(:,1);Data(2)];

x1 = Data(:,3);
y1 = Data(:,4);
psi1 = Data(:,5);

x2 = Data(:,8);
y2 = Data(:,9);
psi2 = Data(:,10);

x3 = Data(:,13);
y3 = Data(:,14);
psi3 = Data(:,15);

for i=1:length(x1)
    err1(i) = norm([x1(i);y1(i)] - reference(i)) - radius;

    err2(i) = norm([x2(i);y2(i)] - reference(i)) - radius;

    err3(i) = norm([x3(i);y3(i)] - reference(i)) - radius;
end

plot(0:Ts:length(err2)*Ts - Ts,err1,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err2,'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err3,'b')
title('Lateral Error for each UAV (colour correspondent)')
xlabel('Time (s)')
ylabel('Lateral Error (m)')

figure;
plot(x1,y1,'r')
hold on;
plot(x2,y2,'g')
hold on;
plot(x3,y3,'b')


end

