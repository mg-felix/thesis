function [] = show_results_jair(results)
%SHOW_RESULTS Summary of this function goes here
%   Detailed explanation goes here

global radius Ts delta_gamma

close all;

Data = results;

reference = [Data(:,1);Data(2)];

x1 = Data(:,3);
y1 = Data(:,4); % All y with minues for xy switched
%psi1 = Data(:,5);
%v1 = Data(:,6);
gamma1 = Data(:,7);
e1x = Data(:,8);
e1y = Data(:,9);
gamma_dot1 = Data(:,10);

x2 = Data(:,13);
y2 = Data(:,14);
%psi2 = Data(:,15);
%v2 = Data(:,16);
gamma2 = Data(:,17);
e2x = Data(:,18);
e2y = Data(:,19);
gamma_dot2 = Data(:,20);

x3 = Data(:,23);
y3 = Data(:,24);
%psi3 = Data(:,25);
%v3 = Data(:,26);
gamma3 = Data(:,27);
e3x = Data(:,28);
e3y = Data(:,29);
gamma_dot3 = Data(:,30);


for i=1:length(x1)
    err1(i) = norm([x1(i);y1(i)] - reference(i)) - radius;

    err2(i) = norm([x2(i);y2(i)] - reference(i)) - radius;

    err3(i) = norm([x3(i);y3(i)] - reference(i)) - radius;
    
    R1 = [cos(gamma1(i)/radius + pi/2) -sin(gamma1(i)/radius + pi/2); sin(gamma1(i)/radius + pi/2) cos(gamma1(i)/radius + pi/2)];
    err_mpf_1(:,i) = R1*(reference(i) + radius*[cos(gamma1(i)/radius); sin(gamma1(i)/radius)] - [x1(i);y1(i)]);
    
    R2 = [cos(gamma2(i)/radius + pi/2) -sin(gamma2(i)/radius + pi/2); sin(gamma2(i)/radius + pi/2) cos(gamma2(i)/radius + pi/2)];
    err_mpf_2(:,i) = R2*(reference(i) + radius*[cos(gamma2(i)/radius); sin(gamma2(i)/radius)] - [x2(i);y2(i)]);
    
    R3 = [cos(gamma3(i)/radius + pi/2) -sin(gamma3(i)/radius + pi/2); sin(gamma3(i)/radius + pi/2) cos(gamma3(i)/radius + pi/2)];
    err_mpf_3(:,i) = R3*(reference(i) + radius*[cos(gamma3(i)/radius); sin(gamma3(i)/radius)] - [x3(i);y3(i)]);
    
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

% figure;
% plot(0:Ts:length(err2)*Ts - Ts,v1,'r')
% hold on;
% plot(0:Ts:length(err2)*Ts - Ts,v2,'g')
% hold on;
% plot(0:Ts:length(err2)*Ts - Ts,v3,'b')
% title('Velocities of each UAV')
% xlabel('Time (s)')
% ylabel('Velocity (m/s)')

size(gamma1)
size(gamma2)
delta_gamma

figure;
plot(0:Ts:length(err2)*Ts - Ts,gamma1-gamma2 + delta_gamma,'r')
hold on;
plot(0:Ts:length(err2)*Ts - Ts,gamma1-gamma3,'g')
hold on;
title('Parameterized distances between UAVs')
xlabel('Time (s)')
ylabel('Arc distance (m)')


figure;
plot(0:Ts:length(e1x)*Ts - Ts,e1x(:,1),'r')
hold on;
plot(0:Ts:length(e2x)*Ts - Ts,e2x(:,1),'g')
hold on;
plot(0:Ts:length(e3x)*Ts - Ts,e3x(:,1),'b')
title('MPF Error in x over time for each UAV')
xlabel('Time (s)')
ylabel('Error in x (m)')

figure;
plot(0:Ts:length(e1y)*Ts - Ts,e1y(:,1),'r')
hold on;
plot(0:Ts:length(e2y)*Ts - Ts,e2y(:,1),'g')
hold on;
plot(0:Ts:length(e3y)*Ts - Ts,e3y(:,1),'b')
title('MPF Error in y over time for each UAV')
xlabel('Time (s)')
ylabel('Error in y (m)')

figure;
plot(0:Ts:length(e1y)*Ts - Ts,gamma_dot1(:,1),'r')
hold on;
plot(0:Ts:length(e2y)*Ts - Ts,gamma_dot2(:,1),'g')
hold on;
plot(0:Ts:length(e3y)*Ts - Ts,gamma_dot3(:,1),'b')
title('Velocity over time for each virtual particle')
xlabel('Time (s)')
ylabel('Velocity (m/s)')

% numberofcollisions = sum(distance1<3) + sum(distance2<3) + sum(distance3<3)
% 
% ratio_not_spaced1 = (sum(distance1 > 380) + sum(distance1 < 300) ) / length(distance1)
% ratio_not_spaced2 = (sum(distance2 > 380) + sum(distance2 < 300) ) / length(distance1)
% ratio_not_spaced3 = (sum(distance3 > 380) + sum(distance3 < 300) ) / length(distance1)


end

