%% Ziegler–Nichols PID Tuning for DC Motor
clc;
clear;
close all;

%% Define Laplace Variable
s = tf('s');

%% Define Plant (DC Motor Transfer Function)
P = 44.99 / (s^3 + 44.98*s^2 + 78.962*s);

%% Initial Closed-Loop Response (for visualization)
Kp_initial = 1;              % small proportional gain
C_initial = Kp_initial;

T_initial = feedback(C_initial * P, 1);

figure;
step(T_initial);
title('Initial Closed-Loop Response (Low Gain)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Ziegler–Nichols Ultimate Gain Method Parameters
Ku = 79;     % Ultimate gain (determined experimentally)
Pu = 0.7;    % Ultimate oscillation period (s)

%% Compute Ziegler–Nichols PID Gains
Kp = 0.6 * Ku;
Ti = Pu / 2;
Td = Pu / 8;

Ki = Kp / Ti;
Kd = Kp * Td;

%% Build PID Controller
C = pid(Kp, Ki, Kd);

%% Closed-Loop System
T_pid = feedback(C * P, 1);

%% Step Response
figure;
step(T_pid);
title('Step Response with Ziegler–Nichols PID Controller');
xlabel('Time (s)');
ylabel('Output');
grid on;

%% Performance Analysis
info = stepinfo(T_pid,'SettlingTimeThreshold',0.02);

settling_time = info.SettlingTime;
rise_time     = info.RiseTime;
peak          = info.Peak;
overshoot     = info.Overshoot;

%% Display Step Response Metrics
fprintf('\nStep Response Metrics:\n');
fprintf('Settling Time : %.4f s\n', settling_time);
fprintf('Rise Time     : %.4f s\n', rise_time);
fprintf('Peak Value    : %.4f\n', peak);
fprintf('Overshoot     : %.4f %%\n', overshoot);

%% Display Ziegler–Nichols Parameters
fprintf('\nZiegler–Nichols Tuning Parameters:\n');
fprintf('Ultimate Gain (Ku)  : %.4f\n', Ku);
fprintf('Ultimate Period (Pu): %.4f s\n', Pu);
fprintf('Kp                  : %.4f\n', Kp);
fprintf('Ki                  : %.4f\n', Ki);
fprintf('Kd                  : %.4f\n', Kd);