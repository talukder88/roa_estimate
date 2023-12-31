function lyap_func = find_init_lyap(dyn_field, varargin)
    
    global var_original all_var_transformed_space ...
        transformed_var_original_idx solver
    
    if nargin == 2
        zero_equality_constr = varargin{1};
    elseif nargin > 2
        ME = MException("MyToolbox:TooManyInputs", ...
            "find_init_lyap accepts upto 2 inputs; %d are passed", ...
            nargin);
        throw(ME)
    end
    
    if nargin == 1
        a_matrix = jacobian(dyn_field, var_original);

        for i = 1:length(var_original)
            a_matrix = eval(subs(a_matrix, var_original(i), 0));            
        end

        if any(real(eig(a_matrix)) > 0)
            ME = MException("MyToolbox:TooManyInputs", ...
                "specified dynamics is unstable at the equilibrium; RoA is empty!");
            throw(ME)
        else    
            p = lyap(a_matrix, eye(length(var_original)));
            var_original_transpose = [];
            for i = 1:length(var_original)
                var_original_transpose = [var_original_transpose, ...
                    var_original(i)];
            end
            lyap_func = expand(var_original_transpose * p * var_original);  
        end
    else    
        q = sum(all_var_transformed_space.* ...
            all_var_transformed_space)*10^-3;
        r = sum(all_var_transformed_space.* ...
            all_var_transformed_space);
        beta = 0.3;
        
        vdim = length(transformed_var_original_idx);
        prog = sosprogram(all_var_transformed_space);
        [prog, lyap_func] = sospolyvar(prog, ...
            monomials(all_var_transformed_space, [1 2]));
        [prog, s1] = sospolyvar(prog, ...
            monomials(all_var_transformed_space, [0 1 2]));
        [prog, v1] = sospolymatrixvar(prog, ...
            monomials(all_var_transformed_space, [0 1 2]), [1, vdim]);
        [prog, v2] = sospolymatrixvar(prog, ...
            monomials(all_var_transformed_space, [0 1 2]), [1, vdim]);
        
        lyap_dot = (jacobian(lyap_func, ...
            all_var_transformed_space)*dyn_field);

        prog = sosineq(prog, lyap_func);
        prog = sosineq(prog, lyap_func - v1*zero_equality_constr - q);
        prog = sosineq(prog, -s1*(beta - r) - lyap_dot - ...
            v2*zero_equality_constr - q);

        options.solver = solver;
        evalc('[prog,info] = sossolve(prog, options)');
        feas = ~info.numerr&~info.pinf&~info.dinf;
        if feas
            fprintf("Initial Lyapunov function search is successful!\n")
            lyap_func = sosgetsol(prog, lyap_func);
        else
            ME = MException("MyToolbox:TooManyInputs", ...
                "Failed to find initial Lyapunov function;" ...
            + " the dynamics might be unstable!");
            throw(ME)
        end    
    end
end