%% PID Controller Comparison: GA vs ZN vs Cohen-Coon
clc
clear
close all

%% Laplace variable
s = tf('s');

%% DC Motor Plant
P = 44.99/(s^3 + 44.98*s^2 + 78.962*s);

%% -------------------------------------------------------
%% Controller Gains (from tuning scripts)

% Genetic Algorithm
Kp_GA = 24.799;
Ki_GA = 0.000;
Kd_GA = 15.005;

% Ziegler-Nichols
Kp_ZN = 47.4000;
Ki_ZN = 135.4286;
Kd_ZN = 4.1475;

% Cohen-Coon
Kp_CC = 24.2333;
Ki_CC = 1.1385;
Kd_CC = 0.1100;

%% -------------------------------------------------------
%% Controllers (match GA tuning structure)

C_GA = Kp_GA + Ki_GA/s + Kd_GA*s;
C_ZN = Kp_ZN + Ki_ZN/s + Kd_ZN*s;
C_CC = Kp_CC + Ki_CC/s + Kd_CC*s;

%% Closed-loop systems
T_GA = feedback(C_GA*P,1);
T_ZN = feedback(C_ZN*P,1);
T_CC = feedback(C_CC*P,1);

%% -------------------------------------------------------
%% Stability Check

fprintf('\nController Stability\n')

fprintf('GA: %d\n',isstable(T_GA))
fprintf('ZN: %d\n',isstable(T_ZN))
fprintf('CC: %d\n',isstable(T_CC))

%% -------------------------------------------------------
%% Simulation Time
t = 0:0.01:10;

%% Step responses
[y_GA,t] = step(T_GA,t);
[y_ZN,~] = step(T_ZN,t);
[y_CC,~] = step(T_CC,t);

%% -------------------------------------------------------
%% Tracking Errors

e_GA = 1 - y_GA;
e_ZN = 1 - y_ZN;
e_CC = 1 - y_CC;

%% -------------------------------------------------------
%% Error Indices

ISE_GA = trapz(t,e_GA.^2);
ISE_ZN = trapz(t,e_ZN.^2);
ISE_CC = trapz(t,e_CC.^2);

IAE_GA = trapz(t,abs(e_GA));
IAE_ZN = trapz(t,abs(e_ZN));
IAE_CC = trapz(t,abs(e_CC));

ITAE_GA = trapz(t,t.*abs(e_GA));
ITAE_ZN = trapz(t,t.*abs(e_ZN));
ITAE_CC = trapz(t,t.*abs(e_CC));

%% -------------------------------------------------------
%% Control Effort (unity feedback approximation)

u_GA = e_GA;
u_ZN = e_ZN;
u_CC = e_CC;

%% Control Energy

CE_GA = trapz(t,u_GA.^2);
CE_ZN = trapz(t,u_ZN.^2);
CE_CC = trapz(t,u_CC.^2);

%% -------------------------------------------------------
%% Step Performance Metrics

info_GA = stepinfo(T_GA);
info_ZN = stepinfo(T_ZN);
info_CC = stepinfo(T_CC);

Method = ["Genetic Algorithm";"Ziegler-Nichols";"Cohen-Coon"];

RiseTime = [info_GA.RiseTime;info_ZN.RiseTime;info_CC.RiseTime];
SettlingTime = [info_GA.SettlingTime;info_ZN.SettlingTime;info_CC.SettlingTime];
Overshoot = [info_GA.Overshoot;info_ZN.Overshoot;info_CC.Overshoot];

ISE = [ISE_GA;ISE_ZN;ISE_CC];
IAE = [IAE_GA;IAE_ZN;IAE_CC];
ITAE = [ITAE_GA;ITAE_ZN;ITAE_CC];

ControlEnergy = [CE_GA;CE_ZN;CE_CC];

Results = table(Method,RiseTime,SettlingTime,Overshoot,ISE,IAE,ITAE,ControlEnergy);

disp('Controller Performance Comparison')
disp(Results)

%% -------------------------------------------------------
%% -------------------------------------------------------
%% -------------------------------------------------------
%% Step Response Comparison (Single Axis)

figure
plot(t,y_GA,'LineWidth',2)
hold on
plot(t,y_ZN,'LineWidth',2)
plot(t,y_CC,'LineWidth',2)

yline(1,'--')

legend('GA PID','Ziegler-Nichols PID','Cohen-Coon PID','Location','best')

title('Step Response Comparison')
xlabel('Time (s)')
ylabel('Motor Speed')

grid on
%% -------------------------------------------------------
%% -------------------------------------------------------
%% -------------------------------------------------------
%% Control Effort Comparison (Single Axis)

figure
plot(t,u_GA,'LineWidth',2)
hold on
plot(t,u_ZN,'LineWidth',2)
plot(t,u_CC,'LineWidth',2)

legend('GA PID','Ziegler-Nichols PID','Cohen-Coon PID','Location','best')

title('Control Effort Comparison')
xlabel('Time (s)')
ylabel('Control Signal u(t)')

grid on

%% -------------------------------------------------------
%% Error Index Comparison (Log Scale)

ErrorMetrics = [
ISE_GA IAE_GA ITAE_GA
ISE_ZN IAE_ZN ITAE_ZN
ISE_CC IAE_CC ITAE_CC
];

figure
bar(ErrorMetrics)

set(gca,'YScale','log')

set(gca,'XTickLabel',{'Genetic Algorithm','Ziegler-Nichols','Cohen-Coon'})

legend('ISE','IAE','ITAE')

xlabel('Controller Type')
ylabel('Error Value (Log Scale)')

title('Error Performance Index Comparison')

grid on

%% -------------------------------------------------------
%% Radar Chart Performance Comparison

% Metrics matrix
metrics = [
RiseTime SettlingTime Overshoot ISE IAE ITAE ControlEnergy
];

labels = {'Rise Time','Settling Time','Overshoot','ISE','IAE','ITAE','Control Energy'};

% Normalize metrics (lower = better)
metrics_norm = metrics ./ max(metrics);

% Close the radar polygons
metrics_norm = [metrics_norm metrics_norm(:,1)];

% Angular positions
numMetrics = size(metrics_norm,2);
theta = linspace(0,2*pi,numMetrics);

figure
polarplot(theta,metrics_norm(1,:),'LineWidth',2)
hold on
polarplot(theta,metrics_norm(2,:),'LineWidth',2)
polarplot(theta,metrics_norm(3,:),'LineWidth',2)

p1 = polarplot(theta,metrics_norm(1,:),'LineWidth',2);
p2 = polarplot(theta,metrics_norm(2,:),'LineWidth',2);
p3 = polarplot(theta,metrics_norm(3,:),'LineWidth',2);

p1.Color = [0 0.447 0.741];
p2.Color = [0.85 0.325 0.098];
p3.Color = [0.929 0.694 0.125];

% Formatting
ax = gca;
ax.ThetaTick = rad2deg(theta(1:end-1));
ax.ThetaTickLabel = labels;

title('Normalized Performance Radar Chart')

legend('GA PID','Ziegler-Nichols PID','Cohen-Coon PID','Location','bestoutside')