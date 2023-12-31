function [lyap_func, c, stability_margin] = ...
    compute_max_roa(dyn_field, zero_equality_constr, lyap_func)
    
    global all_var_transformed_space gamma_series ...
        lyap_func_series c_series
    
    %%
    c_step_ub = 10;
    c_step_lb = 0;
    gamma_step_ub = 10;
    gamma_step_lb = 0;
    c_precision = 1e-3;
    gamma_precision = 1e-3;
    step_factor = 1000;
    delta_c = 1000;
    delta_gamma = 1000;
    
    p = sum(all_var_transformed_space.*all_var_transformed_space);
    
    fprintf("Performing iterative RoA expansion ...\n")
    
    %%
    iter = 0;
    c_conv = 0;
    gamma_conv = 0;
    gamma = 0;
     
    while 1
        iter = iter + 1;
        fprintf("\tIter # %d\n", iter)
        while 1
            c = (c_step_ub + c_step_lb) / 2;
            [s2, s3, feas] = sos_search_for_aux_funcs(dyn_field, ...
                zero_equality_constr, lyap_func, c, gamma, p);
            if ~feas
                c_step_ub = (c_step_ub + c_step_lb) / 2;
            else
                c_step_lb = c;
                c_step_ub = c_step_lb + min(c_precision * step_factor, delta_c * 1.5);
                fprintf("\t\tFeasible c found: %f\n", c)
                c_conv = 0;
                break
            end
            if c_step_ub - c_step_lb < c_precision
                fprintf("\t\tNo improved c is found!\n")
                c_step_ub = c_step_lb + min(c_precision * step_factor, delta_c * 1.5);
                c_conv = 1;
                c = c_step_lb;
                break
            end      
        end

        while 1
            gamma = (gamma_step_ub + gamma_step_lb) / 2;
            [lyap_func, feas] = sos_search_for_lyap_func(dyn_field, ...
                zero_equality_constr, s2, s3, c, gamma, p);
            if ~feas         
                gamma_step_ub = (gamma_step_ub + gamma_step_lb) / 2;
            else
                gamma_step_lb = gamma;
                gamma_step_ub = gamma_step_lb + ...
                    min(gamma_precision * step_factor, delta_gamma * 1.5);
                fprintf("\t\tFeasible gamma found: %f\n", gamma)
                if iter >= 2
                    delta_c = c - c_series(end);
                    delta_gamma = gamma - gamma_series(end);
                end
                gamma_series = [gamma_series; gamma];
                c_series = [c_series; c];
                lyap_func_series = [lyap_func_series; lyap_func];
                gamma_conv = 0;                
                break
            end
            if gamma_step_ub - gamma_step_lb < gamma_precision
                fprintf("\t\tNo improved gamma is found!\n")
                gamma_step_ub = gamma_step_lb + ...
                    gamma_precision * step_factor;
                gamma_conv = 1;
                gamma = gamma_step_lb;
                break
            end 
        end
        if c_conv && gamma_conv
            fprintf("RoA computation algorithm converged successfully!\n")
            break
        end
    end 
    stability_margin = gamma / length(all_var_transformed_space);
end




