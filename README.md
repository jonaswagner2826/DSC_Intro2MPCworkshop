# Intro To Model Predictive Control - DSC Workshop


## Into to MPC
See the powerpoint for information on the basics of MPC


## Active Suspension System Modeling
See the document [docs\Active Suspension - Laboratory Guide.pdf]() for derivation of the model and implementation of an LQR controller (aka an infinite/steady-state MPC controller).


## Simulation
1. Open [matlab\mpc_Sim.mlx]() and enter in the model matrices.
2. Test the open loop model simulation and observe the results
   - Does the plot make sense? What does each subplot represent?
   - What is the impact of disturbances? What does that represent?
3. Implement and tune a PD controller to improve the disturbance response
   - How were the selected gains obtained? Did you use some design process or just tune using a rule of thumb and tune?
4. Implement an MPC controller by designing weight matrices. 
(Hint: use diag([w_1,w_2,w_3,w_4]); to create weights)
