# fMRI_VBM_analysis
Analysis pipeline for functional MRI and voxel-based morphometry

Contains scripts used to analyse fMRI (fMRI folder) and T1w data (VBM folder) data, as well as to extract individual datapoints from the significant clusters. ‘ROI masks’ folder contains a mask for each pre-defined anatomical region of interest (ROI) created using an Automated Anatomical Labeling (AAL) atlas in the Wake Forest University (WFU) PickAtlas toolbox (Maldjian et al., 2003). 

# The analysis step-by-step 
1. fMRI folder
- fMRI_Preprocessing.m - performs fMRI preprocessing
- fMRI_FirstLevel.m - performs first level analysis of the fMRI data
- fMRI_Second_level_onewayTtest.m - performs second level one-way t-tests on the fMRI data
- MovementParameters.m - checks for excessive movement in the fMRI data
- MRI_part2_L2_sfArAtL_DESIGN_MATRIX_3_BlocksPressesBreaks_Learning.mat - example of a design matrix from participant 2, session 1, used as one of the inputs for the fMRI_FirstLevel.m script
- pm_defaults_3TE.m - defaults for creating field map, used as one of the inputs for the fMRI_Preprocessing.m script

2. VBM folder
- VBM_Preprocessing.m - performs VBM preprocessing
- fMRI_Second_level_onewayTtest.m -performs second level one-way t-tests of the VBM data
- VBM_TPM_0.5thresholded_masks - folder containing SPM12 tissue probability maps of grey matter (GM) and white matter (WM) thresholded at 50% probability, used in the analyses of the relevant tissue

