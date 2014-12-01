RY-dFBA
========================

RY-dFBA (Robust Yeast dynamic Flux Balance Analysis) includes the MATLAB files used for simulations in the following publication:

Benjamín J. Sánchez, José R. Pérez-Correa, Eduardo Agosin (2014). Construction of robust dynamic genome-scale metabolic model structures of Saccharomyces cerevisiae through iterative re-parameterization. Metabolic Engineering 25:159–173. (doi:10.1016/j.ymben.2014.07.004)

RY-dFBA is intended for a better understanding of the mathematical procedure detailed in the publication, and for eventual replication of the results and/or modification for other dFBA problems. However, it is not intended as a general platform for dFBA modeling, and therefore the authors cannot guarantee that it will work for any given genome scale model and/or experimental conditions. Also, all scripts should be checked and appropiately changed if other conditions should be tested.

RY-dFBA was programmed by Benjamín J. Sánchez (@BenjaSanchez), excluding the functions identifica, ksensibilidadBSB and intconfianzaBSB, that were programmed by Dr. Claudio Gelmi (www.systemsbiology.cl), Engineering School, Pontificia Universidad Católica de Chile.

Last update: 2014-11-29

========================

## Required Software:

### Minimum Software:

* MATLAB (7.5 or higher) + Optimization Toolbox (http://www.mathworks.com/).
* Scatter Search for MATLAB (SSm), available free of charge for academic users at http://www.iim.csic.es/~gingproc/ssmGO.html. Note that the folder should be inside the main folder of RY-dFBA.
* The COBRA toolbox for MATLAB, available free of charge at http://opencobra.sourceforge.net/openCOBRA/Welcome.html. Note that libSBML (http://sbml.org/Software/libSBML) and the SBML toolbox (http://sbml.org/Software/SBMLToolbox) should both be installed for COBRA to be correctly running. Both of them are free of charge for academic users. Aditionally, you should add the cobra folder to your MATLAB search path.
* A genome scale metabolic model (GEM) in SBML format, inside the /data folder of RY-dFBA.
* Microsoft Office 2007 or higher (for excel processing of data)

### Recommended Software:

* Gurobi 5.0 or higher (http://www.gurobi.com/) set as optimizer in COBRA, otherwise the QP problems could take excesive computational time. Gurobi is free of charge for academic users.
* The Parallel Computing Toolbox for MATLAB, for accelerating computations (use parpool at the beginning of RY_dFBA.m)

========================

## Considerations for using RY-dFBA:

In order to correctly perform the procedure shown in the publication, the following order should be followed:

* **STEP 1:** Change the file "DATA.xls" (inside the /data folder) with your own experimental conditions. Do the same with "transcriptomic_aerobic.xlsx" and "transcriptomic_anaerobic.xlsx".

* **STEP 2:** Run convertData.m in the /data folder. If everything went ok, files called "d[i].mat" should appear in the /data folder, with all the model data and experimental information.

* **STEP 3:** Run RY_dFBA in the main folder, for each of the datasets, using "RY_dFBA(i)", with i being the corresponding dataset (the sheet number in the Excel file). Once it finishes (could be up to a day in some cases), the following files should appear in the main folder:
    * it_results_d[i]_pre.mat: All of the results of the first parameter estimation and pre/post regression analysis.
    * it_d[i].mat: All results from the reparametrization.
    * cmp_d[i].mat: All the CC's of each solution of the iterative tree with no sensitivity or identifiability problems.
    * it_results_d[i]_post.mat: All of the results of the last parameter estimation and pre/post regression analysis.
    * fitting_d[i].fig: A MATLAB figure displaying the fit of the final model to the experimental results.

========================

## Licensing:

RY-dFBA is available for free (for academic or non commercial purposes only) at https://github.com/BenjaSanchez/RY-dFBA
