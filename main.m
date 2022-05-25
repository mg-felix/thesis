%% MAIN FILE 

% Consists in values definitions and calling the simulink block diagram 
% where the controlling loop is implemented.


%% Constants Definitions and Initial Conditions

clear all;
clc;
close all;

global Ts Ttotal x0 y0 def_seed vel_target_x vel_target_y theta_dot_constant radius
global max_vel min_vel max_psi min_psi % Global variables to be used throughout the program
global drone1_x0 drone1_y0 drone2_x0 drone2_y0 drone3_x0 drone3_y0 drone1_psi0 drone2_psi0 drone3_psi0

def_seed = randi(1000); % Defines random seed for random target movement

% TIME VARIABLES 

Ts = 0.05; % Sampling time
Ttotal = 200; % Total simulation time

% TARGET VARIABLES

vel_target_x = sqrt(6^2/2);
vel_target_y = 0;

theta_dot_constant = 0.0001; % How much the path moves after Ts seconds, evey Ts, theta increases 1. And the position is calculated as cos(theta*theta_dot_constant).
radius = 200; % Radius for the virtual references

% TARGET INITIAL CONDITIONS

x0 = 0; % Starting coordinates
y0 = 0; % Starting coordinates

% UAVs VARIABLES

max_vel = 20; % Maximum allowed UAV velocity
min_vel = 5; % Minimum allowed UAV velocity
max_psi = pi/4; % Maximum allowed UAV rotation (psi dot)
min_psi = -pi/4; % Minimum allowed UAV rotation (psi dot)

% UAVs INITIAL CONDITIONS 

drone1_x0 = 50; % Initial Coordinates for each UAV
drone1_y0 = 50;
drone2_x0 = 60;
drone2_y0 = 60;
drone3_x0 = 70;
drone3_y0 = 70;

drone1_v0 = 20; % Initial velocities for each UAV
drone2_v0 = 20;
drone3_v0 = 20;

drone1_psi0 = 0; % In rad
drone2_psi0 = 0;
drone3_psi0 = 0;

%% Starts showing the results

start_drawing;

%% Calling simulink file 

 sim('arquitetura');