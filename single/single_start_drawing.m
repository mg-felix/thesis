function [] = single_start_drawing()
%START_DRAWING Summary of this function goes here
%   Detailed explanation goes here

% Defining parameters

global drone_vertices_x drone_vertices_y FigureHandle circle_handle radius
global target_points1 UAV_1_patch x0 y0
global drone1_x0 drone1_y0 drone1_psi0
global virtual_target1

drone_vertices_x = 0.5*[0 3 6 3] - 3;
drone_vertices_y = 0.5*[0 1 0 5] - 2.5;

FigureHandle = figure('Name', 'Simulation results', 'NumberTitle', 'off');
FigureHandle.Position = [500,600,500,600];
AxesHandle = axes('Parent', FigureHandle);
axis equal
box(AxesHandle, 'on');
hold(AxesHandle, 'on');

xlim_1= -300;
xlim_2= 300;
ylim_1= -300;
ylim_2= 300;
hold off
plot(AxesHandle,xlim_1,ylim_1)
hold on
plot(AxesHandle,xlim_2,ylim_2)
hold on
plot(AxesHandle,xlim_2,ylim_1)
hold on
plot(AxesHandle,xlim_1,ylim_2)

title('Position of UAVs and virtual targets');
xlabel('Y (m)');
ylabel('X (m)');

% Target points and UAV patch for UAV 1
target_points1 = animatedline('Marker','o','Color','r');
UAV_1_patch = patch(drone1_y0 + drone_vertices_x, drone1_x0 + drone_vertices_y,'r'); % Defines drone position
rotate(UAV_1_patch, [0 0 1], -rad2deg(drone1_psi0), [drone1_y0 drone1_x0 0]); % Defines drone orientation

% Virtual Targets

virtual_target1 = animatedline('Marker','o','Color', 'r');

circle_handle = plot(x0,y0,'o','MarkerSize',radius);

%h = image(xlim,-ylim,I); 
%uistack(h,'bottom')

end

