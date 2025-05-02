% SETUP_AS

clear all

% ############### USER-DEFINED ACTIVE SUSPENSION CONFIGURATION ###############
%CONTROL TYPE CAN BE SET TO 'AUTO' OR 'MANUAL'. 
CONTROL_TYPE = 'AUTO';

% ###############MODEL PARAMETERS###############

ks = 900;% or 1040 Suspension Stiffness (N/m) 
kt = 2500;% or 2300
kus = kt;% Tire stiffness (N/m)
ms = 2.45;% or 2.5 Sprung Mass (kg) 
mu = 1;% or 1.150
mus = mu;% Unsprung Mass (kg)
bs = 7.5;% Suspension Inherent Damping coefficient (sec/m)
bus = 5;% Tire Inhenrent Damping coefficient (sec/m)

%Set the model parameters of the Active Suspension.
%This section sets the A,B,C and D matrices for the Active Suspension model.

A = [ 0 1 0 -1 ;
    -ks/ms -bs/ms 0 bs/ms;
    0 0 0 1;
    ks/mu bs/mu -kt/mu -(bs+bus)/mu];
B = [0  0 ; 0 1/ms ; -1  0 ; bus/mu -1/mu ];
C = [ 1 0 0 0 ; -ks/ms -bs/ms 0 bs/ms];
D = zeros(2,2); D(2,2)=1/ms;


%% MPC Setup
sys_mpc = ss(A,B,eye(4),0);
sys_mpc.InputName = {'zdot_r','F_z'};
sys_mpc.StateName = {'z_s-z_us','zdot_s','z_us-z_r','zdot_us'};
sys_mpc.OutputName = {'z_s-z_us','zdot_s','z_us-z_r','zdot_us'};
sys_mpc.InputGroup.MV = 2;
sys_mpc.InputGroup.MD = 1;
sys_mpc.OutputGroup.MO = 1:4;

Ts = 0.01; % sample time
ctr_mpc = mpc(sys_mpc,Ts); % MPC Controller

%% MPC Design Paramteters
p = 20; % Predicted Horizon
m = p; % Control Horizon
Q = ;  % State Weights
R = ; % Input Weights
wt_y = diag(Q)'; wt_u = R;
umin = -30; umax = -umin; % input constraints
ymin(1:4) = -inf; ymin(2) = -0.01; ymax = -ymin; % output constraints
ref = [0;0;0;0]; % constraints

% LQR Controller ($\infty$ MPC)
K = lqr( A, B(:,2), Q, R );

%% specify prediction horizons
ctr_mpc.PredictionHorizon = p;
ctr_mpc.ControlHorizon = m;
%% specify nominal values for inputs and outputs
ctr_mpc.Model.Nominal.U = [0;0];
ctr_mpc.Model.Nominal.Y = [0;0;0;0];
%% constraints
% input constraints
ctr_mpc.MV(1).min = -30;
ctr_mpc.MV(1).max = 30;
% state constraints
ctr_mpc.OV(2).min = -0.1;
ctr_mpc.OV(2).max = 0.1;
%% specify weights
ctr_mpc.Weights.MV = R;
ctr_mpc.Weights.MVRate = 0;
ctr_mpc.Weights.OV = diag(Q)';
ctr_mpc.Weights.ECR = 100000;
%% specify simulation options
options = mpcsimopt();
options.RefLookAhead = 'on';
options.MDLookAhead = 'on';
options.Constraints = 'off';
options.OpenLoop = 'off';

display(ctr_mpc)
%%
% mpcDesigner(ctr_mpc)



