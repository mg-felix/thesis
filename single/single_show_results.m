function [] = single_show_results(results)
%SHOW_RESULTS Summary of this function goes here
%   Detailed explanation goes here

global radius Ts

close all;

Data = results;

reference = [Data(:,1);Data(2)];
reference_x = Data(:,1);
reference_y = Data(:,2);

x1 = Data(:,3);
y1 = Data(:,4); % All y with minues for xy switched
psi1 = Data(:,5);
v1 = Data(:,6);
gamma1 = Data(:,7);
e1x = Data(:,8);
e1y = Data(:,9);
gamma_dot1 = Data(:,10);
psi_dot1 = Data(:,11);


for i=1:length(x1)
    err1(i) = norm([x1(i);y1(i)] - reference(i)) - radius;
    
    R1 = [cos(gamma1(i)/radius + pi/2) -sin(gamma1(i)/radius + pi/2); sin(gamma1(i)/radius + pi/2) cos(gamma1(i)/radius + pi/2)];
    err_mpf_1(:,i) = R1*(reference(i) + radius*[cos(gamma1(i)/radius); sin(gamma1(i)/radius)] - [x1(i);y1(i)]);
end

% figure;
% 
% plot(0:Ts:length(err2)*Ts - Ts,err1,'r')
% hold on;
% plot(0:Ts:length(err2)*Ts - Ts,err2,'g')
% hold on;
% plot(0:Ts:length(err2)*Ts - Ts,err3,'b')
% %title('Distance to the circle of predefined radius for each UAV (colour correspondent)')
% xlabel('Time (s)')
% ylabel('Distance (m)')


figure;
plot(y1,x1,'r')
%title('Path drawn by each UAV')
xlabel('y (m)')
ylabel('x (m)')

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
plot(0:Ts:length(err1)*Ts - Ts,v1,'r')
%title('Velocities of each UAV')
xlabel('Time (s)')
ylabel('Velocity (m/s)')

figure;
plot(0:Ts:length(err1)*Ts - Ts,psi_dot1*180/pi,'r')
%title('Heading rate of each UAV')
xlabel('Time (s)')
ylabel('Heading rate (º/s)')


figure;
plot(0:Ts:length(e1x)*Ts - Ts,e1x(:,1),'r')
%title('MPF Error in x over time for each UAV')
xlabel('Time (s)')
ylabel('Error e1 (m)')

figure;
plot(0:Ts:length(e1y)*Ts - Ts,e1y(:,1),'r')
%title('MPF Error in y over time for each UAV')
xlabel('Time (s)')
ylabel('Error e2 (m)')

figure;
plot(0:Ts:length(e1y)*Ts - Ts,gamma_dot1(:,1),'r')
%title('Velocity over time for each virtual particle')
xlabel('Time (s)')
ylabel('Velocity (m/s)')


end

