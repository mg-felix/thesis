function [output] = implemented_controller(input)
%IMPLEMENTED_CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

%% Definition of variables from input and output

global vel_target_x vel_target_y radius repulsive_mine_flag repulsive_gaussian_flag theta

% Input
reference_x = input(1);
reference_y = input(2);
current_x2 = input(3); % Positions of other UAVs
current_y2 = input(4);
current_x3 = input(5);
current_y3 = input(6);

l = input(7);
l_other = input(8);
l_dot_other = input(9);

current_x = input(10);
current_y = input(11);
current_psi = wrapToPi(input(12));
current_v = input(13);


current = [current_x; current_y];
reference = [reference_x; reference_y];

current2 = [current_x2; current_y2];
current3 = [current_x3; current_y3];



%% Artificial Potential Field (APF)

% Vector field design

Kn = 0.001 ;

path_radius = 200; % Defines how far from the target the drone should circle

alfa_t = 0; % Constant value

R = [cos(alfa_t) -sin(alfa_t); sin(alfa_t) cos(alfa_t)]; % Rotation matrix from inertial to reference

E = [0 1; -1 0]; % Given, changes the direction of circular motion if multiplied  by -1

r = R'*(current-reference);

phi = r'*r; % It is also = rx^2 + ry^2

grad_phi = [2*r(1); 2*r(2)]; % Gradient is the vector [dgama/dx; dgama/dy]

e = phi - path_radius^2;

v = E*grad_phi - Kn*e*grad_phi; % Vector field in the UAV position

md = v/norm(v); % Unit orientation value for the vector field in the UAV position

% Repulsive UAVs vector design

repulsive_gain = 400*repulsive_mine_flag; % Chooses how strong the repulsion should be. If 0, collision avoidance is off

A = 1000;
sigma = 100;
expected_value = [100; 100];

repulsive_gaussian = repulsive_gaussian_flag*A*exp( ( -(current - expected_value)'*(current - expected_value) )/(2*sigma^2) ); % 

r_repulsive1 = current - current2; % Creates a new vector based on the distance between the UAVs
r_repulsive2 = current - current3; % Creates a new vector based on the distance between the UAVs

vrepulsive = ( (r_repulsive1)/norm(r_repulsive1) + (r_repulsive2)/norm(r_repulsive2) ) * repulsive_gaussian; % Add if = 0 in division;

v = v + vrepulsive; % Adds this influence to the vector field

md = v/norm(v);

% Path following controller design

K_delta = 30;

vt = [vel_target_x; vel_target_y]; % Target velocity

alfa = current_psi; % Heading angle of UAV

m = [cos(alfa); sin(alfa)]; % Unit orientation vector of UAV

H = [2 0; 0 2]; % Hessian of phi

I2 = -E*E;

r_dot = R'*([current_v*cos(current_psi); current_v*sin(current_psi)] - vt); % Assuming we know the velocity of target, vt

mr = r_dot/norm(r_dot); % Unitary orientation vector for relative velocity

delta = wrapToPi( - angle(md(1) + md(2)*1i ) + angle(mr(1) + mr(2)*1i ) ); % Angle between md and mr, between -pi and pi

psi_prime = 1; %1/(sqrt(phi)*2); % Derivative of e = psi(phi(r)) over Phi (prime sign ') 

e_dot = psi_prime*grad_phi'*r_dot; % Derivative over time of error

v_dot = (E - Kn*e*I2)*H*r_dot - Kn*e_dot*grad_phi; % Derivative over time of vector field

md_dot = -1/norm(v)*E*md*md'*E*v_dot; % Derivative over time of unitary vector field

s = current_v;

u_psi_dot = norm(r_dot)/s * (-md_dot'*E*md - K_delta*delta)/(mr'*R'*m); % Control imput - angular velocity


%% Controlling the velocity to keep them equally spaced in the path

k1 = 0.0001; % Gain constants, > 0
beta = 6;
ku = 10;

theta = l/radius;

psi_f = atan2(cos(theta),sin(theta)); % Angle of tangent on the virtual particle relative to x axis in {I}
psi_dash = current_psi - psi_f;


vpx = vt(1); % Target velocity
vpy = vt(2);

wp = 0; % Target angular velocity

delta_x = radius; % pf - pp = radius
delta_y = radius;

delta_l = 2*pi*radius/3; % Separation between vehicles

Sigma = -(vpx - wp*delta_y)*cos(psi_f) - (vpy - wp*delta_x)*sin(psi_f); 

R = [cos(psi_f) sin(psi_f); -sin(psi_f) cos(psi_f)];

Fx = R*([current_x - radius*cos(theta); current_y - radius*sin(theta)]);

Fx = Fx(1);

l_dot = current_v*cos(psi_dash) + Sigma + k1*Fx; % Rate of progression of the virtual target along the desired path
l_tilde = l - l_other + delta_l; % Coordination error

u = l_dot_other - beta*tanh(ku*l_tilde);

v = (u - Sigma - k1*Fx)/cos(psi_dash); % Calculated input for velocity

%% Make it different for the leader UAV

if l_dot_other == l_other && l_other == -1000
    v = current_v;
end


%% Outputs the results

v_cmd = v; 
psi_dot_cmd = u_psi_dot;

output(1) = v_cmd; 
output(2) = psi_dot_cmd;

output(3) = l;
output(4) = l_dot;

err = norm(current - reference) - radius;

caption = sprintf('Error = %f \nDistances = %f, %f, %f\n Heading angular velocity = %f\nVelocity = %f', err, norm(current-current2), norm(current-current3), norm(current2-current3), psi_dot_cmd, v_cmd);
title(caption, 'FontSize', 20);

end

