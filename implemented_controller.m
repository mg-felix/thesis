function [output] = implemented_controller(input)
%IMPLEMENTED_CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

%% Definition of variables from input and output

global vel_target_x vel_target_y radius theta_dot_constant

% Input
reference_x = input(1);
reference_y = input(2);
current_x2 = input(3); % Positions of other UAVs
current_y2 = input(4);
current_x3 = input(5);
current_y3 = input(6);
theta = input(7);

current_x = input(8);
current_y = input(9);
current_psi = wrapToPi(input(10));
current_v = input(11);


current = [current_x; current_y];
reference = [reference_x; reference_y];

current2 = [current_x2; current_y2];
current3 = [current_x3; current_y3];

%% Artificial Potential Field (APF)

% Vector field design

Kn = 0.003 ;

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

repulsive_gain = 7000; % Chooses how strong the repulsion should be. If 0, collision avoidance is off

r_repulsive1 = current - current2; % Creates a new vector based on the distance between the UAVs
r_repulsive2 = current - current3; % Creates a new vector based on the distance between the UAVs

vrepulsive = ( (1./r_repulsive1) + (1./r_repulsive2))*repulsive_gain; % Add if = 0 in division;

v = v + vrepulsive; % Adds this influence to the vector field

md = v/norm(v);

% Path following controller design

K_delta = 30;

vt = [vel_target_x;vel_target_y]; % Target velocity

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

% Velocity command calculation - according to https://doi.org/10.1016/j.conengprac.2022.105184

% Constant values attributions

vs = 5; % Reference speed

kx = 2;
ky = 2;
kpsi = 1;
kdelta = 1;

k1 = 1;
k2 = 1;
k3 = 1;

% UAV data

v = 0; % "Wind"
u = current_v; 

% Desired target

xd = radius*cos(theta_dot_constant*theta);
yd = radius*sin(theta_dot_constant*theta);


xd_prime = -radius*theta_dot_constant*sin(theta_dot_constant*theta);
yd_prime = radius*theta_dot_constant*cos(theta_dot_constant*theta);

% Error

zx = current(1) - xd;
zy = current(2) - yd;

% Other auxiliar variables

delta = zx*xd_prime + zy*yd_prime;

Phix = sqrt(zx^2 + kx);
Phiy = sqrt(zy^2 + ky);
Phidelta = sqrt(delta^2 + kdelta);

F1 = xd_prime - k1*zx/Phix;
F2 = yd_prime - k2*zy/Phiy;
F3 = vs + (delta - e)/Phidelta;

psi_r = atan2(F1,F2);
psi_w = current_psi;

zpsi = psi_w - psi_r;

% Phipsi = sqrt(zpsi^2 + kpsi);

% beta = atan(v/u); % Slideslip angle
% betad = 0; % betad = beta_dot, the derivative of beta over time. Since there is no wind, the slideslip will always be 0 and hence, the derivative is -1

% psi_r_dot = 0; % ?????

% Control values calculation

Ur = vs * sqrt(F1^2 + F2^2); % Commanded velocity
% rr = -k3*zpsi/Phipsi - betad + psi_r_dot; % Commanded heading angular velocity

%% Outputs the results

v_cmd = current_v; % Ur;
psi_dot_cmd = u_psi_dot;

output(1) = v_cmd; 
output(2) = psi_dot_cmd;



caption = sprintf('Error = %f \nDistances = %f, %f, %f\n Heading angular velocity = %f\nVelocity = %f', e, norm(current-current2), norm(current-current3), norm(current2-current3), psi_dot_cmd, v_cmd);
title(caption, 'FontSize', 20);

end

