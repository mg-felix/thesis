function [output] = implemented_controller(input)
%IMPLEMENTED_CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

%% Definition of variables from input and output

% Input
reference_x = input(1);
reference_y = input(2);
% s_dot = input(3); 
% phi = input(4);
current_x = input(5);
current_y = input(6);
current_psi = wrapToPi(input(7));
current_v = input(8);

current = [current_x; current_y];
reference = [reference_x; reference_y];

%% Artificial Potential Field (APF)

% Vector field design

Kn = 1;

E = [0 1; -1 0]; % Given

path_radius = 1000; % Defines how far from the target the drone should circle

alfa_t = 0; % Constant value

R = [cos(alfa_t) -sin(alfa_t); sin(alfa_t) cos(alfa_t)]; % Rotation matrix from inertial to reference

r = R'*(current-reference);

phi = r'*r; % It is also = rx^2 + ry^2

grad_phi = [2*r(1); 2*r(2)]; % Gradient is the vector [dgama/dx; dgama/dy]

e = phi - path_radius;

v = E*grad_phi - Kn*e*grad_phi; % Vector field in the UAV position

md = v/norm(v); % Unit orientation value for the vector field in the UAV position

% Path following controller design

K_delta = 10;

alfa = current_psi; % Heading angle of UAV

m = [cos(alfa); sin(alfa)]; % Unit orientation vector of UAV

H = [2 0; 0 2]; % Hessian of phi

I2 = -E*E;

r_dot = R'*([current_v*cos(current_psi); current_v*sin(current_psi)] - 0); % Assuming we know the velocity of target

mr = r_dot/norm(r_dot); % Unitary orientation vector for relative velocity

delta = wrapToPi( angle(md(1) + md(2)*1i ) - angle(mr(1) + mr(2)*1i ) ); % Angle between md and mr, between -pi and pi

psi_prime = 1/(sqrt(phi)*2); % Derivative over Phi (prime sign ') 

e_dot = psi_prime*grad_phi'*r_dot; % Derivative over time of error

v_dot = (E - Kn*e*I2)*H*r_dot - Kn*e_dot*grad_phi; % Derivative over time of vector field

md_dot = -1/norm(v)*E*md*md'*E*v_dot; % Derivative over time of unitary vector field

s = current_v;

u = norm(r_dot)/s * (-md_dot'*E*md - K_delta*delta)/(mr'*R'*m); % Control imput - angular velocity

%% Outputs the results

psi_dot_cmd = u;

output(1) = current_v; 
output(2) = psi_dot_cmd;

%caption = sprintf('Commanded angular velocity = %f',  );
%title(caption, 'FontSize', 20);

end
