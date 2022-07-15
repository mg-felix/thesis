function [] = show_results(ans)
%SHOW_RESULTS Summary of this function goes here
%   Detailed explanation goes here

global radius Ts

Data = ans.simulation_data;

reference = [Data(:,1);Data(2)];

x1 = Data(:,3);
y1 = -Data(:,4); % All y with minues for xy switched
psi1 = Data(:,5);
v1 = Data(:,6);
l1 = Data(:,7);

x2 = Data(:,10);
y2 = -Data(:,11);
psi2 = Data(:,12);
v2 = Data(:,13);
l2 = Data(:,14);

x3 = Data(:,17);
y3 = -Data(:,18);
psi3 = Data(:,19);
v3 = Data(:,20);
l3 = Data(:,21);

for i=1:length(x1)
    err1(i) = norm([x1(i);y1(i)] - reference(i)) - radius;

    err2(i) = norm([x2(i);y2(i)] - reference(i)) - radius;

    err3(i) = norm([x3(i);y3(i)] - reference(i)) - radius;
    
    R1 = [cos(l1(i)/radius + pi/2) -sin(l1(i)/radius + pi/2); sin(l1(i)/radius + pi/2) cos(l1(i)/radius + pi/2)];
    err_mpf_1(:,i) = R1*(reference(i) + radius*[cos(l1(i)/radius); sin(l1(i)/radius)] - [x1(i);y1(i)]);
    
    R2 = [cos(l2(i)/radius + pi/2) -sin(l2(i)/radius + pi/2); sin(l2(i)/radius + pi/2) cos(l2(i)/radius + pi/2)];
    err_mpf_2(:,i) = R2*(reference(i) + radius*[cos(l2(i)/radius); sin(l2(i)/radius)] - [x2(i);y2(i)]);
    
    R3 = [cos(l3(i)/radius + pi/2) -sin(l3(i)/radius + pi/2); sin(l3(i)/radius + pi/2) cos(l3(i)/radius + pi/2)];
    err_mpf_3(:,i) = R3*(reference(i) + radius*[cos(l3(i)/radius); sin(l3(i)/radius)] - [x3(i);y3(i)]);
    
    distance1(i) = norm([x1(i);y1(i)] - [x2(i);y2(i)]);
    distance2(i) = norm([x1(i);y1(i)] - [x3(i);y3(i)]);
    distance3(i) = norm([x2(i);y2(i)] - [x3(i);y3(i)]);
end

figure;

plot(0:Ts:length(err2)*Ts - Ts,err1,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err2,'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err3,'b')
title('Distance to the circle of predefined radius for each UAV (colour correspondent)')
xlabel('Time (s)')
ylabel('Distance (m)')

figure
plot(0:Ts:length(err2)*Ts - Ts,err_mpf_1(1,:),'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err_mpf_2(1,:),'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err_mpf_3(1,:),'b')
title('Lateral Error for each UAV (colour correspondent)')
xlabel('Time (s)')
ylabel('Lateral Error (m)')

figure
plot(0:Ts:length(err2)*Ts - Ts,err_mpf_1(2,:),'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err_mpf_2(2,:),'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,err_mpf_3(2,:),'b')
title('Longitudinal Error for each UAV (colour correspondent)')
xlabel('Time (s)')
ylabel('Longitudinal Error (m)')
% 
% figure;
% plot(y1,x1,'r')
% hold on;
% plot(y2,x2,'g')
% hold on;
% plot(y3,x3,'b')
% title('Path drawn by each UAV')
% xlabel('y (m)')
% ylabel('x (m)')

% figure;
% plot(0:Ts:length(err2)*Ts - Ts,distance1,'c')
% hold on;
% plot(0:Ts:length(err2)*Ts - Ts,distance2,'m')
% hold on;
% plot(0:Ts:length(err2)*Ts - Ts,distance3,'k')
% title('Distances between UAVs')
% xlabel('Time (s)')
% ylabel('Distances (m)')

figure;
plot(0:Ts:length(err2)*Ts - Ts,v1,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,v2,'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,v3,'b')
title('Velocities of each UAV')
xlabel('Time (s)')
ylabel('Velocity (m/s)')

figure;
plot(0:Ts:length(err2)*Ts - Ts,l1-l2,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,l1-l3,'g')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,l2-l3,'b')
title('Parameterized distances between UAVs')
xlabel('Time (s)')
ylabel('Arc distance (m)')


% numberofcollisions = sum(distance1<3) + sum(distance2<3) + sum(distance3<3)
% 
% ratio_not_spaced1 = (sum(distance1 > 380) + sum(distance1 < 300) ) / length(distance1)
% ratio_not_spaced2 = (sum(distance2 > 380) + sum(distance2 < 300) ) / length(distance1)
% ratio_not_spaced3 = (sum(distance3 > 380) + sum(distance3 < 300) ) / length(distance1)


end

