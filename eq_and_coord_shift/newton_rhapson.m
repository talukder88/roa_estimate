function [x_curr, func_eq_val] = newton_rhapson(func, varargin)

    global var_original    

    if nargin == 1
        initial_guess = zeros(length(func), 1);
        acc = 1e-10;
        max_iter = 1000;
    elseif nargin == 2
        initial_guess = varargin{1};
        acc = 1e-10;
        max_iter = 1000;
    elseif nargin == 3
        initial_guess = varargin{1};
        acc = varargin{2};
        max_iter = 1000;
    elseif nargin == 4
        initial_guess = varargin{1};
        acc = varargin{2};
        max_iter = varargin{3};
    else
        ME = MException("MyToolbox:TooManyInputs", ...
            "newton_rhapson accepts upto 4 inputs; %d are passed", nargin);
        throw(ME)
    end
    
    fprintf("Computing equilibrium employing" + ...
        " Newton-Raphson algorithm ...\n")
        
    x_curr = initial_guess;
    iter = 0;
    f_prime = jacobian(func, var_original);
    while 1
        f_val = func;
        f_prime_val = f_prime;
        for i = 1:length(var_original)
            f_val = subs(f_val, var_original(i), x_curr(i));
            f_prime_val = subs(f_prime_val, var_original(i), x_curr(i));            
        end

        x_new = x_curr - eval(f_prime_val)\eval(f_val);
        iter = iter + 1;
        if norm(eval(f_val)) < acc || iter == max_iter
            break
        end
    end
    func_eq_val = eval(f_val);
end
    