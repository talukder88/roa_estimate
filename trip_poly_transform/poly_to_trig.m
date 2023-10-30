function trig_func = poly_to_trig(poly_func)

    global var_original var_transformed transformed_var_original_idx
    
    trig_func = poly_func;
    idx = 1;
    for i = 1:2:length(var_transformed)
        trig_func = expand(subs(trig_func, var_transformed(i), ...
            sin(var_original(transformed_var_original_idx(idx)))));
        trig_func = expand(subs(trig_func, var_transformed(i + 1), ...
            1 - cos(var_original(transformed_var_original_idx(idx)))));
        idx = idx + 1;
    end
end