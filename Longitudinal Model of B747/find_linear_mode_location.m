[P,D] = eig(A);

stateNames = {'q','theta','V','alpha'};

for k = 1:4
    fprintf('\nEigenvalue %d: %.5f %+.5fi\n', ...
        k, real(D(k,k)), imag(D(k,k)));

    for i = 1:4
        fprintf('%s: %.6f %+.6fi\n', ...
            stateNames{i}, real(P(i,k)), imag(P(i,k)));
    end
end
%% 
lambda = eig(A);

figure;
plot(real(lambda), imag(lambda), 'x', ...
    'MarkerSize', 11, 'LineWidth', 2);
hold on;

xline(0, '--k', 'LineWidth', 1);

grid on;
xlabel('Real Part [1/s]');
ylabel('Imaginary Part [rad/s]');
title('Longitudinal Eigenvalue Locations');

xlim([-0.6 0.1]);
ylim([-0.8 0.8]);

%% [P,D] = eig(A);

lambda = diag(D);

% Positive imaginary part of the phugoid eigenvalue
idx = find(imag(lambda) > 0 & ...
           abs(imag(lambda)) < 0.3, 1);

lp = lambda(idx);
vp = P(:,idx);

% State ordering: [q, theta, V, alpha]
vV = vp(3);
vGamma = vp(2) - vp(4);

t = linspace(0,120,2000);

% Normalized modal responses
Vmode = real((vV/abs(vV)) .* exp(lp*t));
Gmode = real((vGamma/abs(vGamma)) .* exp(lp*t));

figure;
plot(t,Vmode,'LineWidth',1.8);
hold on;
plot(t,Gmode,'LineWidth',1.8);

grid on;
xlabel('Time [s]');
ylabel('Normalized Modal Amplitude');
title('Phugoid Mode: Airspeed and Flight Path Angle');
legend('Airspeed','Flight Path Angle', ...
       'Location','best');
%% 
[P,D] = eig(A);
lambda = diag(D);

% Short-period eigenvalue (positive imaginary part)
idx = find(imag(lambda) > 0 & ...
           imag(lambda) > 0.3, 1);

lambdaSP = lambda(idx);
vSP = P(:,idx);

% State ordering: [q, theta, V, alpha]
vq = vSP(1);
vAlpha = vSP(4);

% Phase angles
phase_q = rad2deg(angle(vq));
phase_alpha = rad2deg(angle(vAlpha));

phase_difference = mod(phase_q - phase_alpha + 180,360)-180;

fprintf('Phase of q: %.2f deg\n',phase_q);
fprintf('Phase of alpha: %.2f deg\n',phase_alpha);
fprintf('Phase difference: %.2f deg\n',phase_difference);

% Time vector
t = linspace(0,15,1500);

% Normalized short-period modal responses
q_mode = real((vq/abs(vq)) .* exp(lambdaSP*t));
alpha_mode = real((vAlpha/abs(vAlpha)) .* exp(lambdaSP*t));

figure;
plot(t,q_mode,'LineWidth',1.8);
hold on;
plot(t,alpha_mode,'LineWidth',1.8);

grid on;
xlabel('Time [s]');
ylabel('Normalized Modal Amplitude');
title('Short-Period Mode: Pitch Rate and Angle of Attack');

legend('Pitch Rate (q)', ...
       'Angle of Attack (\alpha)', ...
       'Location','best');

exportgraphics(gcf,'short_period_phase_relationship.png', ...
    'Resolution',300);

%% 
% Linearized state-space model
sys_lin = linsys2;

% Simulation time
t = (0:0.05:120)';

% Elevator perturbation
delta_de = deg2rad(delta_de_test);

% Step input at t = 1 s
de_input = delta_de * (t >= 1);

% Thrust perturbation is zero
dT_input = zeros(size(t));

% Input matrix: [delta_e, T]
u = [de_input, dT_input];

% Linear model response
[y_lin, t_lin] = lsim(sys_lin, u, t);

%% 
dq_lin     = y_lin(:,1);
dtheta_lin = y_lin(:,2);
dV_lin     = y_lin(:,3);
dalpha_lin = y_lin(:,4);

%% 
V_lin = V_init + dV_lin;

alpha_lin = rad2deg(x_trim(1) + dalpha_lin);

q_lin = rad2deg(dq_lin);

theta_lin = rad2deg(x_trim(1) + dtheta_lin);

%% 
figure;

subplot(2,2,1)
plot(t_lin,V_lin,'LineWidth',1.5)
grid on
xlabel('Time [s]')
ylabel('V [m/s]')
title('Airspeed')

subplot(2,2,2)
plot(t_lin,alpha_lin,'LineWidth',1.5)
grid on
xlabel('Time [s]')
ylabel('\alpha [deg]')
title('Angle of Attack')

subplot(2,2,3)
plot(t_lin,q_lin,'LineWidth',1.5)
grid on
xlabel('Time [s]')
ylabel('q [deg/s]')
title('Pitch Rate')

subplot(2,2,4)
plot(t_lin,theta_lin,'LineWidth',1.5)
grid on
xlabel('Time [s]')
ylabel('\theta [deg]')
title('Pitch Attitude')

sgtitle('Linearized Boeing 747 Longitudinal Response')