# Requirements 
The pipeline requires MATLAB with SPM12 toolbox (https://www.fil.ion.ucl.ac.uk/spm/) to run. Use MicroGL (https://www.nitrc.org/projects/mricrogl) to display the results.

# Authors and contributors
* Martyna Rakowska

# Relevant methods section from Rakowska et al. (2022)

5.7.3.1 FMRI
PRE-PROCESSING
Functional data pre-processing consisted of (1) B0-fieldmap correction using SPM’s fieldmap toolbox71; (2) realignment to the mean of the images using a least-squares approach and 6 parameter rigid body spatial transformation to correct for movement artifact72; (3) co-registration with the participants’ individual structural image using rigid body model73; (4) spatial normalisation to Montreal Neurological Institute brain (MNI space) via the segmentation routine and resampling to 2 mm voxels with a 4th degree B-spline interpolation74; (5) smoothing with 8 mm full-width half maximum (FWHM) Gaussian kernel in line with the literature10. All steps were performed as implemented in SPM12. B0-fieldmap correction step was omitted for one participant (n = 1) due to technical issues during B0-fieldmap acquisition. No scans had to be excluded due to excessive movement (average translations < 3.3 mm, average rotations < 0.03°).

SINGLE SUBJECT LEVEL ANALYSIS
Subject-level analysis of the fMRI data was performed using a general linear model (GLM)75, constructed separately for each participant and session. Each block type (cued sequence, uncued sequence, cued random, uncued random) as well as the breaks between the blocks were modelled as five separate, boxcar regressors; button presses were modelled as single events with zero duration. All of these were temporally convolved with a canonical hemodynamic response function (HRF) model embedded in SPM, with no derivatives. To control for movement artifacts, the design matrix also included six head motion parameters, generated during realignment, as non-convolved nuisance regressors. A high-pass filter with a cut-off period of 128 s was implemented in the matrix design to remove low-frequency signal drifts. Finally, serial correlations in the fMRI signal were corrected for using a first-order autoregressive model during restricted maximum likelihood (REML) parameter estimation. Contrast images were obtained for each block type of interest ([cued sequence] and [uncued sequence]), as well as for the difference between the two ([cued > uncued]). The resulting parameter images, generated per participant and per session using a fixed-effects model, were then used as an input for the group-level (i.e., random effects) analysis. Contrast images for the difference between sequence and random blocks were not generated due to the unequal number of each block type performed in the scanner (2 random blocks vs 24 sequence blocks, per session). This, however, was in accordance with the literature10.

5.7.3.2 VBM
PRE-PROCESSING
Pre-processing of T1w images was performed in keeping with 76 recommendations. Images were first segmented into three tissue probability maps (grey matter, GM; white matter, WM; cerebrospinal fluid, CSF), with two Gaussians used to model each tissue class, very light bias regularisation (0.0001), 60 mm bias FWHM cut-off and default warping parameters74. Spatial normalisation was performed with DARTEL77, where the GM and WM segments were used to create customized tissue-class templates and to calculate flow fields. These were subsequently applied to the native GM and WM images of each subject to generate spatially normalised and Jacobian scaled (i.e., modulated) images in the MNI space, resampled at 1.5 mm isotropic voxels. The modulated images were smoothed with an 8 mm FWHM Gaussian kernel, in line with the fMRI analysis. To account for any confounding effects of brain size we estimated the total intracranial volume (ICV) for each participant at each time point by summing up the volumes of the GM, WM, and CSF probability maps, obtained through segmentation of the original images. The GM and WM images were then proportionally scaled to the ICV values by means of dividing intensities in each image by the image’s global (i.e., ICV) value before statistical comparisons.

5.7.4 STATISTICAL ANALYSIS
...
5.7.4.3 MRI DATA
Group level analysis of the MRI data was performed either in a Multivariate and Repeated Measures (MRM) toolbox (https://github.com/martynmcfarquhar/MRM) or in SPM12, both running under MATLAB 2018b. All tests conducted were two-tailed, testing for both positive and negative effects. Results were voxel-level corrected for multiple comparisons by family wise error (FWE) correction for the whole brain and for the pre-defined anatomical regions of interest (ROI), with the significance threshold set at pFWE < 0.05. For the analysis performed in MRM, p-values were derived from 1,000 permutations, with Wilk’s lambda specified as the test statistic. Pre-defined ROI included (1) bilateral precuneus, (2) bilateral hippocampus and parahippocampus, (3) bilateral dorsal striatum (putamen and caudate), (4) bilateral cerebellum, (5) bilateral sensorimotor cortex (precentral and postcentral gyri). All ROI were selected based on their known involvement in sleep-dependent procedural memory consolidation23,24,46,47 and memory reactivation6,10,12,14,31. A mask for each ROI was created using an Automated Anatomical Labeling (AAL) atlas in the Wake Forest University (WFU) PickAtlas toolbox82. Anatomical localisation of the significant clusters was determined with the automatic labelling of MRIcroGL (https://www.nitrc.org/projects/mricrogl/) based on the AAL atlas. All significant clusters are reported in the tables, but only those with an extent equal to or above 5 voxels are discussed in text and presented in figures.

FMRI DATA
To test the effect of TMR on the post-stimulation sessions (S2-S3), one-dimensional contrast images for the [cued] and [uncued] blocks of each session were entered into a repeated-measures TMR-by-Session ANOVA performed in the MRM toolbox.

To compare functional brain activity during the cued and uncued sequence we carried out one-way t-tests on the [cued > uncued] contrast for S2 (n = 28) and S3 (n = 24) in SPM12. To determine the relationship between the TMR-related functional activity and other factors, we included the behavioural cueing benefit for the BH dataset at different time points (S2, S3, S4) as covariates in separate comparisons. Finally, to investigate fMRI changes over time, images from consecutive sessions were subtracted from one another, resulting in three subtraction images per subject (S1-S2, n = 28; S2-S3, n = 22; S1-S3, n = 24). We then performed the one-way t-tests as before (either with or without a covariate of interest).

VBM DATA
Group-level analysis of the structural images was performed separately for GM and WM. First, the preprocessed and proportionally scaled images from consecutive sessions were subtracted from one another as for fMRI (S1-S2, n = 30; S2-S3, n = 24; S1-S3, n = 24). To determine the relationship between the longitudinal brain changes and other factors, one-sample t-tests were computed in SPM12, with covariates of interest added one at a time. The covariates of interest were the behavioural cueing benefit for the BH dataset at a chosen time point (S2, S3, S4). Sex was always specified as a covariate of no interest (nuisance covariate) to control for differences between males and females. Finally, the SPM12 tissue probability maps of GM and WM were thresholded at 50% probability and the resulting binary masks were used in the analyses of the relevant tissue83.

# References
* Rakowska, M., Bagrowska, P., Lazari, A., Navarrete, M., Abdellahi, M. E., Johansen-Berg, H., & Lewis, P. A. (2022). Cueing motor memory reactivation during NREM sleep engenders learning-related changes in precuneus and sensorimotor structures. bioRxiv.
* Maldjian, J. A., Laurienti, P. J., Kraft, R. A., & Burdette, J. H. (2003). An automated method for neuroanatomic and cytoarchitectonic atlas-based interrogation of fMRI data sets. Neuroimage, 19(3), 1233-1239.
