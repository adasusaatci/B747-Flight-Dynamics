% BOEING 747 LONGITUDINAL MODEL
clear; 
clc; 
close all
%% Weight and Inertia 
p.g   = 9.80665;         % m/s^2
p.m   = 288756.902742;   % kg
p.S    = 510.96672;   % m^2
p.b    = 59.643264;   % m
p.cbar = 8.324088;    % m

p.Ixx = 2.467588666e7;   % kg*m^2
p.Iyy = 4.352175614e7;   % kg*m^2
p.Izz = 6.738415203e7;   % kg*m^2
p.Ixz = 1.315143410e6;   % kg*m^2

p.cg_fraction = 0.25;    % x_cg / cbar

%% Aerodynamic Parameters 
% Parameters are given for sea level altitude, 131 KTAS, alpha = 8.5 deg
p.alpharef = 8.5; %deg
p.a = 340.3; %m/s
p.CL = 1.76;
p.CLalpha = 5.67; % 1/rad
p.CLde = 0.356; % 1/rad
p.CLq = 5.65; % 1/rad
p.CLM = -1.1; 
p.CLalphadot = -6.7; 
p.CD = 0.263;
p.CDalpha = 1.13; % 1/rad
p.Cmalpha = -1.45; % 1/rad
p.Cmq = -21.4; % 1/rad
p.Cmde = -1.40; % 1/rad
p.CmM = 0.36; 
p.Cmalphadot = -3.3;

%% Initial Conditions 
% p.Thrust = 10000; %N
q_init = 0;
theta_init = 0; %rad
alpha_init = p.alpharef; %rad
V_init = 67.394444; %m/s

%% Plot
figure

subplot(3,3,1)
stairs(out.de_deg.Time,out.de_deg.Data,'LineWidth', 2)
grid on 
grid minor 
title('Elevator Deflection')
xlabel('Time')
ylabel('Deflection [degree]')

subplot(3,3,2)
stairs(out.thrust_N.Time,out.thrust_N.Data,'LineWidth', 2)
grid on 
grid minor 
title('Thrust')
xlabel('Time')
ylabel('Thrust [N]')

subplot(3,3,3)
plot(out.alpha_deg.Time,out.alpha_deg.Data,'LineWidth', 2)
grid on 
grid minor 
title('Angle of Attack')
xlabel('Time')
ylabel('Alpha [degree]')

subplot(3,3,4)
plot(out.V_ms.Time,out.V_ms.Data,'LineWidth', 2)
grid on 
grid minor 
title('Velocity')
xlabel('Time')
ylabel('V [m/s]')

subplot(3,3,5)
plot(out.M_moment.Time,out.M_moment.Data,'LineWidth', 2)
grid on 
grid minor 
title('Moment')
xlabel('Time')
ylabel('Moment [Nm]')

subplot(3,3,6)
plot(out.Lift_N.Time,out.Lift_N.Data,'LineWidth', 2)
grid on 
grid minor 
title('Lift')
xlabel('Time')
ylabel('Lift [N]')

subplot(3,3,7)
plot(out.q_rads.Time,out.q_rads.Data,'LineWidth', 2)
grid on 
grid minor 
title('q')
xlabel('Time')
ylabel('q [rad/s]')

subplot(3,3,8)
plot(out.theta_deg.Time,out.theta_deg.Data,'LineWidth', 2)
grid on 
grid minor 
title('Theta')
xlabel('Time')
ylabel('Theta [degree]')

subplot(3,3,9)
plot(out.gama_rad.Time,rad2deg(out.gama_rad.Data),'LineWidth', 2)
grid on 
grid minor 
title('Gama')
xlabel('Time')
ylabel('Gama [degree]')

ax = findall(gcf, 'Type', 'axes');
linkaxes(ax, 'x');

