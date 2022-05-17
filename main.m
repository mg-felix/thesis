%% MAIN FILE 

% Consists in values definitions and calling the simulink block diagram 
% where the controlling loop is implemented.

%% Constants Definitions and Initial Conditions

clear all;
clc;
close all;

global Ts Ttotal x0 y0 def_seed vel_target r 
global probability_of_changing  target_velocity N max_vel min_vel max_psi min_psi % Global variables to be used throughout the program
global drone1_x0 drone1_y0 drone2_x0 drone2_y0 drone3_x0 drone3_y0 drone1_psi0 drone2_psi0 drone3_psi0 gama_dot_constant

def_seed = randi(1000); % Defines random seed for random target movement

% TIME VARIABLES 

Ts = 0.05; % Sampling time
Ttotal = 500; % Total simulation time

% TARGET INITIAL CONDITIONS
x0 = 0; % Starting coordinates
y0 = 0; % Starting coordinates

gama_dot_constant = 0.5;

target_velocity = 0; % Defines the constant velocity of the target in a non random trajectory for straight line; 

probability_of_changing = 0; % Probability of target not changing its direction (between 0 and 1)
% Mudar para o simulink ser só um flip no switch

% UAVs VARIABLES

N = 3; % Number of UAVs
vel_target = 1; % Defines Virtual Targets Velocities in rad/s, not the actual value
r = 50; % Distance radius from real target~
max_vel = 20; % Maximum allowed UAV velocity
min_vel = 5; % Minimum allowed UAV velocity
max_psi = pi/2; % Maximum allowed UAV rotation (psi dot)
min_psi = -pi/2; % Minimum allowed UAV rotation (psi dot)

% UAVs INITIAL CONDITIONS 

drone1_x0 = 50; % Initial Coordinates for each UAV
drone1_y0 = 50;
drone2_x0 = 100;
drone2_y0 = 100;
drone3_x0 = 200;
drone3_y0 = 200;

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