%% fMRI pre-processing pipeline

% Pipeline
% 1. Identify raw files
% 2. B0 fieldmapping = calculate and apply vdm 
% 3. Realign = motion correction
% 4. Coregister = align fMRI with MPRAGE
% 5. Segment 
% 6. Normalise functional & structural = align with MNI space (standard
% space)(note that we never use normalised structural image, i.e. wm, here 
% but we can later on to superimpose subject's functional activation on their anatomy) 
% 7. Smooth = blur anatomical differences and registration errors

clc
clear all
warning off
addpath('/YourDirectory/nii_tool'); % tool to extract number of volumes
addpath('/YourDirectory/');
session = 3; % define session (1, 2 or 3)

if session == 1     
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]; % define subjects for session
elseif session == 2
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13   ,15,16,17,19,20,21,22,23,   25,26,27,28,29,30,31,  33]; %p24 missing B0 fieldmapping
elseif session == 3
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];
end
    
%Participants excluded:
% all sessions: p1 (didnt hear sounds), p4 (withdrew), p18 (positive slope of learning curve at S1)
% S1: none
% S2: p14 (MRI failed), p24 (just B0fieldmap missing), p32 (no space on the scanner)
% S3: p5,p6,p7,p8,p9 (lockdown), p22 (online)

r = 1; % otherwise it doesnt run

% initialise spm
spm('defaults','fmri');
spm_jobman('initcfg');

for s = 1:numel(sbj_num) % participants
fprintf(['\n Analysing participant: ' num2str(sbj_num(s)) ', Session: ' num2str(session) '\n']);
clear matlabbatch compS_file comp_file compB02_file compB01_file
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
    name    = sprintf('S%d',session);
    if strcmp(fname(1:2), name); break; end
end

dir_session = [dir_ppnt fname '/']; 
cd(dir_session);

% Find B0 fieldmapping data
% magnitude file (assumes the correct magnitude file is the first one, e1)
B0_folder = dir('*B0fieldmapping');
B01_folder = B0_folder(1).name;
    
dir_B01folder = [dir_session B01_folder '/'];
cd(dir_B01folder)

B01_folder = dir;
ok_folder = 0;
for i = 1:length(B01_folder)
    if contains(B01_folder(i).name,'e1.nii')
        ok_folder = 1;
    end
end

if ok_folder == 1        
    B01_name = dir('*e1.nii'); % select the first image
    B01_name = B01_name(1).name;
else 
    B01_folder = B0_folder(2).name; % second folder called B0 fieldmapping 
    dir_B01folder = [dir_session B01_folder '/'];
    cd(dir_B01folder)
    B01_name = dir('*e1.nii'); % select the first image
    B01_name = B01_name(1).name;
end
    
compB01_file = [dir_B01folder B01_name ',1'];
magnitude_image = compB01_file; 

% phase file (assumes the phase is in the second B0 fieldmapping folder)
cd(dir_session);
B0_folder = dir('*B0fieldmapping');
B02_folder = B0_folder(2).name; % second folder called B0 fieldmapping 
    
dir_B02folder = [dir_session B02_folder '/'];
cd(dir_B02folder)

B02_folder = dir;
ok_folder2 = 0;
for i = 1:length(B02_folder)
    if contains(B02_folder(i).name,'ph.nii')
        ok_folder2 = 1;
    end
end

if ok_folder2 == 1
    B02_name = dir('*ph.nii');
    B02_name = B02_name(1).name;
else 
    B02_folder = B0_folder(1).name; % first folder called B0 fieldmapping 
    dir_B02folder = [dir_session B02_folder '/'];
    cd(dir_B02folder)
    B02_name = dir('*ph.nii'); % select the first image
    B02_name = B02_name(1).name;
end 
     
compB02_file = [dir_B02folder B02_name ',1'];
phase_image = compB02_file; 

% Find structural data
cd(dir_session);
s_folder = dir('*mprage');
s_folder = s_folder(1).name;
    
dir_sfolder = [dir_session s_folder '/'];
cd(dir_sfolder)
    
s_name = dir('*mprage*nii');
s_name = s_name(1).name;
 
compS_file = [dir_sfolder s_name ',1'];

% Find functional data
cd(dir_session);
f_folder = dir('*SRTT*');
f_folder = f_folder(1).name;
    
dir_ffolder = [dir_session f_folder '/'];
cd(dir_ffolder)
    
f_name = dir('*SRTT_fMRI*nii');
f_name = f_name(1).name;

f_dir = [dir_ffolder f_name]; 
scan_num = get_nii_frame(f_dir); % get number of scans (maximum 720 for this study)

