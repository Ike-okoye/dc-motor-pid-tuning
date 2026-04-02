%% Genetic Algorithm PID Tuning for DC Motor
clc;
clear;
close all;

%% Define PID Parameter Bounds
% [Kp Ki Kd]
lower_bounds = [0 0 0];
upper_bounds = [50 100 50];   % Larger derivative gain allows better damping

%% Genetic Algorithm Options
options = optimoptions('ga', ...
    'Display','iter', ...
    'UseParallel', false);

%% Run Genetic Algorithm Optimization
[x_opt, ~] = ga(@GA_fitness_function, 3, [], [], [], [], ...
                lower_bounds, upper_bounds, [], options);

%% Extract Optimized PID Gains
Kp = x_opt(1);
Ki = x_opt(2);
Kd = x_opt(3);

fprintf('\nOptimal PID Parameters:\n');
fprintf('Kp = %.3f\n', Kp);
fprintf('Ki = %.3f\n', Ki);
fprintf('Kd = %.3f\n', Kd);

%% Define DC Motor Transfer Function
G = tf(44.99, [1 44.98 78.962 0]);

%% Construct PID Controller
C = pid(Kp, Ki, Kd);

%% Closed-Loop System
T = feedback(C*G, 1);

%% Step Response Analysis
t_final = 10;
[y, t] = step(T, t_final);

performance = stepinfo(T);

%% Display Performance Metrics
fprintf('\nPerformance Metrics:\n');
fprintf('Rise Time      : %.3f s\n', performance.RiseTime);
fprintf('Settling Time  : %.3f s\n', performance.SettlingTime);
fprintf('Overshoot      : %.2f %%\n', performance.Overshoot);
fprintf('Peak Value     : %.3f\n', performance.Peak);

%% Plot Step Response
figure;
step(T, t_final);
grid on;
title('GA-Tuned PID Controller Step Response');
xlabel('Time (s)');
ylabel('Motor Speed');