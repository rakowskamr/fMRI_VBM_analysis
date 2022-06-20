%% Second level fMRI analysis

clc
clear all
warning off
%spm fmri 

session_to_analyse = 13; % <--- choose session to analyse: 1 = S1, 2 = S2, 3 = S3, 12 = S1-S2, 23 = S2-S3, 13 = S1-S3 
session = 13;
cov = 0; % <---- choose covariates: 0 = none, 5 = BehS2, 6 = BehS3, 7= BehS4, 8 = N2%, 9 = N3%, 10 = REM% 

if session_to_analyse == 2 && cov == 0
    secondlv_dir = '.YourDirectory/2ndlevelResults/OneWayTtest/S2/nocov/'; % this needs to end with '/'
elseif session_to_analyse == 3 && cov == 0
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/nocov/'; % this needs to end with '/'
elseif session_to_analyse == 1 && cov == 0
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S1/nocov/'; % this needs to end with '/'
elseif session_to_analyse == 12 && cov == 0
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S2/nocov/';
elseif session_to_analyse == 23 && cov == 0
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S2S3/nocov/';
elseif session_to_analyse == 13 && cov == 0
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S3/nocov/';

    
elseif session_to_analyse == 2 && cov == 5
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S2/BehS2/'; % this needs to end with '/'
elseif session_to_analyse == 2 && cov == 6
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S2/BehS3/'; % this needs to end with '/'
elseif session_to_analyse == 2 && cov == 7
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S2/BehS4/'; % this needs to end with '/'
elseif session_to_analyse == 2 && cov == 8
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S2/N2perc/'; % this needs to end with '/'
elseif session_to_analyse == 2 && cov == 9
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S2/N3perc/'; % this needs to end with '/'
elseif session_to_analyse == 2 && cov == 10
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S2/REMperc/'; % this needs to end with '/'
elseif session_to_analyse == 23 && cov == 5
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S2S3/CBS2/';
elseif session_to_analyse == 23 && cov == 6
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S2S3/CBS3/';
elseif session_to_analyse == 23 && cov == 7
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S2S3/CBS4/';
    
elseif session_to_analyse == 3 && cov == 5
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/BehS2/'; % this needs to end with '/'
elseif session_to_analyse == 3 && cov == 6
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/BehS3/'; % this needs to end with '/'
elseif session_to_analyse == 3 && cov == 7
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/BehS4/'; % this needs to end with '/'
elseif session_to_analyse == 3 && cov == 8
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/N2perc/'; % this needs to end with '/'
elseif session_to_analyse == 3 && cov == 9
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/N3perc/'; % this needs to end with '/'
elseif session_to_analyse == 3 && cov == 10
    secondlv_dir = '/YourDirectory/2ndlevelResults/OneWayTtest/S3/REMperc/'; % this needs to end with '/'
elseif session_to_analyse == 13 && cov == 5
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S3/CBS2/';
elseif session_to_analyse == 13 && cov == 6
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S3/CBS3/';
elseif session_to_analyse == 13 && cov == 7
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S3/CBS4/';

    
elseif session_to_analyse == 12 && cov == 5
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S2/CBS2/';
elseif session_to_analyse == 12 && cov == 6
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S2/CBS3/';
elseif session_to_analyse == 12 && cov == 7
    secondlv_dir = '/YourDirectory/fMRIovertime/OnewayTtest/S1S2/CBS4/';
    

end



%data_dir = '/Volumes/G-DRIVE mobile/MRI_study/MRIanalysis/fMRI/1stlevelContrasts/';
data_dir = '/YourDirectory/fMRIovertime';
cd(data_dir)

CUC_S1 = '/YourDirectory/1stlevelContrasts/CUC_S1';
CUC_S2 = '/YourDirectory/1stlevelContrasts/CUC_S2';
CUC_S3 = '/YourDirectory/1stlevelContrasts/CUC_S3';
S1S2 = '/YourDirectory/fMRIovertime/S1S2';
S2S3 = '/YourDirectory/fMRIovertime/S2S3';
S1S3 = '/YourDirectory/fMRIovertime/S1S3';

