%% Cohen–Coon PID Tuning for DC Motor
clc;
clear;
close all;

%% Define Laplace Variable
s = tf('s');

%% Define Plant (DC Motor Transfer Function)
P = 44.99 / (s^3 + 44.98*s^2 + 78.962*s);

% Extract numerator and denominator (optional)
numP = P.Numerator{1};
denP = P.Denominator{1};

%% Plot Open-Loop Step Response
figure;
step(P,10);
title('Open-Loop Step Response of DC Motor');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Cohen–Coon Process Parameters
K   = 5.37;   % Process gain
L   = 0.05;   % Dead time (s)
tau = 6.49;   % Time constant (s)

%% Compute Cohen–Coon PID Parameters
Kp = (tau/L + 0.333) / K;
Ti = tau * ((30 + 3*(L/tau)) / (9 + 20*(L/tau)));
Td = tau * ((L/tau) / (11 + 2*(L/tau)));

Ki = Kp / Ti;
Kd = Kp * Td;

%% Build PID Controller
C = Kp + Ki/s + Kd*s;

%% Closed-Loop System
T_pid = feedback(C * P, 1);

%% Step Response of Closed-Loop System
figure;
step(T_pid);
title('Step Response with Cohen–Coon PID Controller');
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

%% Display Cohen–Coon Tuning Parameters
fprintf('\nCohen–Coon Tuning Parameters:\n');
fprintf('Process Gain (K) : %.4f\n', K);
fprintf('Delay (L)        : %.4f s\n', L);
fprintf('Time Constant τ  : %.4f s\n', tau);
fprintf('Kp               : %.4f\n', Kp);
fprintf('Ki               : %.4f\n', Ki);
fprintf('Kd               : %.4f\n', Kd);