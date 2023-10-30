syms x1 x2

global var_original 
    
var_original = [x1; x2];

f = [-x2;
      x1 + (x1^2-1) * x2];

find_init_lyap(f)