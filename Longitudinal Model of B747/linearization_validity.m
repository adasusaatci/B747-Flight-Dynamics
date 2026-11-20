%% Linearization Validity Analysis

model = 'longb747';
sys_lin = linsys2;

% Elevator perturbations [deg]
delta_de_values = [0.146 0.5 1 3];

% Linear simulation time
t = (0:0.05:120)';

% Trim conditions
V0 = V_init;
alpha0 = x_trim(1);
theta0 = x_trim(1);
q0 = 0;

% Results
RMSE = zeros(length(delta_de_values),4);

for k = 1:length(delta_de_values)

    % Elevator perturbation in radians
    delta_de_test = deg2rad(delta_de_values(k));

    %% Nonlinear model

    % Set simulation variable explicitly
    simIn = Simulink.SimulationInput(model);
    simIn = simIn.setVariable( ...
        'delta_de_test', delta_de_test);

    simIn = simIn.setModelParameter( ...
        'StopTime','120');

    out_test = sim(simIn);

    % Extract nonlinear responses
    t_nl = out_test.V_ms.Time(:);

    V_nl = out_test.V_ms.Data(:);
    alpha_nl = out_test.alpha_deg.Data(:);
    q_nl = rad2deg(out_test.q_rads.Data(:));
    theta_nl = out_test.theta_deg.Data(:);

    %% Linear model

    de_input = delta_de_test * (t >= 1);
    thrust_input = zeros(size(t));

    u = [de_input thrust_input];

    y_lin = lsim(sys_lin,u,t);

    % Convert deviations into absolute states
    q_lin = rad2deg(q0 + y_lin(:,1));
    theta_lin = rad2deg(theta0 + y_lin(:,2));
    V_lin = V0 + y_lin(:,3);
    alpha_lin = rad2deg(alpha0 + y_lin(:,4));

    %% Interpolation

    V_interp = interp1(t,V_lin,t_nl);
    alpha_interp = interp1(t,alpha_lin,t_nl);
    q_interp = interp1(t,q_lin,t_nl);
    theta_interp = interp1(t,theta_lin,t_nl);

    %% RMSE

    RMSE(k,1) = sqrt(mean((V_nl-V_interp).^2));
    RMSE(k,2) = sqrt(mean((alpha_nl-alpha_interp).^2));
    RMSE(k,3) = sqrt(mean((q_nl-q_interp).^2));
    RMSE(k,4) = sqrt(mean((theta_nl-theta_interp).^2));

    fprintf('Completed: %.3f deg elevator perturbation\n', ...
        delta_de_values(k));
    if delta_de_values(k) == 3

    figure;

    subplot(2,2,1)
    plot(t_nl,V_nl,'b','LineWidth',1.5)
    hold on
    plot(t_nl,V_interp,'r--','LineWidth',1.5)
    grid on
    title('Airspeed')
    ylabel('V [m/s]')

    subplot(2,2,2)
    plot(t_nl,alpha_nl,'b','LineWidth',1.5)
    hold on
    plot(t_nl,alpha_interp,'r--','LineWidth',1.5)
    grid on
    title('Angle of Attack')
    ylabel('\alpha [deg]')

    subplot(2,2,3)
    plot(t_nl,q_nl,'b','LineWidth',1.5)
    hold on
    plot(t_nl,q_interp,'r--','LineWidth',1.5)
    grid on
    title('Pitch Rate')
    ylabel('q [deg/s]')
    xlabel('Time [s]')

    subplot(2,2,4)
    plot(t_nl,theta_nl,'b','LineWidth',1.5)
    hold on
    plot(t_nl,theta_interp,'r--','LineWidth',1.5)
    grid on
    title('Pitch Attitude')
    ylabel('\theta [deg]')
    xlabel('Time [s]')

    legend('Nonlinear','Linear')

    sgtitle('Linear vs Nonlinear Response: 3 deg Elevator Step')

    %% Phugoid Period Comparison - No Toolbox Required

% Ensure column vectors
t_nl = t_nl(:);
V_nl = V_nl(:);
V_interp = V_interp(:);

% Find local maxima using neighboring samples
idx_nl = find( ...
    V_nl(2:end-1) > V_nl(1:end-2) & ...
    V_nl(2:end-1) >= V_nl(3:end)) + 1;

idx_lin = find( ...
    V_interp(2:end-1) > V_interp(1:end-2) & ...
    V_interp(2:end-1) >= V_interp(3:end)) + 1;

% Ignore peaks during the initial transient
idx_nl = idx_nl(t_nl(idx_nl) > 10);
idx_lin = idx_lin(t_nl(idx_lin) > 10);

% Peak times and values
tpk_nl = t_nl(idx_nl);
Vpk_nl = V_nl(idx_nl);

tpk_lin = t_nl(idx_lin);
Vpk_lin = V_interp(idx_lin);

% Calculate periods
T_nl = diff(tpk_nl);
T_lin = diff(tpk_lin);

% Average periods
T_nl_mean = mean(T_nl);
T_lin_mean = mean(T_lin);

% Percentage difference
period_difference = ...
    100 * (T_nl_mean - T_lin_mean) / T_lin_mean;

fprintf('\n--- Phugoid Period Comparison ---\n');
fprintf('Nonlinear period: %.3f s\n', T_nl_mean);
fprintf('Linear period: %.3f s\n', T_lin_mean);
fprintf('Period difference: %.2f %%\n', period_difference);

end

end

%% Results table

Results = table( ...
    delta_de_values(:), ...
    RMSE(:,1), ...
    RMSE(:,2), ...
    RMSE(:,3), ...
    RMSE(:,4), ...
    'VariableNames', ...
    {'Elevator_deg','RMSE_V','RMSE_alpha', ...
     'RMSE_q','RMSE_theta'});

disp(Results);
%% 
%% RMSE versus elevator perturbation

figure;

subplot(2,2,1)
plot(delta_de_values,RMSE(:,1),'-o','LineWidth',1.5)
grid on
xlabel('Elevator Perturbation [deg]')
ylabel('RMSE [m/s]')
title('Airspeed')

subplot(2,2,2)
plot(delta_de_values,RMSE(:,2),'-o','LineWidth',1.5)
grid on
xlabel('Elevator Perturbation [deg]')
ylabel('RMSE [deg]')
title('Angle of Attack')

subplot(2,2,3)
plot(delta_de_values,RMSE(:,3),'-o','LineWidth',1.5)
grid on
xlabel('Elevator Perturbation [deg]')
ylabel('RMSE [deg/s]')
title('Pitch Rate')

subplot(2,2,4)
plot(delta_de_values,RMSE(:,4),'-o','LineWidth',1.5)
grid on
xlabel('Elevator Perturbation [deg]')
ylabel('RMSE [deg]')
title('Pitch Attitude')

sgtitle('Linearization Error vs Elevator Perturbation')