%for session = 1:numel(session)
if session == 1
    
    if cov == 0 || cov == 5 || cov == 6 || cov == 7
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    
    
    elseif cov == 8 || cov == 9 || cov == 10
    sbj_num = [2,3,5,6,7,8,9,10,11,  ...
               13,14,15,16,17,19,20,21,22,23,...
               24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    
     S1_percN2 = [27.5; 50.68143082; 56.0; 46.3; 49.5; 50.6; 47.6; 47.1; 49.2;...
                39.2; 51.5; 44.0; 52.9; 59.7; 45.8; 59.13201141; 53.9; 43.3; 47.3;...
                26.0; 49.3; 37.0; 47.13114929; 39.0; 46.2; 36.0; 48.5; 48.3; 45.4];
    S1_percSWS = [23.1; 14.56558704; 20.1; 21.5; 19.2; 18.5; 23.6; 13.4; 18.6;...
                 16.3; 22.3; 21.4; 15.6; 14.5; 21.2; 18.53526306; 16.3; 22.1;21.9;...
                13.9; 19.0; 20.9; 25.32786942; 24.4; 23.0; 15.0; 23.3; 27.0; 22.9];
    S1_percREM = [9.6; 22.1; 16.4;19.5; 19.2; 18.7; 12.2; 18.2; 15.4;...
                12.3; 15.7; 24.1; 12.2; 14.1; 18.5; 13.20072269; 9.8; 12.4; 15.7;...
                9.7; 21.8; 16.5; 18.11475372; 13.1; 18.9; 10.8; 17.5; 16.3; 18.2];
    
    end
    S1_sbj_num = numel(sbj_num);

elseif session == 2
    
    if cov == 0 || cov == 5
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,   15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,   33];    
    
    S2_BehS2 =[26.8125; 17.46448413; 88.22857143; 79.10416667; -9.680555556; 7.875; -29.97916667; -7.923611111; -7.313095238; 23.375;...
               43.97480159;          19.56406396; -9.993055556; -29.9375; -19.98730159; 89.18055556; 8.513888889; -30.04047619; -39.27777778; -19.99305556;...
               48.47916667; -18.78472222; -35.34722222; -28.00694444; 40.58333333; 39.49305556; 57.39583333;              9.569444444];
    elseif cov == 6
    sbj_num = [2,3,                 10,11,12,...
               13,   15,16,17,19,20,21,22,23,...
               24,25,26,27,28,29,30,31,   33];    
        
    S2_BehS3 =[8.622619048; -26.09920635;        6.090277778; 60.86805556; 40.2140873;...
               18.79861111;           -7.173611111; 16.36111111; 15.23611111; -13.5718254; 71; 25.18055556; -53.00538194; 19.60416667;...
               -21.6875; 30.73611111; -27.25; -5.868055556; -3.833333333; 41.84722222; 27.91666667; 2.618055556;        -46.38888889];
    
    elseif cov == 7
    sbj_num = [2,                 10,11,12,...
               13,   15,16,17,19,20,21,22,23,...
               24,25,26,27,28,29,30,31,   33];    
        
    S2_BehS4 =[59.60376984;       105.4432639; 84.72490972; 30.02036111;...
              -10.33652778;         17.02793301; -24.38947917; 4.021527778; 23.0390625; 107.1158373; 142.3165278; -8.552430556; 39.94444444;...
              -44.47464286; -6.431770833; 11.19090278; 51.04274306; 9.445563492; 79.09484524; -17.93059028; 18.60871528;           -65.21444444];
  
           
    elseif cov == 8 || cov == 9 || cov == 10
    sbj_num = [2,3,5,6,7,8,9,10,11,   ...
              13,   15,16,17,19,20,21,22,23,...
              24,25,26,27,28,29,30,31,   33];    
    
    
     S2_percN2 = [27.5; 50.68143082; 56.0; 46.3; 49.5; 50.6; 47.6; 47.1; 49.2;...
                39.2;     44.0; 52.9; 59.7; 45.8; 59.13201141; 53.9; 43.3; 47.3;...
                26.0; 49.3; 37.0; 47.13114929; 39.0; 46.2; 36.0; 48.5;     45.4];
    S2_percSWS = [23.1; 14.56558704; 20.1; 21.5; 19.2; 18.5; 23.6; 13.4; 18.6;...
                 16.3;    21.4; 15.6; 14.5; 21.2; 18.53526306; 16.3; 22.1;21.9;...
                13.9; 19.0; 20.9; 25.32786942; 24.4; 23.0; 15.0; 23.3;    22.9];
    S2_percREM = [9.6; 22.1; 16.4;19.5; 19.2; 18.7; 12.2; 18.2; 15.4;...
                12.3;     24.1; 12.2; 14.1; 18.5; 13.20072269; 9.8; 12.4; 15.7;...
                9.7; 21.8; 16.5; 18.11475372; 13.1; 18.9; 10.8; 17.5;    18.2];
    
    end    
    S2_sbj_num = numel(sbj_num);
    
