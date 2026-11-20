
% Aircraft parameters
m = 255826;
g = 9.80665;
rho = 1.225;
V = 67.39;
S = 510.97;
alpha_ref = deg2rad(8.5);

% Aerodynamic coefficients
CL_ref = 1.76;
CD_ref = 0.263;

CL_alpha = 5.67;
CD_alpha = 1.13;
Cm_alpha = -1.45;

CL_de = 0.356;
Cm_de = -1.40;

qbar = 0.5*rho*V^2;

% Unknowns: [alpha (rad), thrust (N), elevator (rad)]
trim_eq = @(x) [
    (x(2)*cos(x(1)) ...
    - qbar*S*(CD_ref + CD_alpha*(x(1)-alpha_ref)))/m;

    (qbar*S*(CL_ref + CL_alpha*(x(1)-alpha_ref) ...
    + CL_de*x(3)) + x(2)*sin(x(1)) - m*g)/m;

    Cm_alpha*(x(1)-alpha_ref) + Cm_de*x(3)
];

x0 = [alpha_ref; 378000; 0];

options = optimoptions('fsolve','Display','off');
[x_trim,~,exitflag] = fsolve(trim_eq,x0,options);

if exitflag <= 0
    warning('Trim solver did not converge.');
end

fprintf('Alpha trim: %.5f deg\n',rad2deg(x_trim(1)));
fprintf('Thrust trim: %.2f N\n',x_trim(2));
fprintf('Elevator trim: %.5f deg\n',rad2deg(x_trim(3)));
fprintf('Residuals:\n');
disp(trim_eq(x_trim));
