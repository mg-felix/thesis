function output = coordination_controller(input)
%COORDINATION_CONTROL Summary of this function goes here
%   Detailed explanation goes here

%% Defines the inputs

global delta_gamma

gamma = input(1);
gamma_other = input(2);
gamma_dot_other = input(3);

%% Particle position control 

% Gains

Ku = 0.1;
beta = 50;

gamma_tilde = gamma - gamma_other + delta_gamma;
gamma_dot = gamma_dot_other - beta*tanh(Ku*gamma_tilde);

%% Outputs the results

output(1) = gamma_dot;

end

