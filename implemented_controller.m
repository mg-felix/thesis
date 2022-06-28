function [output] = implemented_controller(input)
%IMPLEMENTED_CONTROLLER Calculates the control inputs to be given to the
%UAV
%   Based on the paper: https://doi.org/10.1016/j.automatica.2018.11.004

%% Definition of variables from input and output

global vel_target_x vel_target_y radius repulsive_gaussian_flag repulsive_bump_flag

% Input
target_x = input(1);
target_y = input(2);
current_x2 = input(3); % Positions of other UAVs
current_y2 = input(4);
current_x3 = input(5);
current_y3 = input(6);

l = input(7);

l_other = input(8);
l_dot_other = input(9);
u_other = input(10);
u_dot_other = input(11);

current_x = input(12);
current_y = input(13);
current_psi = wrapToPi(input(14));
current_v = input(15);
current_psi_dot = input(16);

current = [current_x; current_y];
reference = [target_x; target_y];

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

%% Repulsive UAVs vector design

r_repulsive1 = current - current2; % Creates a new vector based on the distance between the UAVs
r_repulsive2 = current - current3; % Creates a new vector based on the distance between the UAVs

% Gaussian field vector (for static objets)

A = 1000;
sigma = 100;
expected_value = [100; 100];

repulsive_gaussian = repulsive_gaussian_flag*A*exp( ( -(current - expected_value)'*(current - expected_value) )/(2*sigma^2) ); % 

vrepulsive = ( (r_repulsive1)/norm(r_repulsive1) + (r_repulsive2)/norm(r_repulsive2) ) * repulsive_gaussian; % Add if = 0 in division;


% Bump function, for dynamic environments

p = 2; % Vehicle radius
pe = eps;

dm = 2*(2*p + pe); % Minimum distance
dc = 100; %  Communication limit distance
dr = 30; % Threshold for ativation

a = -2/(dr-dc)^3; % Coefficients 
b = (3*(dr+dc))/(dr-dc)^3;
c = (-6*dr*dc)/(dr-dc)^3;
d = (dc^2*(3*dc-dr))/(dr-dc)^3;

dij1 = norm(r_repulsive1); % Distances between vehicles
dij2 = norm(r_repulsive2);

repulsive_gain = 1e3;

if dij1 >= dc
    bump1 = 0;
elseif (dij1 > dm && dij1 < dr)
    bump1 = a*dij1^3 + b*dij1^2 + c*dij1 + d;
else
    bump1 = repulsive_gain*1;
end

if dij2 >= dc
    bump2 = 0;
elseif (dij2 > dm && dij2 < dr)
    bump2 = a*dij2^3 + b*dij2^2 + c*dij2 + d;
else
    bump2 = repulsive_gain*1;
end

Frepulsive = repulsive_bump_flag*(r_repulsive1/norm(r_repulsive1)*bump1 + r_repulsive2/norm(r_repulsive2)*bump2); % Based on equations in 28 

v = v + Frepulsive; % Adds this influence to the vector field

md = v/norm(v); % Unit orientation value for the vector field in the UAV position



%% Path following controller design

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

u_psi_dot = norm(r_dot)/s * (-md_dot'*E*md - K_delta*delta)/(mr'*R'*m); % Control input - angular velocity


%% Controlling the velocity to keep them equally spaced in the path

k1 = 0.100; % Gain constants, > 0
beta = 0.06;
ku = 0.1;

theta = wrapTo2Pi(l/radius);

psi_f = wrapToPi(atan2(sin(theta),cos(theta))); % Angle of tangent on the virtual particle relative to x axis in {I}
psi_bar = wrapToPi(current_psi - psi_f) + eps;


vpx = vt(1); % Target velocity
vpy = vt(2);

wp = 0; % Target angular velocity

delta_x = radius*cos(theta); % pf - pp; Comes from virtual particle generated in simulink
delta_y = radius*sin(theta);

delta_l = 2*pi*radius/3; % Separation between vehicles

Sigma = -(vpx - wp*delta_y)*cos(psi_f) - (vpy - wp*delta_x)*sin(psi_f); 

R = [cos(psi_f) sin(psi_f); -sin(psi_f) cos(psi_f)]; % Rotation matrix from inertial to SF

Fxy = R*([current_x - (radius*cos(theta) + target_x); current_y - (radius*sin(theta) + target_y) ]); % x and y coordinates in the SF frame

Fx = Fxy(1) % Just the x coordinate
Fy = Fxy(2) % Just the y coordinate

l_dot = current_v*cos(psi_bar) + Sigma + k1*Fx; % Rate of progression of the virtual target along the desired path
l_tilde = l - l_other + delta_l; % Coordination error

u = l_dot_other - beta*tanh(ku*l_tilde); % Coordination control variable

v = (u - Sigma - k1*Fx)/abs(cos(psi_bar)); % Calculated input for velocity


%% Controlling the angular velocity

gama = 0.00001; % Constant positive gains
k2 = 6;
k_delta = 0.1;
kl = 1; % letter l, not number 1

wp_dot = 0; % Angular acceleration of target

theta_bar = p/6; % Constants, based on the values given in the simulation results
theta_zeta = pi/8;
theta_delta = theta_bar - theta_zeta;

psi_d = atan2(vpy,vpx); % Angle of target velocity in inercial x axis

delta = -theta_delta *tanh(k_delta * Fy); % Desired heading error introduced by the expected transient maneuver 

Delta = (vpx - wp*delta_y)*sin(psi_f) - (vpy + wp*delta_x)*cos(psi_f); % Normal component of the disturbance term including the velocity of the virtual target caused by the movement of P

zeta = -asin(Delta/current_v); %  Desired heading error for psi_bar caused by Delta

psi_bar_d = zeta + delta; % Desired heading error

psi_tilde = psi_bar - psi_bar_d; %  Attitude error

FwF = wp + kl*l_dot; % Angular velocity of F with respect to I, expressed in F

Fx_dot = current_v*cos(psi_bar) + FwF*Fy - l_dot + Sigma;  % MPF error dynamics
Fy_dot = current_v*sin(psi_bar) - FwF*Fx + Delta; 

delta_x_dot = l_dot*cos(psi_f) - wp*delta_y; 
delta_y_dot = l_dot*sin(psi_f) + wp*delta_x;

v_d = sqrt(vpx^2 + vpy^2); % Target total velocity
v_dot_d = 0; % Target acceleration

psi_dot_d = wp; % = wp ?

Delta_dot = v_dot_d*sin(psi_f - psi_d) + v_d*(FwF - psi_dot_d)*cos(psi_f - psi_d) + ( wp*FwF*delta_x - wp_dot*delta_y - wp*delta_y_dot)*sin(psi_f) + (-wp*FwF*delta_y - wp_dot*delta_x - wp*delta_x_dot)*cos(psi_f);

u_dot = u_dot_other - beta*ku*(u-u_other)*(sech(ku*l_tilde))^2; % after (27)

Sigma_dot = -v_dot_d*cos(psi_f - psi_d) + v_d*(FwF - psi_dot_d)*sin(psi_f - psi_d) - ( wp*FwF*delta_y + wp_dot*delta_x + wp*delta_x_dot)*sin(psi_f) + (wp_dot*delta_y + wp*delta_y_dot - wp*FwF*delta_x)*cos(psi_f);

psi_f_dot = l_dot/radius; % ???

psi_bar_dot = current_psi_dot - psi_f_dot; % psi_dot - psi_f_dot ??

v_dot = (u_dot - Sigma_dot - k1*Fx_dot) /cos(psi_bar) + current_v *psi_bar_dot*tan(psi_bar); % (25)

psi_bar_d_dot = -theta_delta*k_delta*(sech(k_delta*Fy))^2 * Fy_dot - Delta_dot/sqrt(current_v^2 - Delta^2) + Delta*v_dot/(current_v*sqrt(current_v^2 - Delta^2)); % (16)

psi_dot = wp + kl*l_dot + psi_bar_d_dot + gama*Fy*current_v*(( sin(psi_bar) - sin(psi_bar_d) )/(psi_bar - psi_bar_d)) - k2*psi_tilde; 

%% Make it different for the leader UAV

if l_dot_other == l_other && l_other == -1000
    v = current_v;
    u = l_dot;
end


%% Outputs the results

v_cmd = v; 
psi_dot_cmd = psi_dot;

output(1) = v_cmd; 
output(2) = psi_dot_cmd;

output(3) = l;
output(4) = l_dot;
output(5) = u;
output(6) = u_dot;

err = norm(current - reference) - radius;

caption = sprintf('Error = %f \nDistances = %f, %f, %f\n Heading angular velocity = %f\nVelocity = %f', err, norm(current-current2), norm(current-current3), norm(current2-current3), psi_dot_cmd, v_cmd);
title(caption, 'FontSize', 20);

end

