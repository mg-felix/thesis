# thesis
Code related to the development of my master thesis. The topic is the control of N drones to follow a target in a predetermined way - in particular, in a circular path - equidistant from each other. The proposed code solves this problem using vector fields. A collision avoidance algorithm is also implemented.
The implementation assumes the following: 

- The positions of all vehicles are known by every vehicle. 
- The target position and velocity are known by every agent.
- It's possible to directly control the velocity and the heading angle rate (through an automatic pilot, for instance).

# Files:

multi_main.m - Run this to obtain start the simulations.

vehicle_controller.m - Implemented control law function to steer the vehicles.

coordinated_control.m - Implemented control law for coordination of particles.

multi_architecture.slx - Simulink file with implemented architecture.

multi_start_drawing.m - Initializes live figure with results.

multi_draw_results.m - Draws/shows live results.

multi_show_results.m - Shows final results.


# Branches

main - working implemented controller for 3 UAVs with moving path following. Papers used: https://doi.org/10.1016/j.automatica.2018.11.004 and https://sigarra.up.pt/feup/pt/teses.tese?P_ALUNO_ID=118694&p_processo=22154

# Files (old):

main.m - Run this to obtain results for the simulations.

arquitectura.slx - Simulink file with the overall structure of how the simulation works.

implemented_controller.m - Function that generates the control inputs.

draw_results.m - Function that draws the results every iteration.

start_drawing.m - Initiates the drawing of results.

show_results.m - Shows the results at the end of the simulation. Data on errors, speed and positions through time.

testfieldvector.m - Generates an image with the unitary vectors of the generated vector field (used only for testing).

# Branches (old):

main - working implemented controller for 3 UAVs with the following features: collision avoidance, circular path following around a moving target (MPF using Vector Fields).

Reference Papers:

[1] - https://doi.org/10.1016/j.ifacol.2017.08.1340 - to design a vector field and control the heading angle rate based on that field.

[2] - https://doi.org/10.1016/j.automatica.2018.11.004 - to coordinate the vehicles speeds and keep the UAV equidistant.

[3] - https://doi.org/10.48550/arXiv.1404.5828 - to create the repulsive vectors around each UAV. Proved convergence for dynamic environements.

[4] - https://doi.org/10.1109/ICRA.2014.6907828 - to create the repulsive vectors around each UAV. (still need to prove the convergence mathematically to use it).

----------------------------------------------------------------------------------------------------------------------------
