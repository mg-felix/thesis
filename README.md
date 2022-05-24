# thesis
Code related to the development of my master thesis. The topic is the control of N drones to follow a target in a predetermined way - in particular, in a circular path - equidistant from each other. The proposed code solves this problem using vector fields. A collision avoidance algorithm is also implemented.

# Files:

main.m - Run this to obtain results for the simulations.

arquitectura.slx - Simulink file with the overall structure of how the simulation works.

implemented_controller.m - Function that generates the control inputs.

draw_results.m - Function that draws the results every iteration.

start_drawing.m - Initiates the drawing of results.

testfieldvector.m - Generates an image with the unitary vectors of the generated vector field (used only for testing).

# Branches:

main - working implemented controller for 3 UAVs with the following features: collision avoidance, circular path following around a moving target (MPF using Vector Fields).

cooperative_field_vector_approach - implementing the paper in https://doi.org/10.1016/j.conengprac.2022.105184.
