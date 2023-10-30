function [lyap_func, level, stability_margin] = run(dyn_field, ...
    vars, varargin)
    global var_original solver
    
    if nargin == 2
        solver = "sedumi";
        eq = zeros(length(vars), 1);
    elseif nargin == 3
        solver = "sedumi";
        eq = varargin{1};
    elseif nargin == 4
        solver = varargin{2};
        eq = varargin{1};
    else
        ME = MException("MyToolbox:TooManyInputs", ...
            "run accepts 2-4 inputs; %d are passed", ...
            nargin);
        throw(ME)
    end
    
    var_original = vars;
    [eq, func_eq_val] = newton_rhapson(dyn_field, eq);
    dyn_field = get_eq_quantization_adjusted_func(dyn_field, func_eq_val);
    dyn_field = linear_shift_of_coord(dyn_field, eq);

    [poly_dyn_field, zero_equality_constr] = ...
        trig_to_poly_transform(dyn_field);
    lyap_func_init = find_init_lyap(poly_dyn_field, zero_equality_constr);
    [lyap_func, level, stability_margin] = ...
        compute_max_roa(poly_dyn_field, zero_equality_constr,...
        lyap_func_init);
    
    fprintf("Equilibrium: \n\t")
    disp(eq')
    
    fprintf("Estimated RoA is of form lyap_func <= level, where:\n")
    fprintf("\tlyap_func:\t")
    disp(vpa(linear_shift_of_coord(poly_to_trig(lyap_func), -1*eq), 4))
    fprintf("\tlevel:\t%f\n", level)
    fprintf("Stability margin: %f\n", stability_margin)
end