elseif session == 3
    
    if cov == 0 || cov == 5 || cov == 6
    sbj_num = [2,3,          10,11,12,...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33];      
    
    S3_BehS2 = [26.8125; 17.46448413;       -7.923611111; -7.313095238; 23.375;...
                43.97480159; 13.73829365; 19.56406396; -9.993055556; -29.9375; -19.98730159; 89.18055556; 8.513888889;       -39.27777778;...
                -19.99305556; 48.47916667; -18.78472222; -35.34722222; -28.00694444; 40.58333333; 39.49305556; 57.39583333; 26.31944444; 9.569444444];

    S3_BehS3 =[8.622619048; -26.09920635;          6.090277778; 60.86805556; 40.2140873;...
               18.79861111; 6.784722222; -7.173611111; 16.36111111; 15.23611111; -13.5718254; 71; 25.18055556;            19.60416667;...
               -21.6875; 30.73611111; -27.25; -5.868055556; -3.833333333; 41.84722222; 27.91666667; 2.618055556; 62.59027778; -46.38888889];
  
    elseif cov == 7
     sbj_num = [2,          10,11,12,...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33];      
     S3_BehS4 =[59.60376984;           105.4432639; 84.72490972; 30.02036111;...
               -10.33652778; -5.346354167; 17.02793301; -24.38947917; 4.021527778; 23.0390625; 107.1158373; 142.3165278;        39.94444444;...
               -44.47464286; -6.431770833; 11.19090278; 51.04274306; 9.445563492; 79.09484524; -17.93059028; 18.60871528; 99.12590278; -65.21444444];   
         
    elseif cov == 8 || cov == 9 || cov == 10
    sbj_num = [2,3,          10,11,  ...
               13,14,15,16,17,19,20,21,   23,...
               24,25,26,27,28,29,30,31,32,33];      
   
    
     S3_percN2 = [27.5; 50.68143082;                                    47.1; 49.2;...
                39.2; 51.5; 44.0; 52.9; 59.7; 45.8; 59.13201141; 53.9;       47.3;...
                26.0; 49.3; 37.0; 47.13114929; 39.0; 46.2; 36.0; 48.5; 48.3; 45.4];
            
    S3_percSWS = [23.1; 14.56558704;                                  13.4; 18.6;...
                 16.3; 22.3; 21.4; 15.6; 14.5; 21.2; 18.53526306; 16.3;      21.9;...
                13.9; 19.0; 20.9; 25.32786942; 24.4; 23.0; 15.0; 23.3; 27.0; 22.9];
            
    S3_percREM = [9.6; 22.1;                                         18.2; 15.4;...
                12.3; 15.7; 24.1; 12.2; 14.1; 18.5; 13.20072269; 9.8;        15.7;...
                9.7; 21.8; 16.5; 18.11475372; 13.1; 18.9; 10.8; 17.5; 16.3; 18.2];
    
    
    end
    
    S3_sbj_num = numel(sbj_num);

    
