function [output] = vehicle_controller(input)
%UNTITLED Calculates control inputs
%   Calculates control inputs, heading rate and velocity, based on the
%   aircraft, particle and target positions and velocities. The path around
%   the target can be chosen in the parameter dpdgamma and particle_pos and
%   also by changing the variable radius.

%% Define inputs

global radius

target_x = input(1);
target_y = input(2);
gamma = input(3);
gamma_dot = input(4);

current_x = input(5);
current_y = input(6);
current_psi = wrapToPi(input(7));
%current_v = input(8);
%current_psi_dot = input(9);

vel_target_x = input(10);
vel_target_y = input(11);

current_pos = [current_x; current_y];

%% Jair Controller

Kp = diag([8e0 7e-2]);

eps1 = 1;     % Remark 8 in chapter 5
eps2 = 0; % Constant vector that can be made arbitrarily small
% E.G: ε1 ̸= 0, and ε2 = 0

eps = [eps1;eps2];

Delta = [1 -eps2; 0 eps1];

Delta_mp_pseudo = pinv(Delta);

target_vel = [vel_target_x; vel_target_y];

particle_pos = [radius*cos(gamma/radius) + target_x; radius*sin(gamma/radius) + target_y];

dpdgamma = [-sin(gamma/radius); cos(gamma/radius)];

R_R_I = [cos(current_psi) -sin(current_psi); sin(current_psi) cos(current_psi)];

e = R_R_I'*(current_pos - particle_pos) + eps;

gamma_dot = 15;

u = Delta_mp_pseudo*( -Kp*e + R_R_I'*target_vel + R_R_I'*(dpdgamma*gamma_dot)); % Equation 3.8

%% Define outputs

v_cmd = u(1); % Page 82 - u_ref = [v_ref ; omega_ref]
psi_dot_cmd = u(2); % Page 82

output(1) = v_cmd;
output(2) = psi_dot_cmd;
output(3) = e(1);
output(4) = e(2);

end

