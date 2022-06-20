%% VBM preprocessing
clc
clear all
warning off
addpath('/YourDirectory/nii_tool'); % tool to extract number of volumes
spm fmri 

%% Initialise spm
spm('defaults','fmri');
spm_jobman('initcfg');

%% Identify sessions
session = [1,2,3];                    % -----> define session (1, 2 or 3)

for session = 1:numel(session)
if session == 1
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    sbj_num=[];
    S1_sbj_num = numel(sbj_num);
elseif session == 2
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33];    
    S2_sbj_num = numel(sbj_num);
elseif session == 3
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];      
    S3_sbj_num = numel(sbj_num);
end

%% Identify subject

for s = 1:numel(sbj_num) % participants
clear matlabbatch 
tic
%% Find files
dir_data = '/YourDirectory/data/';
cd(dir_data)  

name  = dir(sprintf('*p%d',sbj_num(s)));
fname = name(1).name;

dir_ppnt = [dir_data fname '/'];
cd(dir_ppnt)
session_name = dir('S*');
for K = 1 : length(session_name)
    fname = session_name(K).name;
    name  = sprintf('S%d',session);
    if strcmp(fname(1:2), name); break; end
end

dir_session = [dir_ppnt fname '/'];
cd(dir_session);

% Find mprage files
s_folder = dir('*mprage');
s_folder = s_folder(1).name;
    
dir_sfolder = [dir_session s_folder '/'];
cd(dir_sfolder)
    
s_name = dir('*mprage*nii');
s_name = s_name(1).name;
 
compS_file = [dir_sfolder s_name ',1'];

%% Segment = identify WM & GM
% Creates a bunch of images:
% c1 = grey matter; c2 = white matter; c3 = CSF
% Names beginning with 'r' (e.g. rc1) are the DARTEL imported versions of tissue images
% These will be aligned together next

matlabbatch{1}.spm.spatial.preproc.channel.vols = {compS_file};
% *Bias regularisation* 
% The weight of the regularisation relates to the inverse of the noise variance
% smaller value = more noise to correct for
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.0001; %bias regularisation = light regularisation (0.001, default) 
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60; %bias FWHM of Gaussian smoothness of bias (60mm cutoff, default)
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0]; %dont save bias corrected


% Tissues to identify 

% *Num of Gaussians* - could be 2 for GM, 2 for WM, 2 for CSF, 
% 3 for bone, 4 for other soft tissues and 2 for air (background).
% The assumption of a single Gaussian distribution for each class does not 
% hold for a number of reasons. In particular, a voxel may not be purely 
% of 1 tissue type, and instead contain signal from a number of different 
% tissues (partial volume effects)
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/home/c1813013/spm12/tpm/TPM.nii,1'}; % grey matter tissue
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 2; %num. gaussians (default = 1 but Chen has 2)
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1]; % Native Tissue: [1 1] = save Native + DARTEL imported
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0]; % none
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/home/c1813013/spm12/tpm/TPM.nii,2'}; % white matter 
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 2; % default = 1 but chen = 2
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1]; %[1 1] = save Native + DARTEL imported
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/home/c1813013/spm12/tpm/TPM.nii,3'}; % CSF
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0]; % [1 0] = native space only - i need this for ICV calculation
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/home/c1813013/spm12/tpm/TPM.nii,4'}; % skull
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0]; % none
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/home/c1813013/spm12/tpm/TPM.nii,5'}; % soft tissue outside brain
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0]; % none
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/home/c1813013/spm12/tpm/TPM.nii,6'}; % air and outside of the head
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0]; % none
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];

% Warping
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1; % MRF parameter (1 = 1, default)
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1; % clean up (1 = light clean, default)
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2]; % warping regularisation, i.e. keeping deformations smooth (default)
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni'; % affine regularisation, default mni, chen = sbj
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0; % smoothness
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3; % sampling distance 
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0]; % deformation fields (0 0 = none)

%% Run dartel = 
% to increase the accuracy of inter-subject alignment 
% by modelling the shape of each brain using many parameters (three per voxel)
% Aligns GM among the images, while simultaneously aligning WM. 
% This is achieved by generating its own increasingly crisp average template data, 
% to which the data are iteratively aligned

% Etimates deformations that best align images together by regitering the
% imported images (rc1) with their average

% uses 'r' images (e.g. rc1, rc2, rc3) 
% outputs 'u' images (e.g. u_rc1,u_rc2, u_rc3) = flow fields that parameterise deformations
% outputs templates = uses u_rc1 for the creation of the 1st template,
% incorporates smoothing procedure. 1st template based on average of the
% original data, last template = average of darterl registered data

matlabbatch{2}.spm.tools.dartel.warp.images{1}(1) = cfg_dep('Segment: rc1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.images{2}(1) = cfg_dep('Segment: rc2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.settings.template = 'Template'; % all defaults
matlabbatch{2}.spm.tools.dartel.warp.settings.rform = 0; 
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.its = 3;

%% Normalise to MNI space and smooth
% uses u_rc1, u_rc2 images (flow fields encoding shapes)
% uses template 6 (the last one) - registered to MNI space, allows transformations to be combined so that all the individual spatially normalised scans can also be brought into MNI space
% uses c1, c2 segmented raw data
% outputs smwc1, smwc2 images = smootheed, spatially normalised, Jacobian scaled images in MNI space
matlabbatch{3}.spm.tools.dartel.mni_norm.template(1) = cfg_dep('Run Dartel (create Templates): Template (Iteration 6)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','template', '()',{7}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.flowfields(1) = cfg_dep('Run Dartel (create Templates): Flow Fields', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.images{1}(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.images{2}(1) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN]; % voxel size [NaN NaN NaN = 1.5mm, default] - The default value can be used even if your actual voxel size is smaller. After spatial registration and smoothing your effective spatial resolution will be lowered and the value of 1.5mm is a good compromise.
matlabbatch{3}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN]; % bounding box (default)
matlabbatch{3}.spm.tools.dartel.mni_norm.preserve = 1; % preserve, 1 = preserve amount ('modulation') - default for VBM
matlabbatch{3}.spm.tools.dartel.mni_norm.fwhm = [8 8 8]; % Gaussian FWHM = specifies size of gaussian for smoothing, typically between 4mm and 12mm


spm_jobman('run',matlabbatch); % run this first, then the rest because dependency doesnt work here
clear matlabbatch; 

end
end 