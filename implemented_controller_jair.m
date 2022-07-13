function [output] = implemented_controller_jair(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Define inputs

global vel_target_x vel_target_y radius

target_x = input(1);
target_y = input(2);
gamma = input(3);
%gamma_other = input(4);

current_x = input(4);
current_y = input(5);
current_psi = wrapToPi(input(6));
current_v = input(7);
current_psi_dot = input(8);


current_pos = [current_x; current_y];

%% Jair Controller

Kp = diag([10 500000]);

eps1 = 0.1;     % Remark 8 in chapter 5
eps2 = 0; % Constant vector that can be made arbitrarily small
% E.G: ε1 ̸= 0, and ε2 = ε3 = 0 (doesn't work: Delta+ = NaN)

eps = [eps1;eps2];

Delta = [1 -eps2; 0 eps1];

Delta_mp_pseudo = pinv(Delta);

target_vel = [vel_target_x; vel_target_y];

particle_pos = [radius*cos(gamma/radius) + target_x; radius*sin(gamma/radius) + target_y];

dpdgamma = [-sin(gamma) ; cos(gamma)];

R_R_I = [cos(current_psi) -sin(current_psi); sin(current_psi) cos(current_psi)];

target_angle = atan2(vel_target_y, vel_target_x);

R_T_I = [cos(target_angle) -sin(target_angle); sin(target_angle) cos(target_angle)];

% wRR = [0; 0; current_psi_dot];

% S_w = [0 -wRR(3) wRR(2); wRR(3) 0 -wRR(1); -wRR(2) wRR(1) 0]; % Based on https://math.stackexchange.com/questions/258775/from-a-vector-to-a-skew-symmetric-matrix

e = R_R_I'*(current_pos - particle_pos) + eps;

vd = 15; % Constant speed to be tracked - particle speed along the path

% u = Delta_mp_pseudo*( -Kp*e + R_R_I'*target_vel + R_R_I'*(R_T_I*S_w*particle_pos + R_T_I*dpdgamma*vd) ); % Equation 5.7

u = Delta_mp_pseudo*( -Kp*e + R_R_I'*target_vel + R_R_I'*(dpdgamma*vd)); % Equation 3.8

n = e'*R_T_I*dpdgamma;

% Saturation function

kn = 0.3*vd; % Constant positive gain

if n>1
    g = 1*kn;
elseif n<-1 
    g = -1*kn;
else
    g = kn*n;
end

vr = 0;%-30;% -(gamma - gamma_other);

gamma_dot = vd + g + vr;

%% Define outputs

v_cmd = u(1); % Page 82 - u_ref = [v_ref ; omega_ref]
psi_dot_cmd = u(2); % Page 82

output(1) = v_cmd;
output(2) = psi_dot_cmd;
output(3) = gamma_dot;


end

