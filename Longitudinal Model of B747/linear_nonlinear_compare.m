% Nonlinear simulation outputs
V_nl_data     = out.V_ms;
alpha_nl_data = out.alpha_deg;
q_nl_data     = out.q_rads;
theta_nl_data = out.theta_deg;

% Time vectors and values
t_nl = V_nl_data.Time;

V_nl     = V_nl_data.Data;
alpha_nl = alpha_nl_data.Data;
q_nl     = rad2deg(q_nl_data.Data);
theta_nl = theta_nl_data.Data;

%% 
% Interpolate linear results at nonlinear time points
V_lin_interp = interp1(t_lin, V_lin, t_nl, 'linear');
alpha_lin_interp = interp1(t_lin, alpha_lin, t_nl, 'linear');
q_lin_interp = interp1(t_lin, q_lin, t_nl, 'linear');
theta_lin_interp = interp1(t_lin, theta_lin, t_nl, 'linear');

figure;

subplot(2,2,1)
plot(t_nl,V_nl,'b','LineWidth',1.6)
hold on
plot(t_nl,V_lin_interp,'r--','LineWidth',1.6)
grid on
xlabel('Time [s]')
ylabel('V [m/s]')
title('Airspeed')
legend('Nonlinear','Linear')

subplot(2,2,2)
plot(t_nl,alpha_nl,'b','LineWidth',1.6)
hold on
plot(t_nl,alpha_lin_interp,'r--','LineWidth',1.6)
grid on
xlabel('Time [s]')
ylabel('\alpha [deg]')
title('Angle of Attack')
legend('Nonlinear','Linear')

subplot(2,2,3)
plot(t_nl,q_nl,'b','LineWidth',1.6)
hold on
plot(t_nl,q_lin_interp,'r--','LineWidth',1.6)
grid on
xlabel('Time [s]')
ylabel('q [deg/s]')
title('Pitch Rate')
legend('Nonlinear','Linear')

subplot(2,2,4)
plot(t_nl,theta_nl,'b','LineWidth',1.6)
hold on
plot(t_nl,theta_lin_interp,'r--','LineWidth',1.6)
grid on
xlabel('Time [s]')
ylabel('\theta [deg]')
title('Pitch Attitude')
legend('Nonlinear','Linear')

sgtitle('Linear vs Nonlinear Boeing 747 Response')

%% 
% Root Mean Square Errors
rmse_V = sqrt(mean((V_nl - V_lin_interp).^2));
rmse_alpha = sqrt(mean((alpha_nl - alpha_lin_interp).^2));
rmse_q = sqrt(mean((q_nl - q_lin_interp).^2));
rmse_theta = sqrt(mean((theta_nl - theta_lin_interp).^2));

fprintf('Airspeed RMSE: %.6f m/s\n',rmse_V);
fprintf('Alpha RMSE: %.6f deg\n',rmse_alpha);
fprintf('Pitch Rate RMSE: %.6f deg/s\n',rmse_q);
fprintf('Theta RMSE: %.6f deg\n',rmse_theta);