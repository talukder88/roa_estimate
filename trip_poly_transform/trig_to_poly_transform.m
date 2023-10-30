function [poly_func, zero_equality_constr] = ...
    trig_to_poly_transform(trig_func)
    
    global var_original var_transformed ...
        transformed_var_original_idx all_var_transformed_space
    
    fprintf("Transforming trigonometric dynamic " + ...
        "field into polynomial ...\n")
    
    poly_func = trig_func;
    zero_equality_constr = [];
    num_vars_transformed = 0;
    
    for i = 1:length(var_original)
        if any(has(poly_func, sin(var_original(i)))) || ...
                any(has(poly_func, cos(var_original(i))))
            new_var_1 = sym("vt" + num2str(num_vars_transformed + 1));
            new_var_2 = sym("vt" + num2str(num_vars_transformed + 2));
            
            var_transformed = [var_transformed; new_var_1; new_var_2];
            all_var_transformed_space = [all_var_transformed_space; ...
                new_var_1; new_var_2];
            transformed_var_original_idx = ...
                [transformed_var_original_idx; i];
            poly_func = atomic_trig_to_poly_transform(poly_func, ...
                var_original(i), new_var_1, new_var_2);
            poly_func(i + num_vars_transformed/2) = (1 - new_var_2) * ...
                var_original(i + 1);
            poly_func = [poly_func(1:i + num_vars_transformed/2); ...
                new_var_1 * var_original(i + 1); ...
                poly_func(i + num_vars_transformed/2 + 1:end)];
            zero_equality_constr = [zero_equality_constr; ...
                expand(new_var_1 ^ 2 + new_var_2 ^ 2 - 2 * new_var_2)];
            num_vars_transformed = num_vars_transformed + 2;
        else
            all_var_transformed_space = [all_var_transformed_space; ...
                var_original(i)];
        end  
    end   
end
    