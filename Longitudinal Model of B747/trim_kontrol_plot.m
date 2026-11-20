% Trim Kontrol Grafik
figure

subplot(2,2,1)
stairs(out.de_deg.Time,out.de_deg.Data,'LineWidth', 2)
xlim([0 0.6])
title('Elevator Deflection')
xlabel('Time [s]')
ylabel('$\delta_e$ [deg]', 'Interpreter', 'latex')
grid on

subplot(2,2,2)
plot(out.V_dot.Time, out.V_dot.Data,'LineWidth', 2)
title('$\dot{V}$', 'Interpreter', 'latex')
ylabel('$\mathrm{m/s^2}$', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('%.4f')

subplot(2,2,3)
plot(out.alpha_dot.Time, out.alpha_dot.Data,'LineWidth', 2)
title('$\dot{\alpha}$', 'Interpreter', 'latex')
ylabel('$\mathrm{rad/s}$', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('%.4f')

subplot(2,2,4)
plot(out.qdot.Time, out.qdot.Data,'LineWidth', 2)
title('$\dot{q}$', 'Interpreter', 'latex')
ylabel('$\mathrm{rad/s^2}$', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

ax = findall(gcf, 'Type', 'axes');
linkaxes(ax, 'x');

ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('%.4f')

%% v2
figure

subplot(3,2,1)
stairs(out.de_deg.Time,out.de_deg.Data,'LineWidth', 2)
xlim([0 0.6])
title('Elevator Deflection')
xlabel('Time [s]')
ylabel('$\delta_e$ [deg]', 'Interpreter', 'latex')
grid on

subplot(3,2,2)
plot(out.V_ms.Time, out.V_ms.Data,'LineWidth', 2)
title('Airspeed')
ylabel('$V$ [m/s]', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

subplot(3,2,3)
plot(out.alpha_deg.Time, out.alpha_deg.Data,'LineWidth', 2)
title('Angle of Attack')
ylabel('$\alpha$ [deg]', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

subplot(3,2,4)
plot(out.q_rads.Time, rad2deg(out.q_rads.Data) ,'LineWidth', 2)
title('Pitch Rate')
ylabel('$q$ [deg/s]', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

subplot(3,2,5)
plot(out.theta_deg.Time,out.theta_deg.Data ,'LineWidth', 2)
title('Pitch Attitude')
ylabel('$\theta$ [deg]', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor

subplot(3,2,6)
plot(out.gama.Time,rad2deg(out.gama.Data),'LineWidth', 2)
title('Flight Path Angle')
ylabel('$\gamma$ [deg]', 'Interpreter', 'latex')
xlabel('Time [s]')
grid minor



ax = findall(gcf, 'Type', 'axes');
linkaxes(ax, 'x');