elseif session == 12
    
    if cov == 0 || cov == 5
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,   15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,   33]; %-----> define subjects for session

    S1S2_BehS2 =[26.81;17.46;88.23;79.10;-9.68;7.88;-29.98;-7.92;-7.31;23.37;43.97;19.56;-9.99;-29.94;...
        -19.99;89.18;8.51;-30.04;-39.28;-19.99;48.48;-18.78;-35.35;-28.01;40.58;39.49;57.40;9.57];
    
    elseif cov == 6 
        sbj_num = [2,3,10,11,12,13,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,33]  ;
        S1S2_BehS3 = [8.62;-26.10;6.09;60.87;40.21;18.80;-7.17;16.36;15.24;-13.57;71.00;25.18;-53.01;19.60;-21.69;30.74;...
            -27.25;-5.87;-3.83;41.85;27.92;2.62;-46.39];
    
    elseif cov == 7
        sbj_num = [2,5,10,11,12,13,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,33] ;
        S1S2_BehS4 = [59.60;6.78;105.44;84.72;30.02;-10.34;17.03;-24.39;4.02;23.04;107.12;142.32;-8.55;39.94;-44.47;-6.43;...
            11.19;51.04;9.45;79.09;-17.93;18.61;-65.21];
        
    end
    S12_sbj_num = numel(sbj_num);
    
  elseif session == 23
    
    if cov == 0 || cov == 5 || cov == 6
    sbj_num = [2,3,          10,11,12,13,   15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,   33]; %-----> define subjects for session

    S2S3_BehS2 =[26.81;17.46;-7.92;-7.31;23.37;43.97;19.56;-9.99;-29.94;...
        -19.99;89.18;8.51;-39.28;-19.99;48.48;-18.78;-35.35;-28.01;40.58;39.49;57.40;9.57];
   
    S2S3_BehS3 = [8.62;-26.10;6.09;60.87;40.21;18.80;-7.17;16.36;15.24;-13.57;71.00;25.18;19.60;-21.69;30.74;...
            -27.25;-5.87;-3.83;41.85;27.92;2.62;-46.39];
   
    elseif cov == 7
        sbj_num = [2,         10,11,12,13,   15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,   33] ;
        S2S3_BehS4 = [59.60;105.44;84.72;30.02;-10.34;17.03;-24.39;4.02;23.04;107.12;142.32;39.94;-44.47;-6.43;...
            11.19;51.04;9.45;79.09;-17.93;18.61;-65.21];
        
    end
    S23_sbj_num = numel(sbj_num);

    
    elseif session == 13
    
    if cov == 0 || cov == 5 || cov == 6
    sbj_num = [2,3,          10,11,12,13,  14,  15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31, 32,  33]; %-----> define subjects for session

    S1S3_BehS2 =[26.81;17.46;-7.92;-7.31;23.37;43.97;13.74;19.56;-9.99;-29.94;...
        -19.99;89.18;8.51;-39.28;-19.99;48.48;-18.78;-35.35;-28.01;40.58;39.49;57.40;26.32;9.57];
   
    S1S3_BehS3 = [8.62;-26.10;6.09;60.87;40.21;18.80;6.78;-7.17;16.36;15.24;-13.57;71.00;25.18;19.60;-21.69;30.74;...
            -27.25;-5.87;-3.83;41.85;27.92;2.62;62.59;-46.39];
   
    elseif cov == 7
        sbj_num = [2,         10,11,12,13,  14, 15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,  32, 33] ;
        S1S3_BehS4 = [59.60;105.44;84.72;30.02;-10.34;-5.35;17.03;-24.39;4.02;23.04;107.12;142.32;39.94;-44.47;-6.43;...
            11.19;51.04;9.45;79.09;-17.93;18.61;99.13;-65.21];
        
    end
    S13_sbj_num = numel(sbj_num);

end

%dir_contrast = cell(1,numel(sbj_num));


for s = 1:numel(sbj_num) 
    p_nb = sbj_num(s);
    p_nb = mat2str(p_nb);
    if session == 1
    S1_dir_contrastCUC{s,1} = [CUC_S1 '/p' p_nb '_con_0009.nii,1'];
    elseif session == 2
    S2_dir_contrastCUC{s,1} = [CUC_S2 '/p' p_nb '_con_0009.nii,1'];
    elseif session == 3
    S3_dir_contrastCUC{s,1} = [CUC_S3 '/p' p_nb '_con_0009.nii,1'];
    elseif session == 12
    S12_dir_contrastCUC{s,1} = [S1S2 '/p' p_nb '_fMRI_S1S2.nii,1']; 
    elseif session == 23
    S23_dir_contrastCUC{s,1} = [S2S3 '/p' p_nb '_fMRI_S2S3.nii,1'];   
    elseif session == 13
    S13_dir_contrastCUC{s,1} = [S1S3 '/p' p_nb '_fMRI_S1S3.nii,1'];   
    end
end

%end

matlabbatch{1}.spm.stats.factorial_design.dir = {secondlv_dir};

if session_to_analyse == 1
     matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S1_dir_contrastCUC;
elseif session_to_analyse == 2
     matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S2_dir_contrastCUC;
elseif session_to_analyse == 3
     matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S3_dir_contrastCUC;
elseif session_to_analyse == 12
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S12_dir_contrastCUC;
elseif session_to_analyse == 23
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S23_dir_contrastCUC;
elseif session_to_analyse == 13
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S13_dir_contrastCUC;    
end

if cov == 0
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
elseif cov == 5 && session_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && session_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && session_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 8 && session_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2_percN2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'percN2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 9 && session_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2_percSWS;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'percSWS';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 10 && session_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2_percREM;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'percREM';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && session_to_analyse == 12
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && session_to_analyse == 12
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && session_to_analyse == 12
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && session_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S3_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && session_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S3_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && session_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S3_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 8 && session_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S3_percN2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'percN2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 9 && session_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S3_percSWS;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'percSWS';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 10 && session_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S3_percREM;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'percREM';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && session_to_analyse == 23
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && session_to_analyse == 23
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && session_to_analyse == 23
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && session_to_analyse == 13
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && session_to_analyse == 13
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && session_to_analyse == 13
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
end


matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch

% Estimate
secSPM_file = [secondlv_dir 'SPM.mat'];
matlabbatch{1}.spm.stats.fmri_est.spmmat = {secSPM_file};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

% Results% contrast

spm_jobman('run',matlabbatch);
clear matlabbatch