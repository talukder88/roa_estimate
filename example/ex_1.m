clc
clear all

syms x1 x2 x3 x4  % define the symbolic state variables

vars = [x1; x2; x3; x4];  % define the state vector 

dyn_field = [...
    x2;
    -sin(x1) - 0.5*sin(x1 - x3) - 0.4*x2;
    x4;
    -0.5*sin(x3) - 0.5*sin(x3 - x1) - 0.5*x4;
];   % specify the continuous-time dynamic field

eq_guess = [0; 0; 0; 0];
solver = "mosek";   % can be "cdcs", "sdpt3", "csdp", "sdpnal", 
                    % "sdpnalplus", "sdpa", or "mosek"                    

run(dyn_field, vars, eq_guess, solver);  % call the tool