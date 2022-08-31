%% MAIN FILE 

% Consists in values definitions and calling the simulink block diagram 
% where the controlling loop is implemented. After that, a function is
% called to show the results of the simulation in a graphic way.

%% Constants Definitions and Initial Conditions

clear all;
clc;
close all;

global Ts Ttotal x0 y0 def_seed vel_target_x vel_target_y radius
global max_vel min_vel max_psi min_psi % Global variables to be used throughout the program
global drone1_x0 drone1_y0 drone2_x0 drone2_y0 drone3_x0 drone3_y0 drone1_psi0 drone2_psi0 drone3_psi0 N

def_seed = randi(1000); % Defines random seed for random target movement

% TIME VARIABLES 
       
fs = 20;
Ts = 1/20; % Sampling time
Ttotal = 150; % Total simulation time

% TARGET VARIABLES

vel_target_x = sqrt(3^2/2);
vel_target_y = sqrt(3^2/2);;

a_target_x = 0;
a_target_y = 0;

w_target = 0;   

radius = 200; % Radius for the virtual references

% TARGET INITIAL CONDITIONS

x0 = 0; % Starting coordinates
y0 = 0; % Starting coordinates

% UAVs VARIABLES

N = 3; % Number of UAVs

max_vel = 20; % Maximum allowed UAV velocity
min_vel = 5; % Minimum allowed UAV velocity
max_psi = pi/4; % Maximum allowed UAV rotation (psi dot)
min_psi = -pi/4; % Minimum allowed UAV rotation (psi dot)

% UAVs INITIAL CONDITIONS 

drone1_x0 = -200; % Initial Coordinates for each UAV
drone1_y0 = -200;
drone2_x0 = -200;
drone2_y0 = -250;
drone3_x0 = -200;
drone3_y0 = -300;

drone1_v0 = 15; % Initial velocities for each UAV
drone2_v0 = 20;
drone3_v0 = 20;

drone1_psi0 = 0.0001; % In rad
drone2_psi0 = 0.0001;
drone3_psi0 = 0.0001;
    
%% Starts showing the results

start_drawing;

%% Calling simulink file 

sim('jair_architecture');

%% Plot error results and UAV paths

close all;

show_results(ans);