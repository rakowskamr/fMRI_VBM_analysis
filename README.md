# fMRI_VBM_analysis
Analysis pipeline for functional MRI (fMRI) and voxel-based morphometry (VBM).

Contains scripts used to analyse fMRI data during SRTT perfromance (fMRI folder) and T1w structural images (VBM folder), as well as to extract individual datapoints from the significant clusters. ‘ROI masks’ folder contains a mask for each of the pre-defined anatomical region of interest (ROI) created using an Automated Anatomical Labeling (AAL) atlas in the Wake Forest University (WFU) PickAtlas toolbox (Maldjian et al., 2003). 

# The analysis step-by-step 
1. fMRI folder
- fMRI_Preprocessing.m - performs fMRI preprocessing steps
  * B0-fieldmap correction using SPM’s fieldmap toolbox
  * Realignment to the mean of the images using a least-squares approach and 6 parameter rigid body spatial transformation to correct for movement artifact 
  * Co-registration with the participants’ individual structural image using rigid body model
  * Spatial normalisation to MNI space via the segmentation routine and resampling to 2 mm voxels with a 4th degree B-spline interpolation
  * Smoothing with 8 mm full-width half maximum (FWHM) Gaussian kernel 
- fMRI_FirstLevel.m - performs subject-level analysis of the fMRI data using a general linear model (GLM)
  * Each block type (cued sequence, uncued sequence, cued random, uncued random) and the breaks between the blocks are modelled as five separate, boxcar regressors; button presses are modelled as single events with zero duration. 
  * Regressors are temporally convolved with a canonical hemodynamic response function (HRF) model embedded in SPM, with no derivatives. 
  * 6 head motion parameters generated during realignment are included in the design matrix as non-convolved nuisance regressors. 
  * A high-pass filter with a cut-off period of 128 s is used to remove low-frequency signal drifts. 
  * Serial correlations in the fMRI signal are corrected for using a first-order autoregressive model during REML parameter estimation.
  * Contrast images are obtained for each block type of interest ([cued sequence] and [uncued sequence]), as well as for the difference between the two ([cued > uncued]). The resulting parameter images are then used as an input for the group-level analysis. 
- fMRI_SecondLevel_onewayTtest.m - performs group-level analysis on the fMRI data using one-way t-tests 
  * To compare functional brain activity during the cued and uncued sequence perform one-way t-tests on the [cued > uncued] contrast for each session
  * To determine the relationship between the TMR-related functional activity and other factors, include behavioural cueing benefit as a covariate
  * To investigate fMRI changes over time, perform one-way t-tests as before but using subtraction images as an input (e.g. S1-S2) 
- MovementParameters.m - checks for excessive movement in the fMRI data
- MRI_part2_L2_sfArAtL_DESIGN_MATRIX_3_BlocksPressesBreaks_Learning.mat - example of a design matrix from participant 2, session 1, used as one of the inputs for the fMRI_FirstLevel.m script
- pm_defaults_3TE.m - defaults for creating field map, used as one of the inputs for the fMRI_Preprocessing.m script

2. VBM folder
- VBM_Preprocessing.m - performs VBM preprocessing
  * Segmentation into 3 tissue probability maps (grey matter, GM; white matter, WM; cerebrospinal fluid, CSF), with 2 Gaussians used to model each tissue class, very light bias regularisation (0.0001), 60 mm bias FWHM cut-off and default warping parameters. 
  * Spatial normalisation with DARTEL, where the GM and WM segments are used to create customized tissue-class templates and to calculate flow fields. These are subsequently applied to the native GM and WM images of each subject to generate spatially normalised and Jacobian scaled (i.e., modulated) images in the MNI space, resampled at 1.5 mm isotropic voxels. 
  * Smoothing with 8 mm FWHM Gaussian kernel, in line with the fMRI analysis. 
- fMRI_SecondLevel_onewayTtest.m - performs group-level one-way t-tests of the VBM data, separately for GM and WM (as specified by 50% tissue probability maps)
  * Images from consecutive sessions are subtracted from one another (e.g., S1-S2)
  * To determine the relationship between the longitudinal brain changes and other factors, one-sample t-tests are computed with behavioural covariates of interest specified. 
  * Sex is always specified as a covariate of no interest to control for differences between males and females. 
- VBM_TPM_0.5thresholded_masks - a folder with SPM12 tissue probability maps of GM and WM, thresholded at 50% probability and used in the analyses of the relevant tissue

3. Datapoints.m - extracts individual datapoints to check for outliers

4. ROImasks - contains a mask for each of the pre-defined anatomical ROIs 

# Requirements 
The pipeline requires MATLAB with SPM12 toolbox (https://www.fil.ion.ucl.ac.uk/spm/) to run. Use MicroGL (https://www.nitrc.org/projects/mricrogl) to display the results.

# Authors and contributors
* Martyna Rakowska

# Relevant methods section from Rakowska et al. (2022)

* Section 5.7.3.1 FMRI
* Section 5.7.3.2 VBM
* Section 5.7.4.3 MRI Data (statistical analysis)

# References
* Rakowska, M., Bagrowska, P., Lazari, A., Navarrete, M., Abdellahi, M. E., Johansen-Berg, H., & Lewis, P. A. (2022). Cueing motor memory reactivation during NREM sleep engenders learning-related changes in precuneus and sensorimotor structures. bioRxiv.
* Maldjian, J. A., Laurienti, P. J., Kraft, R. A., & Burdette, J. H. (2003). An automated method for neuroanatomic and cytoarchitectonic atlas-based interrogation of fMRI data sets. Neuroimage, 19(3), 1233-1239.
