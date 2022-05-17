# thesis
Code related to the development of my master thesis. The topic is the control of N drones to follow a target in a predetermined way - in particular, in a circular equidistant from each other way. The proposed code solves this problem using vector fields. 

# Files:

main.m - Run this to obtain results for the simulations.

arquitectura.slx - Simulink file with the overall structure of how the simulation works.

implemented_controller.m - Function that generates the control inputs.

draw_results.m - Function that draws the results every iteration.

start_drawing.m - Initiates the drawing of results,

testfieldvector.m - Generates an image with the unitary vectors of the generated vector field (used only for testing).

# Branches:

main - simplest working circular movement for the three UAVs, without collision avoidance.

repulsive_tests -  experimenting with adding repulsive vectors to each one of the UAVs.
