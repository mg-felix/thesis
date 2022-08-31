function [] = draw_results_jair(input)
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
%
    target_x2 = input(11);
    target_y2 = input(12);
    current_x2 = input(13);
    current_y2 = input(14);
    current_psi2 = input(15);
    current_v2 = input(16);
    gamma2 = input(17);
    ex2 = input(18);
    ey2 = input(19);
    gamma_dot2 = input(20);
%
    target_x3 = input(21);
    target_y3 = input(22);
    current_x3 = input(23);
    current_y3 = input(24);
    current_psi3 = input(25);
    current_v3 = input(26);
    gamma3 = input(27);
    ex3 = input(28);
    ey3 = input(29);
    gamma_dot3 = input(30);
 
    delete(circle_handle);
    th = 0:pi/50:2*pi;
    xunit = radius * cos(th) + target_x1;
    yunit = radius * sin(th) + target_y1;
    circle_handle = plot(xunit, yunit,'c');
    
        % Target 1
        clearpoints(target_points1); % Deletes previous point
        addpoints(target_points1,target_x1,target_y1); % Draws where the new point should be

        % UAV 1
        delete(UAV_1_patch); % Deletes previous patch
        UAV_1_patch = patch(current_y1 + drone_vertices_x, current_x1 + drone_vertices_y,'r'); % Draws new drone position
        rotate(UAV_1_patch, [0 0 1], -rad2deg(current_psi1), [current_y1 current_x1 0]); % Draws new drone orientation

        % Target 2
        clearpoints(target_points2); % Deletes previous point
        addpoints(target_points2,target_x2,target_y2); % Draws where the new point should be
        % UAV 2
        delete(UAV_2_patch); % Deletes previous patch
        UAV_2_patch = patch(current_y2 + drone_vertices_x, current_x2 + drone_vertices_y,'g'); % Draws new drone position
        rotate(UAV_2_patch, [0 0 1], -rad2deg(current_psi2), [current_y2 current_x2 0]); % Draws new drone orientation

        % Target 3
        clearpoints(target_points3); % Deletes previous point
        addpoints(target_points3,target_x3,target_y3); % Draws where the new point should be
        % UAV 3
        delete(UAV_3_patch); % Deletes previous patch
        UAV_3_patch = patch(current_y3 + drone_vertices_x, current_x3 + drone_vertices_y,'b'); % Draws new drone position
        rotate(UAV_3_patch, [0 0 1], -rad2deg(current_psi3), [current_y3 current_x3 0]); % Draws new drone orientation
        
        
        % Virtual Particles
        
        clearpoints(virtual_target1);
        addpoints(virtual_target1, radius*sin(gamma1/radius) + target_x1, radius*cos(gamma1/radius) + target_y1);
        clearpoints(virtual_target2);
        addpoints(virtual_target2, radius*sin(gamma2/radius) + target_x1, radius*cos(gamma2/radius) + target_y1);
        clearpoints(virtual_target3);
        addpoints(virtual_target3, radius*sin(gamma3/radius) + target_x1, radius*cos(gamma3/radius) + target_y1);
        
        
        
%         h = findobj('Color','purple','Type',scatter);
%         delete(h);
%         
%         scatter()
%         
    hold on; % Keep same figure
    
    drawnow; % Update the drawings
    
end

