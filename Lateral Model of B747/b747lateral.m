% BOEING 747 LATERAL MODEL
clear; 
clc; 
close all
%% Weight and Inertia 
p.g   = 9.80665;         % m/s^2
p.m   = 288756.902742;   % kg
p.S    = 510.9665;   % m^2
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

p.CYBeta = -1.08; %1/rad
p.CYdr = 0.179; %1/rad

p.ClBeta = -0.281; %1/rad
p.Clp = -0.502; %1/rad
p.Clr = 0.195; %1/rad
p.Clda = 0.0530; %1/rad
p.Cldr = 0; %1/rad

p.CnBeta = 0.184; %1/rad
p.Cnp = -0.222; %1/rad
p.Cnr = -0.36; %1/rad
p.Cnda = 0.0083; %1/rad
p.Cndr = -0.112; %1/rad

%% Initial Conditions 
alpha_init = p.alpharef; %deg
theta_init = alpha_init; %rad
V_init = 67.394444; %m/s

%% Plot
figure

subplot(3,2,1)
stairs(out.dr.Time,out.dr.Data,'LineWidth', 2)
grid on
grid minor
title('Rudder Deflection')
xlabel('Time')
ylabel('Deflection [degree]')

subplot(3,2,2)
stairs(out.Y.Time,out.Y.Data,'LineWidth', 2)
grid on
grid minor
title('Side Force')
xlabel('Time')
ylabel('Y [N]')

subplot(3,2,3)
stairs(out.beta_rad.Time,rad2deg(out.beta_rad.Data),'LineWidth', 2)
grid on
grid minor
title('Side Slip Angle')
xlabel('Time')
ylabel('Beta [degree]')

%% 

subplot(3,2,1)
stairs(out.dr.Time,out.dr.Data,'LineWidth', 2)
grid on
grid minor
title('Rudder Deflection')
xlabel('Time')
ylabel('Deflection [degree]')

subplot(3,2,2)
plot(out.beta_rad.Time,rad2deg(out.beta_rad.Data),'LineWidth', 2)
grid on
grid minor
title('Side Slip Angle')
xlabel('Time')
ylabel('Beta [degree]')

subplot(3,2,3)
plot(out.p.Time,out.p.Data,'LineWidth', 2)
grid on
grid minor
title('p')
xlabel('Time')

subplot(3,2,4)
plot(out.r.Time,out.r.Data,'LineWidth', 2)
grid on
grid minor
title('r(t)')
xlabel('Time')

subplot(3,2,5)
plot(out.phi_rad.Time,rad2deg(out.phi_rad.Data),'LineWidth', 2)
grid on
grid minor
title('phi(t)')
xlabel('Time')




ax = findall(gcf, 'Type', 'axes');
linkaxes(ax, 'x');