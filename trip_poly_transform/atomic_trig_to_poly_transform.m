function transformed_func = ... 
    atomic_trig_to_poly_transform(original_func, original_var,...
    new_var_1, new_var_2)

    transformed_func = [];
    for i = 1:length(original_func)
        curr_func = original_func(i);    
        if has(curr_func, sin(original_var))
            transformed_func = [transformed_func; ...
                expand(subs(curr_func, sin(original_var), new_var_1))];
        else
            transformed_func = [transformed_func; curr_func];
        end
    end
    
    original_func = transformed_func;
    transformed_func = [];
    for i = 1:length(original_func)
        curr_func = original_func(i);    
        if has(curr_func, cos(original_var))
            transformed_func = [transformed_func; ...
                expand(subs(curr_func, cos(original_var), 1 - new_var_2))];
        else
            transformed_func = [transformed_func; curr_func];
        end
    end
end