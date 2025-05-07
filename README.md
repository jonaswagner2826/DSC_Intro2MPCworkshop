# Intro To Model Predictive Control - DSC Workshop
Event Details
- **Location:** ECSW 3.325 (Systems and Controls Lab)
- **Time:** Friday 2025-05-02 @ 14:00-16:00
- **Organizers:** Juned Shaikh and Michael Lingad
- **Acknowledgments:** Jonas Wagner, Yi Tian, and Dr. Justin Koeln

## Into to MPC
See the powerpoint for information on the basics of MPC

### Active Suspension System Modeling
See the document [docs\Active Suspension - Laboratory Guide.pdf]() for derivation of the model and implementation of an LQR controller (aka an infinite/steady-state MPC controller).

1. Write out the state-space model for the system.
   - What are the states, inputs, and outputs of the system?
   - Is the system internally stable?
2. Find the open-loop transfer function for the system between both the input and disturbance to outputs.
(Hint: Use MATLAB with tf(sys) or zpk(sys) where sys = ss(A,B,C,D))   
   - What is the impact of disturbance upon the top-plate height (i.e. impact of road on occupant vertical velocity)
      (Hint: For the QUARC derived model it is $u_1$ and $y_2$.)
   - Which set of dimensions are most important to designing for rider comfort? 
      (Hint: Using $\dot{x}_{2}$ instead of $y_2$ is equivalent when $u_1$ is centered around 0 and eliminates feed-forward terms.)

### Simulation
1. Open [matlab\mpc_Sim.mlx]() and enter in the model matrices
2. Test the open loop model simulation and observe the results
   - Does the plot make sense? What does each subplot represent?
   - What is the impact of disturbances? What does that represent?
3. Implement and tune a PD controller to improve the disturbance response
   - How were the selected gains obtained? 
   - Did you use some design process or just tune using a rule of thumb and tune?
4. Implement an MPC controller by designing weight matrices. 
(Hint: use diag([w_1,w_2,w_3,w_4]); to create weight matrices)
   - What does setting each weight mean?

### Experimental
1. Open [matlab\setup_as.m]() and enter selected MPC weight matrices from simulation
2. Open [matlab\q_as_mpc.slx]() then follow QUARC steps to build and connect to the Active Suspension System
3. Experiment with different weights to observe the response.
   - How might you prioritize minimizing the impact of a bump felt by an occupant?
4. Directly compare the MPC results with the LQR controller with the same weights.
   - How does this impact the response of 

## (Bonus) Frequency Response Analysis
1. Theory: Create bode plots for the open loop and closed-loop (w/ LQR) responses.
   - What is the underlying resonant frequency?
   - Is the LQR controller effective at the resonant frequency? Do different gains improve this?
2. Simulation: Test the response of the closed-loop system to different frequencies of inputs and create a bode plot
   - Is there a substantial difference between the MPC and LQR controllers when the inputs are known?
   - How does this compare to the theoretical bode diagrams for open and closed-loop?
3. Experimental: Perform the same tests and analysis as in simulation.
