%% First level fMRI analysis

clc
clear all
warning off
addpath('/YourDirectory/nii_tool'); % tool to extract number of volumes
spm fmri 

session = 2;                    % -----> define session (1, 2 or 3)
dsgmx   = '*DESIGN_MATRIX_3*';  % -----> specify design matrix
thresh = 0.05;                 % -----> set statistical thereshold (doesnt matter for 2nd level)
threshdesc = 'none';            % -----> 'none' 'FWE'

if session == 1
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
elseif session == 2
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,   15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,   33];    
elseif session == 3
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];      
end

%Participants excluded:
% all sessions: p1 (didnt hear sounds), p4 (withdrew), p18 (low EHI score and didnt improve on SRTT) 
% S1: none
% S2: p14 (MRI failed), p32 (no space on the scanner)
% S3: p5,p6,p7,p8,p9 (lockdown), p22 (online)
% * p24 - just B0fieldmap missing so run pre_processing but without B0fieldmapping
  
s = 1; % Just for testing
r = 1; % otherwise it doesnt run

%% Initialise spm
spm('defaults','fmri');
spm_jobman('initcfg');

%% Loop for participants
for s = 1:numel(sbj_num) % participants
fprintf(['\n Analysing participant: ' num2str(sbj_num(s)) ', Session: ' num2str(session) '\n']);
clear matlabbatch 
tic

%% Find files
dir_data = '/YourDirectory/data/';
dir_scratch = '/YourDirectory/scratch/';
cd(dir_data)  

% Find ppnt folder
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
    
% Find functional data
cd(dir_session);
f_folder = dir('*SRTT*');
f_folder = f_folder(1).name;
    
dir_ffolder     = [dir_session f_folder '/' ];
dir_ffolder_x   = [dir_session f_folder '/' ]; % this is where SPM.mat will save
cd(dir_ffolder)
    
ff_name = dir('sw*nii');
ff_name = ff_name(1).name;

ff_dir      = [dir_ffolder ff_name]; 
scan_num    = get_nii_frame(ff_dir);

for scan = 1:scan_num % number of scans 
    f_comp_file = [dir_ffolder ff_name ',' num2str(scan)];
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans{scan,1} = f_comp_file;
end

% Find time series of translations and rotation, realignment parameters
cd(dir_ffolder)
rp_name = dir('rp_*.txt');
rp_name = rp_name(1).name;
rp = [dir_ffolder rp_name];

% Find design matrix
SRTT = [dir_scratch 'SRTT_LTF/']; %LTF = learning, testing or followup (S1, S2, S3)
cd(SRTT)

if session      == 1
    SRTT_p      = dir('MRI_part*_L2');
    subfolder   = 'Learning';
    LTF = 'L2';
elseif session  == 2
    SRTT_p      = dir('MRI_part*_T1');
    subfolder   = 'Testing';
    LTF = 'T1';
elseif session  == 3
    SRTT_p      = dir('MRI_part*_F1');
    subfolder   = 'Follow_up';
    LTF = 'F1';
end

DMSname  = sprintf('MRI_part%d_%s',sbj_num(s),LTF);

DMS_dir = [SRTT DMSname '/MRI_results/' subfolder];
cd(DMS_dir)
DM = dir(dsgmx);

design_matrix = [DMS_dir '/' DM(1).name]; % specifies the design_matrix directory

%% 1st level
matlabbatch{1}.spm.stats.fmri_spec.dir              = {dir_ffolder_x}; % this is where SPM.mat will save
matlabbatch{1}.spm.stats.fmri_spec.timing.units     = 'secs'; % <------ scans or seconds
matlabbatch{1}.spm.stats.fmri_spec.timing.RT        = 2;      % <----- TR (2 seconds)
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t    = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0   = 8;

% Design matrix
matlabbatch{1}.spm.stats.fmri_spec.sess.cond        = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi       = {design_matrix}; 
matlabbatch{1}.spm.stats.fmri_spec.sess.regress     = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg   = {rp}; 
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf         = 128;

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt             = 1;
matlabbatch{1}.spm.stats.fmri_spec.global           = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh          = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask             = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi              = 'AR(1)';

%% Review
spm_file = [dir_ffolder 'SPM.mat'];
matlabbatch{2}.spm.stats.review.spmmat              = {spm_file};
matlabbatch{2}.spm.stats.review.display.matrix      = 1;
matlabbatch{2}.spm.stats.review.print               = 'ps';

%% Estimate
matlabbatch{3}.spm.stats.fmri_est.spmmat            = {spm_file};
matlabbatch{3}.spm.stats.fmri_est.write_residuals   = 0;
matlabbatch{3}.spm.stats.fmri_est.method.Classical  = 1;

