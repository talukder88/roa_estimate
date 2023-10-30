# Sum-of-squares Optimization-based Inner-estimation of Maximal Region-of-Attraction for Systems with Trigonometric Dynamic Fields
This repo provides a MATLAB toolbox to inner-estimate maximal region-of-attractions (RoA) of continuous-time dynamical systems, where the dynamic field may include trigonometric terms.  

The tool employs sum-of-squares (SoS) optimization-based automated search for Lyapunov functions. Open-source implementations for automated search of Lyapunov function are available for systems with polynomial dynamic fields; however, dynamic model of practical systems (e.g., in robotics, power systems, etc.) often comprise trigonometric terms. This toolbox can handle such systems (see our work [Resilience Indices for Power/Cyberphysical Systems](https://ieeexplore.ieee.org/abstract/document/9198917) for application in classical power system models).

The technical details can be found here. The tool, first, uses [Newton-Raphson](https://www.math.ubc.ca/~anstee/math104/newtonmethod.pdf) to compute an equilibrium of the trigonometric dynamic field. If it has multiple equilibria, one can specify the equilibrium (or its close initial guess) of interest. The tool then equivalently expresses the trigonometric field as a projection of a higher dimensional polynomial field onto an equidimensional manifold. In a nutshell, the search for the inner-estimate of a maximal RoA around the equilibrium is posed as an optimization problem involving a number of (nonconvex) semi-algebraic set emptiness constraints, which are equivalently expressed as SoS constraints via [Positivstellensatz](https://www.mit.edu/~parrilo/ecc03_course/06_positivstellensatz.pdf). To achieve computational tractability, only a convex sufficient condition is explored via semidefinite program (SDP), which serves as a certificate of set emptiness. The maxima is attained through an iterative local search.  

This toolbox was tested in MATLAB R2021a, but it should be backward compatible with prior MATLAB versions. [SOSTOOLS](https://www.cds.caltech.edu/sostools/) and any one of its supported backend SDP solvers are the only two dependencies, which need to be installed first (see [here](https://github.com/oxfordcontrol/SOSTOOLS) for their installation guidelines). Then simply clone this repo and add the cloned directory (including all its subdirectories) into MATLAB search path. SOSTOOLS supports various SDP solvers, but Mosek is recommended owing to its superior performance compared to the rest. Mosek is a commercial SDP solver, but a free license may be available from Mosek free of cost for academic usage (see [here](https://www.mosek.com/products/academic-licenses/) for more information).

See the example to get started. 

Please cite this repo as follows if you find it useful:

*S. Talukder, M. Ibrahim and R. Kumar, "Resilience Indices for Power/Cyberphysical Systems," in IEEE Transactions on Systems, Man, and Cybernetics: Systems, vol. 51, no. 4, pp. 2159-2172, April 2021, doi: 10.1109/TSMC.2020.3018706.*

For any questions or comments, please feel free to reach me at [talukder@iastate.edu](mailto:talukder@iastate.edu).
