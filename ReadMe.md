## Learning Generative Models of the Geometry and Topology of Tree-like 3D Objects
This is an example code for the paper "Learning Generative Models of the Geometry and Topology of Tree-like 3D Objects" by Guan Wang, Hamid Laga, and Anuj Srivastava.

In this paper, we develop a novel mathematical framework for representing, comparing, and computing geodesic deformations between the shapes of such tree-like 3D objects. Details could be found in our [project website](https://fanta007.github.io/elasticComplexTrees/).


### How to use the code

- compile *DynamicProgrammingQ.c* using *mex* command in matlab: ```mex DynamicProgrammingQ.c```

- run ```eg1_geodesic_botanTrees.m``` to compute the geodesic between a pair of botancial trees
- run ```eg1_mean_botanTrees.m``` to compute the mean shape for a group of botancial trees
- run ```eg1_modesAndSamples_botanTrees.m``` to compute the principal variance mode and random samples for a group of botancial trees

- The same operations apply to neuron sturctures. Run files named as ```eg2_xxxx.m```

The 3D model rendering part is adapted from this [MatlabRenderToolbox](https://github.com/llorz/MatlabRenderToolbox) by [Jing Ren](https://github.com/llorz?tab=repositories).

### License

[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/). For any commercial uses or derivatives, please contact us (wangguan12621@gmail.com, H.Laga@murdoch.edu.au, anuj@stat.fsu.edu).
