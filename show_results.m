function [] = show_results(ans)
%SHOW_RESULTS Summary of this function goes here
%   Detailed explanation goes here

global radius Ts

Data = ans.simulation_data;

reference = [Data(:,1);Data(2)];

x1 = Data(:,3);
y1 = Data(:,4);
psi1 = Data(:,5);
v1 = Data(:,6);

x2 = Data(:,9);
y2 = Data(:,10);
psi2 = Data(:,11);
v2 = Data(:,12);

x3 = Data(:,15);
y3 = Data(:,16);
psi3 = Data(:,17);
v3 = Data(:,18);

for i=1:length(x1)
    err1(i) = norm([x1(i);y1(i)] - reference(i)) - radius;

    err2(i) = norm([x2(i);y2(i)] - reference(i)) - radius;

    err3(i) = norm([x3(i);y3(i)] - reference(i)) - radius;
    
    distance1(i) = norm([x1(i);y1(i)] - [x2(i);y2(i)]);
    distance2(i) = norm([x1(i);y1(i)] - [x3(i);y3(i)]);
    distance3(i) = norm([x2(i);y2(i)] - [x3(i);y3(i)]);
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
plot(y1,x1,'r')
hold on;
plot(y2,x2,'g')
hold on;
plot(y3,x3,'b')
title('Path drawn by each UAV')
xlabel('x (m)')
ylabel('y (m)')

figure;
plot(0:Ts:length(err2)*Ts - Ts,distance1,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,distance2,'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,distance3,'b')
title('Distances between UAVs')
xlabel('Time (s)')
ylabel('Distances (m)')

figure;
plot(0:Ts:length(err2)*Ts - Ts,v1,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,v2,'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,v3,'b')
title('Velocities of each UAV')
xlabel('Time (s)')
ylabel('Velocity (m/s)')

numberofcollisions = sum(distance1<3) + sum(distance2<3) + sum(distance3<3)

ratio_not_spaced1 = (sum(distance1 > 380) + sum(distance1 < 300) ) / length(distance1)
ratio_not_spaced2 = (sum(distance2 > 380) + sum(distance2 < 300) ) / length(distance1)
ratio_not_spaced3 = (sum(distance3 > 380) + sum(distance3 < 300) ) / length(distance1)


end