for scan = 1:scan_num % number of scans 
    comp_file = [dir_ffolder f_name ',' num2str(scan)];
    if scan == 1   
      matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {comp_file}; % first scan for fieldmap
    end
     matlabbatch{2}.spm.tools.fieldmap.applyvdm.data.scans{scan,1} = comp_file; %all scans for fieldmapping

end
   
    
%% Fieldmap

% Create VDM
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = {phase_image}; % phase image specified when looking for the raw data
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = {magnitude_image}; % magnitude image specified when looking for the raw data
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'/YourDirectory/pm_defaults_3TE.m'}; % this is 3TM scanner defaults, same for all participants
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = ''; %Marco {''}
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;

% Apply VDM

% All fMRI images specified when looking for the raw data as:
% matlabbatch{2}.spm.tools.fieldmap.applyvdm.data.scans{scan,1} = comp_file
matlabbatch{2}.spm.tools.fieldmap.applyvdm.data.vdmfile(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{1}));
matlabbatch{2}.spm.tools.fieldmap.applyvdm.roptions.pedir = 2;
matlabbatch{2}.spm.tools.fieldmap.applyvdm.roptions.which = [2 0]; % reslice all images [2 1] or without mean image [2 0] 
matlabbatch{2}.spm.tools.fieldmap.applyvdm.roptions.rinterp = 4;
matlabbatch{2}.spm.tools.fieldmap.applyvdm.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.tools.fieldmap.applyvdm.roptions.mask = 1;
matlabbatch{2}.spm.tools.fieldmap.applyvdm.roptions.prefix = 'u';

spm_jobman('run',matlabbatch); % run fieldmapping first, then the rest because dependency doesnt work for realignment so need to get the files manualy
clear matlabbatch; 

%% Realign
%find u files from fieldmapping to use in the realignment
cd(dir_ffolder)
    
uf_name = dir('u*SRTT_fMRI*nii');
uf_name = uf_name(1).name;

uf_dir = [dir_ffolder uf_name]; 
uf_scan_num = get_nii_frame(uf_dir); % get number of scans (maximum 720)

for uf_scan = 1:uf_scan_num % number of scans 
    uf_comp_file = [dir_ffolder uf_name ',' num2str(uf_scan)];
    matlabbatch{1}.spm.spatial.realign.estwrite.data{1,r}{uf_scan,1} = uf_comp_file; 
end

% realign

matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1; % register to mean
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1]; % All images + mean [2 1]
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';

%% Coregister
matlabbatch{2}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
% Raw data specified when looking for the files as, now input it here: 
matlabbatch{2}.spm.spatial.coreg.estimate.source = {compS_file};
matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

%% Segment
matlabbatch{3}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{3}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{3}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{3}.spm.spatial.preproc.tissue(1).tpm = {'/YourDirectory/spm12/tpm/TPM.nii,1'};
matlabbatch{3}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{3}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(2).tpm = {'/YourDirectory/spm12/tpm/TPM.nii,2'};
matlabbatch{3}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{3}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(3).tpm = {'/YourDirectory/spm12/tpm/TPM.nii,3'};
matlabbatch{3}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(4).tpm = {'/YourDirectory/spm12/tpm/TPM.nii,4'};
matlabbatch{3}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{3}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).tpm = {'/YourDirectory/spm12/tpm/TPM.nii,5'};
matlabbatch{3}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{3}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).tpm = {'/YourDirectory/spm12/tpm/TPM.nii,6'};
matlabbatch{3}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{3}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{3}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{3}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{3}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{3}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{3}.spm.spatial.preproc.warp.write = [0 1];

%% Normalise functional
matlabbatch{4}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{4}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','cfiles'));
matlabbatch{4}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{4}.spm.spatial.normalise.write.woptions.vox = [2 2 2]; 
matlabbatch{4}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{4}.spm.spatial.normalise.write.woptions.prefix = 'w';

%% Normalise structural
matlabbatch{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{1, 3}, '.','val', '{}',{1, 1}, '.','val', '{}',{1, 1}), substruct('.','fordef', '()',{':'}));
matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{1, 3}, '.','val', '{}',{1, 1}, '.','val', '{}',{1, 1}), substruct('.','channel', '()',{1, 1}, '.','biascorr', '()',{':'}));
matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{5}.spm.spatial.normalise.write.woptions.vox = [1 1 1]; 
matlabbatch{5}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{5}.spm.spatial.normalise.write.woptions.prefix = 'w';

%% Smooth
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{1, 4}, '.','val', '{}',{1, 1}, '.','val', '{}',{1, 1}, '.','val', '{}',{1, 1}), substruct('()',{1, 1}, '.','files'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8]; 
matlabbatch{6}.spm.spatial.smooth.dtype = 0;
matlabbatch{6}.spm.spatial.smooth.im = 0;
matlabbatch{6}.spm.spatial.smooth.prefix = 's';

spm_jobman('run',matlabbatch);
toc
end 