%% Results - contrast <---------
matlabbatch{4}.spm.stats.con.spmmat                 = {spm_file};
matlabbatch{4}.spm.stats.con.consess                = {};
% Cued
 matlabbatch{4}.spm.stats.con.consess{1}.tcon.name  = 'cued';
 matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0];
 matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
% Uncued
 matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'uncued';
 matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0];
 matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
% Random cued 
 matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = 'random cued';
 matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0];
 matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
% Random uncued
 matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = 'random uncued';
 matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0 0];
 matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
% Key presses
 matlabbatch{4}.spm.stats.con.consess{5}.tcon.name = 'Key presses';
 matlabbatch{4}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1 0];
 matlabbatch{4}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
 % Break
 matlabbatch{4}.spm.stats.con.consess{6}.tcon.name = 'Break';
 matlabbatch{4}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1];
 matlabbatch{4}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';
% Blocks vs Break
 matlabbatch{4}.spm.stats.con.consess{7}.tcon.name = 'blocks - break';
 matlabbatch{4}.spm.stats.con.consess{7}.tcon.weights = [1 1 1 1 0 -1];
 matlabbatch{4}.spm.stats.con.consess{7}.tcon.sessrep = 'repl'; 
% Break vs blccks
 matlabbatch{4}.spm.stats.con.consess{8}.tcon.name = 'break - blocks';
 matlabbatch{4}.spm.stats.con.consess{8}.tcon.weights = [-1 -1 -1 -1 0 1];
 matlabbatch{4}.spm.stats.con.consess{8}.tcon.sessrep = 'repl';  
% Cued vs uncued
 matlabbatch{4}.spm.stats.con.consess{9}.tcon.name = 'cued - uncued';
 matlabbatch{4}.spm.stats.con.consess{9}.tcon.weights = [1 -1 0 0 0 0];
 matlabbatch{4}.spm.stats.con.consess{9}.tcon.sessrep = 'repl';  
 % UnCued vs cued
 matlabbatch{4}.spm.stats.con.consess{10}.tcon.name = 'uncued - cued';
 matlabbatch{4}.spm.stats.con.consess{10}.tcon.weights = [-1 1 0 0 0 0];
 matlabbatch{4}.spm.stats.con.consess{10}.tcon.sessrep = 'repl';
 % Seq vs random
 matlabbatch{4}.spm.stats.con.consess{11}.tcon.name = 'seq - random';
 matlabbatch{4}.spm.stats.con.consess{11}.tcon.weights = [1 1 -1 -1 0 0];
 matlabbatch{4}.spm.stats.con.consess{11}.tcon.sessrep = 'repl'; 
 % Presses
 matlabbatch{4}.spm.stats.con.consess{12}.tcon.name = 'presses';
 matlabbatch{4}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 1 0];
 matlabbatch{4}.spm.stats.con.consess{12}.tcon.sessrep = 'repl'; 
 % Presses - break
 matlabbatch{4}.spm.stats.con.consess{13}.tcon.name = 'presses - breaks';
 matlabbatch{4}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 1 -1];
 matlabbatch{4}.spm.stats.con.consess{13}.tcon.sessrep = 'repl'; 
 % All motor
 matlabbatch{4}.spm.stats.con.consess{14}.tcon.name = 'all motor';
 matlabbatch{4}.spm.stats.con.consess{14}.tcon.weights = [1 1 1 1 1 0];
 matlabbatch{4}.spm.stats.con.consess{14}.tcon.sessrep = 'repl';
 
matlabbatch{4}.spm.stats.con.delete = 0;

%% Results - results

matlabbatch{5}.spm.stats.results.spmmat                = {spm_file};
matlabbatch{5}.spm.stats.results.conspec.titlestr   = '';
matlabbatch{5}.spm.stats.results.conspec.contrasts  = Inf; % all contrasts specified above
matlabbatch{5}.spm.stats.results.conspec.threshdesc = threshdesc; %<---------
matlabbatch{5}.spm.stats.results.conspec.thresh     = thresh; % <-----------------------
matlabbatch{5}.spm.stats.results.conspec.extent     = 0;
matlabbatch{5}.spm.stats.results.conspec.conjunction= 1;
matlabbatch{5}.spm.stats.results.conspec.mask.none  = 1;
matlabbatch{5}.spm.stats.results.units              = 1;
matlabbatch{5}.spm.stats.results.export{1}.ps       = true;

spm_jobman('run',matlabbatch);

end
