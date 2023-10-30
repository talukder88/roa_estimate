# Sum-of-squares Optimization-based Inner-estimation of Maximal Region-of-Attraction for Systems with Trigonometric Dynamic Fields
**Introduction**: This repo provides a MATLAB toolbox to inner-estimate maximal region-of-attractions (RoA) of continuous-time nonlinear dynamical systems, where the dynamic field may include trigonometric terms. The tool employs sum-of-squares (SoS) optimization-based automated search for Lyapunov functions. Open-source implementations for automated search of Lyapunov function are available for systems with polynomial dynamic fields; however, dynamic model of practical systems (e.g., in robotics, power systems, etc.) often comprise trigonometric terms. This toolbox can handle such systems (see our work [Resilience Indices for Power/Cyberphysical Systems](https://ieeexplore.ieee.org/abstract/document/9198917) for application in classical power system models).

**Technical Overview**: The technical details can be found here. The tool, first, uses [Newton-Raphson](https://www.math.ubc.ca/~anstee/math104/newtonmethod.pdf) to compute an equilibrium of the given trigonometric dynamic field. If it has multiple equilibria, one can specify the equilibrium (or its close initial guess; defaults to the origin) of interest. The tool then equivalently expresses the trigonometric field as a projection of a higher dimensional polynomial field onto an equidimensional manifold. In a nutshell, the search for the inner-estimate of a maximal RoA around the equilibrium is posed as an optimization problem involving a number of (nonconvex) semi-algebraic set emptiness constraints in the above higher dimensional space, which are then equivalently expressed as SoS constraints via [Positivstellensatz](https://www.mit.edu/~parrilo/ecc03_course/06_positivstellensatz.pdf). To achieve computational tractability, satisfiability of only a convex sufficient condition is explored via semidefinite program (SDP), which serves as a certificate of set emptiness. The maxima of RoA is attained through an iterative local search.  

**Installation**: This toolbox was tested in MATLAB R2021a, but it should be backward compatible with prior MATLAB versions. [SOSTOOLS](https://www.cds.caltech.edu/sostools/) and any one of its supported backend SDP solvers are the only two dependencies, which need to be installed first (see [here](https://github.com/oxfordcontrol/SOSTOOLS) for their installation guidelines). Then simply clone this repo and add the cloned directory (including all its subdirectories) into MATLAB's search path. SOSTOOLS supports various SDP solvers, but Mosek is recommended owing to its superior performance compared to the rest. Mosek is a commercial SDP solver, but a free license may be available from Mosek free of cost for academic usage (see [here](https://www.mosek.com/products/academic-licenses/) for more information). The default solver in the tool is [SeDuMi](https://github.com/sqlp/sedumi), although the latter needs to be installed separately.

**Example**: See the example to get started:
```
syms x1 x2 x3 x4  % define the symbolic state variables

vars = [x1; x2; x3; x4];  % define the state vector 

dyn_field = [...
    x2;
    -sin(x1) - 0.5*sin(x1 - x3) - 0.4*x2;
    x4;
    -0.5*sin(x3) - 0.5*sin(x3 - x1) - 0.5*x4;
];   % specify the continuous-time dynamic field

eq_guess = [0; 0; 0; 0];
solver = "mosek";   % can be "cdcs", "sdpt3", "csdp", "sdpnal", 
                    % "sdpnalplus", "sdpa", or "mosek"                    

run(dyn_field, vars, eq_guess, solver);  % call the tool
```
On successful run of the tool, it outputs the inner-estimate of a maximal RoA in form of a sublevel set of a locally optimal Lyapunov function together with a scalar metric of stability margin as shown below:
```
RoA computation algorithm converged successfully!
Equilibrium: 
	     0     0     0     0

Estimated RoA is of form lyap_func <= level, where:
	lyap_func:	2.014e-9*cos(x1) - 5.856e-24*x4 - 2.172e-23*x2 + 2.222e-9*cos(x3) - 7.17e-23*sin(x1) - 1.058e-23*sin(x3) + 5.786e-10*cos(x1)*cos(x3) + 3.73e-23*cos(x1)*sin(x1) + 4.473e-24*cos(x1)*sin(x3) + 1.744e-23*cos(x3)*sin(x1) + 3.071e-24*cos(x3)*sin(x3) - 7.91e-10*sin(x1)*sin(x3) + 0.03325*cos(x1)^2 + 0.02405*cos(x3)^2 + 0.03325*sin(x1)^2 + 0.02405*sin(x3)^2 - 1.117e-9*x2*x4 + 1.605e-23*x2*cos(x1) + 2.053e-24*x2*cos(x3) + 1.355e-23*x4*cos(x1) - 1.183e-23*x4*cos(x3) - 5.964e-10*x2*sin(x1) - 1.151e-9*x2*sin(x3) - 3.163e-10*x4*sin(x1) - 1.88e-9*x4*sin(x3) - 1.879e-10*x2^2 - 7.292e-10*x4^2 - 0.05731
 
	level:	6.018570
Stability margin: 0.666402
```

**Citation** Please cite this repo as follows if you find it useful:

*S. Talukder, M. Ibrahim and R. Kumar, "Resilience Indices for Power/Cyberphysical Systems," in IEEE Transactions on Systems, Man, and Cybernetics: Systems, vol. 51, no. 4, pp. 2159-2172, April 2021, doi: 10.1109/TSMC.2020.3018706.*

**Contact**: For any questions or comments, please feel free to reach me at [talukder@iastate.edu](mailto:talukder@iastate.edu).
