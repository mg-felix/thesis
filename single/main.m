%% MAIN FILE 

% Consists in values definitions and calling the simulink block diagram 
% where the controlling loop is implemented. After that, a function is
% called to show the results of the simulation in a graphic way.

%% Constants Definitions and Initial Conditions

clear all;
clc;
close all;

global Ts Ttotal x0 y0 def_seed radius delta_gamma gamma_dot_leader volta
global max_vel min_vel max_psi min_psi % Global variables to be used throughout the program
global drone1_x0 drone1_y0 drone1_psi0 N
global target_velocity_amplitude target_velocity_frequency target_psi_dot_amplitude target_psi_dot_frequency target_velocity_bias

def_seed = randi(1000); % Defines random seed for random target movement

% TIME VARIABLES 
       
fs = 100;
Ts = 1/fs; % Sampling time
Ttotal = 100; % Total simulation time

% TARGET VARIABLES

target_velocity_amplitude = 0.1;
target_velocity_frequency = 0.07;
target_velocity_bias = 0;
target_psi_dot_amplitude = 0.02;
target_psi_dot_frequency = 0.03;


radius = 200; % Radius for the virtual references
volta = 1; % Selects turn direction in the path: 1 is to the right and -1 is to the left

% TARGET INITIAL CONDITIONS

x0 = 0; % Starting coordinates
y0 = 0; % Starting coordinates

% UAVs VARIABLES

N = 1; % Number of UAVs

max_vel = 20; % Maximum allowed UAV velocity
min_vel = 5; % Minimum allowed UAV velocity
max_psi = pi/4; % Maximum allowed UAV rotation (psi dot)
min_psi = -pi/4; % Minimum allowed UAV rotation (psi dot)

% UAVs INITIAL CONDITIONS 

drone1_x0 = -200; % Initial Coordinates for each UAV
drone1_y0 = -200;

drone1_v0 = 20; % Initial velocities for each UAV

drone1_psi0 = pi; % In rad

% PARTICLE VARIABLES

delta_gamma = 2*pi*radius/3;
gamma_dot_leader = 15;
    
%% Starts showing the results

single_start_drawing;

%% Calling simulink file 

sim('single_vehicle');

%% Plot error results and UAV paths

close all;

single_show_results(ans.simulation_data);