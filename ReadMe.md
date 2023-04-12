## Learning Generative Models of the Geometry and Topology of Tree-like 3D Objects
This is an example code for the paper "Learning Generative Models of the Geometry and Topology of Tree-like 3D Objects" by Guan Wang, Hamid Laga, and Anuj Srivastava.

In this paper, we develop a novel mathematical framework for representing, comparing, and computing geodesic deformations between the shapes of tree-like 3D objects, such as neuronal and botanical trees. Details could be found in our [project website](https://fanta007.github.io/complexTrees_website/).


### How to use the code

- compile *DynamicProgrammingQ.c* using *mex* command in matlab: ```mex DynamicProgrammingQ.c```

- run ```eg1_geodesic_botanTrees.m``` to compute the geodesic between a pair of botancial trees
- run ```eg1_mean_botanTrees.m``` to compute the mean shape for a group of botancial trees
- run ```eg1_modesAndSamples_botanTrees.m``` to compute the principal variance mode and random samples for a group of botancial trees

- The same operations apply to neuronal trees. Run files named as ```eg2_xxxx.m```

The 3D model rendering part is adapted from this [MatlabRenderToolbox](https://github.com/llorz/MatlabRenderToolbox) by [Jing Ren](https://github.com/llorz?tab=repositories).


### Comments
- This work is an extension and generalization of [Duncan's work](https://scholar.google.com.au/citations?view_op=view_citation&hl=en&user=Kj-lB0MAAAAJ&cstart=20&pagesize=80&sortby=pubdate&citation_for_view=Kj-lB0MAAAAJ:6syOTa9L3GQC), which focused on simple 2D tree-shaped objects.

- A key component of this work is Square Root Velocity Functions (SRVF), which is used to carry out elastic analysis of curves. The description and relevant codes on SRVF could be found at [this website](https://www.asc.ohio-state.edu/kurtek.1/cbms.html).

### Other related publications
- **[‪Statistical shape analysis of simplified neuronal trees‬](https://scholar.google.com.au/citations?view_op=view_citation&hl=en&user=Kj-lB0MAAAAJ&cstart=20&pagesize=80&sortby=pubdate&citation_for_view=Kj-lB0MAAAAJ:6syOTa9L3GQC)**
by *Adam Duncan, Eric Klassen, Anuj Srivastava*

- **[Statistical analysis and modeling of the geometry and topology of plant roots](https://www.sciencedirect.com/science/article/pii/S0022519319304771)** by *Guan Wang, Hamid Laga, Jinyuan Jia, Stanley J. Miklavcic, Anuj Srivastava*

### License

[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/). For any commercial uses or derivatives, please contact us (wangguan12621@gmail.com, H.Laga@murdoch.edu.au, anuj@stat.fsu.edu).

### Citation

If you use the code, please make sure you cite:

```
@article{wang2023statistical,
  title={Learning Generative Models of the Geometry and Topology of Tree-like 3D Objects},
  author={Wang, Guan and Laga, Hamid and Srivastava, Anuj},
  journal={arXiv preprint arXiv:2110.08693},
  year={2023}
}
```
