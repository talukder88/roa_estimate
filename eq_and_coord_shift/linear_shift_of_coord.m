function func = linear_shift_of_coord(func, offset)

    global var_original
    
    for i = 1:length(var_original)
        func = expand(subs(func, var_original(i), ...
            var_original(i) + offset(i)));
    end    
end