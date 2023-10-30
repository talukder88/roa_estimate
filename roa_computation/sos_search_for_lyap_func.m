function [lyap_func, feas] = sos_search_for_lyap_func(dyn_field, ...
    zero_equality_constr, s2, s3, c, gamma, p)
    
    global all_var_transformed_space transformed_var_original_idx solver
    
    q = sum(all_var_transformed_space.* ...
        all_var_transformed_space)*10^-3;
    
    vdim = length(transformed_var_original_idx);
    prog = sosprogram(all_var_transformed_space);
    [prog, s1] = sospolyvar(prog, ...
        monomials(all_var_transformed_space,[0 1 2]));
    [prog, lyap_func] = sospolyvar(prog, ...
        monomials(all_var_transformed_space,[1 2]));
    [prog, v1] = sospolymatrixvar(prog, ...
        monomials(all_var_transformed_space,[0 1 2]),[1, vdim]);
    [prog, v2] = sospolymatrixvar(prog, ...
        monomials(all_var_transformed_space,[0 1 2]),[1, vdim]);

    lyap_dot = (jacobian(lyap_func, all_var_transformed_space)*dyn_field);

    prog = sosineq(prog, s1);
    prog = sosineq(prog, -s2*(c - lyap_func) - s3*lyap_dot - ...
        v1*zero_equality_constr - q);
    prog = sosineq(prog, -s1*(gamma - p) - ...
        v2*zero_equality_constr - (lyap_func - c));

    options.solver = solver;
    evalc('[prog,info] = sossolve(prog, options)');
    feas = ~info.numerr&~info.pinf&~info.dinf;
    lyap_func = sosgetsol(prog, lyap_func);
end