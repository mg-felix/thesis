# thesis
Code related to the development of my master thesis. The topic is the control of N drones to follow a target in a predetermined way - in particular, in a circular path - equidistant from each other. The proposed code solves this problem using vector fields. A collision avoidance algorithm is also implemented.
The implementation assumes the following: 

- The positions of all vehicles are known by every vehicle. 
- The target position and velocity are known by every agent.
- It's possible to directly control the velocity and the heading angle rate (through an automatic pilot, for instance).

# Files:

main.m - Run this to obtain results for the simulations.

arquitectura.slx - Simulink file with the overall structure of how the simulation works.

implemented_controller.m - Function that generates the control inputs.

draw_results.m - Function that draws the results every iteration.

start_drawing.m - Initiates the drawing of results.

testfieldvector.m - Generates an image with the unitary vectors of the generated vector field (used only for testing).

# Branches:

main - working implemented controller for 3 UAVs with the following features: collision avoidance, circular path following around a moving target (MPF using Vector Fields).

coordinated-error - follows the work implemented in the 3 reference paper mentioned. 

Reference Papers:

[1] - https://doi.org/10.1016/j.ifacol.2017.08.1340 - to design a vector field and control the heading angle rate based on that field. 

[2] - https://doi.org/10.1109/ICRA.2014.6907828 - to create the repulsive vectors around each UAV.

----------------------------------------------------------------------------------------------------------------------------

[3] - https://doi.org/10.1016/j.conengprac.2022.105184 - a different approach where a path is defined for each UAV and a coordinated error is used to calculate the velocity inputs so that each vehicle stays at 120 degrees spaced of each other. It also follows the vector field approach.
