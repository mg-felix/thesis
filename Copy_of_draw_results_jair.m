function [] = Copy_of_draw_results_jair(input)
%DRAW_RESULTS Draws the new positions for target and UAVs

global drone_vertices_x drone_vertices_y target_points1 UAV_1_patch target_points2 UAV_2_patch target_points3 UAV_3_patch radius circle_handle
global virtual_target1 virtual_target2 virtual_target3

%% Drawing

    target_x1 = input(1); % All x with minus for xy coordinates switched
    target_y1 = input(2);
    current_x1 = input(3);
    current_y1 = input(4);
    current_psi1 = input(5);
    current_v1 = input(6);
    gamma1 = input(7);
    ex1 = input(8);
    ey1 = input(9);
    gamma_dot1 = input(10);
    psi_dot1 = input(11);
 
    delete(circle_handle);
    th = 0:pi/50:2*pi;
    xunit = radius * cos(th) + target_y1;
    yunit = radius * sin(th) + target_x1;
    circle_handle = plot(xunit, yunit,'c');
    
        % Target 1
        clearpoints(target_points1); % Deletes previous point
        addpoints(target_points1,target_y1,target_x1); % Draws where the new point should be

        % UAV 1
        delete(UAV_1_patch); % Deletes previous patch
        UAV_1_patch = patch(current_y1 + drone_vertices_x, current_x1 + drone_vertices_y,'r'); % Draws new drone position
        rotate(UAV_1_patch, [0 0 1], -rad2deg(current_psi1), [current_y1 current_x1 0]); % Draws new drone orientation
               
        % Virtual Particles
        
        clearpoints(virtual_target1);
        addpoints(virtual_target1, radius*sin(gamma1/radius) + target_y1, radius*cos(gamma1/radius) + target_x1);
        
    hold on; % Keep same figure
    
    drawnow; % Update the drawings
    
end

