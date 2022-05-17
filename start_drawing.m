function [] = start_drawing()
%START_DRAWING Summary of this function goes here
%   Detailed explanation goes here

% Defining parameters

global drone_vertices_x drone_vertices_y FigureHandle 
global target_points1 target_points2 target_points3 UAV_1_patch UAV_2_patch UAV_3_patch
global drone1_x0 drone1_y0 drone2_x0 drone2_y0 drone3_x0 drone3_y0 drone1_psi0 drone2_psi0 drone3_psi0



drone_vertices_x = 0.5*[0 3 6 3] - 3;
drone_vertices_y = 0.5*[0 1 0 5] - 2.5;

FigureHandle = figure('Name', 'Simulation results', 'NumberTitle', 'off');
FigureHandle.Position = [500,200,500,400];
AxesHandle = axes('Parent', FigureHandle);
axis equal
box(AxesHandle, 'on');
hold(AxesHandle, 'on');

xlim_1= -100;
xlim_2= 100;
ylim_1= -100;
ylim_2= 100;
hold off
plot(AxesHandle,xlim_1,ylim_1)
hold on
plot(AxesHandle,xlim_2,ylim_2)
hold on
plot(AxesHandle,xlim_2,ylim_1)
hold on
plot(AxesHandle,xlim_1,ylim_2)

title('Position of UAVs and virtual targets');
xlabel('X (m)');
ylabel('Y (m)');


% Target points and UAV patch for UAV 1
target_points1 = animatedline('Marker','o','Color','r');
UAV_1_patch = patch(drone1_y0 + drone_vertices_x, drone1_x0 + drone_vertices_y,'r'); % Defines drone position
rotate(UAV_1_patch, [0 0 1], -rad2deg(drone1_psi0), [drone1_y0 drone1_x0 0]); % Defines drone orientation

% Target points and UAV patch for UAV 2
target_points2 = animatedline('Marker','o','Color','g');
UAV_2_patch = patch(drone2_y0 + drone_vertices_x, drone2_x0 + drone_vertices_y,'g'); % Defines drone position
rotate(UAV_2_patch, [0 0 1], -rad2deg(drone2_psi0), [drone2_y0 drone2_x0 0]); % Defines drone orientation

% Target points and UAV patch for UAV 3
target_points3 = animatedline('Marker','o','Color','b');
UAV_3_patch = patch(drone3_y0 + drone_vertices_x, drone3_x0 + drone_vertices_y,'b'); % Defines drone position
rotate(UAV_3_patch, [0 0 1], -rad2deg(drone3_psi0), [drone3_y0 drone3_x0 0]); % Defines drone orientation

end

