%% DC Motor Model Parameters
clc;
clear;
close all;

% Electrical parameters
Ra = 2.5;        % Armature resistance (Ohm)
L  = 0.055;      % Armature inductance (H)

% Mechanical parameters
J  = 0.068;      % Rotor inertia (kg.m^2)
b  = 0.03475;    % Viscous friction coefficient

% Motor constants
Kma = 0.127;     % Motor torque constant
Kb  = 0.125;     % Back EMF constant

% Operating conditions
Va = 20;         % Armature voltage (V)
Tl = 20;         % Load torque (Nm)

%% Define Laplace Variable
s = tf('s');

%% Armature (Electrical) Transfer Function
% Ia(s) / [Va(s) - Eb(s)]

G_armature = 1 / (Ra + L*s);

num_armature = G_armature.Numerator{1};
den_armature = G_armature.Denominator{1};

%% Mechanical (Load) Transfer Function
% w(s) / T(s)

G_load = 1 / (b + J*s);

num_load = G_load.Numerator{1};
den_load = G_load.Denominator{1};

%% Display Transfer Functions
disp('Armature Transfer Function:')
G_armature

disp('Mechanical Load Transfer Function:')
G_load