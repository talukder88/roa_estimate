syms x1 x2 x3

global var_original var_transformed ...
        transformed_var_original_idx all_var_transformed_space
    
var_original = [x1; x2; x3];
f = [1 - sin(x1);
     cos(x2) + sin(x3);
     cos(x3)*sin(x1)];
 
[poly_func, zero_equality_constr] = trig_to_poly_transform(f);
poly_func
zero_equality_constr
poly_to_trig(poly_func)

