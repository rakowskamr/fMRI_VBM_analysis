%% Second level analysis for VBM 
% one-way ttests

clc
clear all
warning off
%spm fmri 

comparison_to_analyse = 3; % <--- choose session to analyse: 1 = S1S2, 2 = S2S3, 3 = S1S3 
cov = 10; % <---- choose covariates: 0 = none, 1 = Sex, 5 = BehS2, 6 = BehS3, 7 = BehS4; 8 = N2perc; 9 = N3perc; 10 = REMperc (note: beh covarites are with BH)
GMWM = 2; %1 = GM, 2 = WM
masking = 1; % 1 = 0.5TPM
multiplecov = 1; % 1 = cov of interest + sex, 0 = just one cov


if GMWM == 1
    GMWMname = 'GM';
elseif GMWM == 2
    GMWMname = 'WM';
end

if comparison_to_analyse == 1
    comparison = 'S1S2';
elseif    comparison_to_analyse == 2
    comparison = 'S2S3';
elseif comparison_to_analyse == 3
    comparison = 'S1S3';
end

if     cov == 0
    covariate = 'nocov';
elseif cov == 1
    covariate = 'Sex';
elseif cov == 5
    covariate = 'BehS2';   
elseif cov == 6
    covariate = 'BehS3'; 
elseif cov == 7
    covariate = 'BehS4';   
elseif cov == 8
    covariate = 'N2perc';
elseif cov == 9
    covariate = 'N3perc';  
elseif cov == 10
    covariate = 'REMperc';   
end

if multiplecov == 0
secondlv_dir = sprintf('/YourDirectory/VBM/SPMResults/OneWayTtest/%s/%s/%s/', GMWMname,comparison,covariate);
elseif multiplecov == 1
secondlv_dir = sprintf('/YourDirectory/VBM/SPMResults/OneWayTtest/%s/%s/SexAndOtherCov/%s/', GMWMname,comparison,covariate);
end    
    
data_dir = sprintf('/YourDirectory/VBM/GS_Files_subtracted/%s',GMWMname);
cd(data_dir)

S1S2_dir = [data_dir '/' GMWMname '_S1S2'];
S2S3_dir = [data_dir '/' GMWMname '_S2S3'];
S1S3_dir = [data_dir '/' GMWMname '_S1S3'];


if comparison_to_analyse == 1 %S1S2
    
    if cov == 0 || cov == 1 || cov == 5 %nocov, Sex, Beh2
    sbj_num = [2,3,5,6,7,8,9,10,11,12,...
              13,14,15,16,17,19,20,21,22,23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    
    S1S2_Sex = [0; 1; 0; 1; 1; 1; 0; 0; 1; 1;...
               1; 1; 0; 1; 0; 1; 1; 1; 0; 0;...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
           
    S1S2_BehS2 = [26.8125; 17.46448413; 88.22857143; 79.10416667; -9.680555556; 7.875; -29.97916667; -7.923611111; -7.313095238; 23.375;...
                  43.97480159; 13.73829365; 19.56406396; -9.993055556; -29.9375; -19.98730159; 89.18055556; 8.513888889; -30.04047619; -39.27777778;...
                  -19.99305556; 48.47916667; -18.78472222; -35.34722222; -28.00694444; 40.58333333; 39.49305556; 57.39583333; 26.31944444; 9.569444444];
    
    if cov == 5 && multiplecov == 1
    R = [];
    R(:,1) = S1S2_Sex;
    R(:,2) = S1S2_BehS2;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end
    
    elseif cov == 6 %BehS3
    sbj_num = [2,3,        10,11,12,...
              13,14,15,16,17,19,20,21,22,23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
          
    S1S2_BehS3 = [8.622619048; -26.09920635;                6.090277778; 60.86805556; 40.2140873;...
                  18.79861111; 6.784722222; -7.173611111; 16.36111111; 15.23611111; -13.5718254; 71; 25.18055556; -53.00538194; 19.60416667;...
                  -21.6875; 30.73611111; -27.25; -5.868055556; -3.833333333; 41.84722222; 27.91666667; 2.618055556; 62.59027778; -46.38888889];
     
              
    if cov == 6 && multiplecov == 1
    S1S2_Sex = [0; 1;               0; 1; 1;...
               1; 1; 0; 1; 0; 1; 1; 1; 0; 0;...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S2_Sex;
    R(:,2) = S1S2_BehS3;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end  
    
    elseif cov == 8 || cov == 9 || cov == 10 %N2, N3,REM
    %matching cov
    sbj_num = [2,3,5,6,7,8,9,10,11,  ...
               13,14,15,16,17,19,20,21,22,23,...
               24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session    
    
    S1S2_N2perc = [27.5; 50.68143082; 56.0; 46.3; 49.5; 50.6; 47.6; 47.1; 49.2; ...
                   39.2; 51.5; 44.0; 52.9; 59.7; 45.8; 59.13201141; 53.9; 43.3; 47.3;...
                   26.0; 49.3; 37.0; 47.13114929; 39.0; 46.2; 36.0; 48.5; 48.3; 45.4];
               
    S1S2_N3perc = [23.1; 14.56558704; 20.1; 21.5; 19.2; 18.5; 23.6; 13.4; 18.6;...
                   16.3; 22.3; 21.4; 15.6; 14.5; 21.2; 18.53526306; 16.3; 22.1; 21.9;...
                   13.9; 19.0; 20.9; 25.32786942; 24.4; 23.0; 15.0; 23.3; 27.0; 22.9];
             
    S1S2_REMperc = [9.6; 22.1; 16.4; 19.5; 19.2; 18.7; 12.2; 18.2; 15.4;...
                    12.3; 15.7; 24.1; 12.2; 14.1; 18.5; 13.20072269; 9.8; 12.4; 15.7;...
                    9.7; 21.8; 16.5; 18.11475372; 13.1; 18.9; 10.8; 17.5; 16.3; 18.2];

    if cov == 8 && multiplecov == 1
    S1S2_Sex = [0; 1; 0; 1; 1; 1; 0; 0; 1;  ...
               1; 1; 0; 1; 0; 1; 1; 1; 0; 0;...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];    
    R = [];
    R(:,1) = S1S2_Sex;
    R(:,2) = S1S2_N2perc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
    elseif cov == 9 && multiplecov == 1
    S1S2_Sex = [0; 1; 0; 1; 1; 1; 0; 0; 1;  ...
               1; 1; 0; 1; 0; 1; 1; 1; 0; 0;...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];    
    R = [];
    R(:,1) = S1S2_Sex;
    R(:,2) = S1S2_N3perc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')   
    
    elseif cov == 10 && multiplecov == 1
    S1S2_Sex = [0; 1; 0; 1; 1; 1; 0; 0; 1;  ...
               1; 1; 0; 1; 0; 1; 1; 1; 0; 0;...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];    
    R = [];
    R(:,1) = S1S2_Sex;
    R(:,2) = S1S2_REMperc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')    
    
    end  
    
                
    elseif cov == 7
    sbj_num = [2,        10,11,12,...
              13,14,15,16,17,19,20,21,22,23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    
    S1S2_BehS4 = [59.60376984;        105.4432639; 84.72490972; 30.02036111;...
                  -10.33652778; -5.346354167; 17.02793301; -24.38947917; 4.021527778; 23.0390625; 107.1158373; 142.3165278; -8.552430556; 39.94444444;...
                 -44.47464286; -6.431770833; 11.19090278; 51.04274306; 9.445563492; 79.09484524; -17.93059028; 18.60871528; 99.12590278; -65.21444444];
    
             
    if cov == 7 && multiplecov == 1
    S1S2_Sex = [0;                 0; 1; 1;...
               1; 1; 0; 1; 0; 1; 1; 1; 0; 0;...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S2_Sex;
    R(:,2) = S1S2_BehS4;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end  
    
    end
    S1S2_sbj_num = numel(sbj_num);

elseif comparison_to_analyse == 2 % S2S3
    
    if cov == 0 || cov == 1 || cov == 5 %nocov, Sex, BehS2
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];      
     
    S2S3_Sex = [0; 1;               0; 1; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    
    S2S3_BehS2 = [26.8125; 17.46448413;               -7.923611111; -7.313095238; 23.375;...
                  43.97480159; 13.73829365; 19.56406396; -9.993055556; -29.9375; -19.98730159; 89.18055556; 8.513888889;                  -39.27777778;...
                  -19.99305556; 48.47916667; -18.78472222; -35.34722222; -28.00694444; 40.58333333; 39.49305556; 57.39583333; 26.31944444; 9.569444444];
    
    if cov == 5 && multiplecov == 1
    R = [];
    R(:,1) = S2S3_Sex;
    R(:,2) = S2S3_BehS2;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end          
              
    elseif cov == 6 %BehS3
    sbj_num = [2,3,        10,11,12,...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
          
    S2S3_BehS3 = [8.622619048; -26.09920635;                6.090277778; 60.86805556; 40.2140873;...
                  18.79861111; 6.784722222; -7.173611111; 16.36111111; 15.23611111; -13.5718254; 71; 25.18055556;                  19.60416667;...
                  -21.6875; 30.73611111; -27.25; -5.868055556; -3.833333333; 41.84722222; 27.91666667; 2.618055556; 62.59027778; -46.38888889];
    
    if cov == 6 && multiplecov == 1
    S2S3_Sex = [0; 1;               0; 1; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S2S3_Sex;
    R(:,2) = S2S3_BehS3;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
     end  
    
    elseif cov == 8 || cov == 9 || cov == 10
    % matchin covariates
    sbj_num = [2,3,                10,11,   ...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33];    
    
    
     
    S2S3_N2perc = [27.5; 50.68143082;                     47.1; 49.2; ...
                   39.2; 51.5; 44.0; 52.9; 59.7; 45.8; 59.13201141; 53.9;      47.3;...
                   26.0; 49.3; 37.0; 47.13114929; 39.0; 46.2; 36.0; 48.5; 48.3; 45.4];
               
    S2S3_N3perc = [23.1; 14.56558704;                    13.4; 18.6;...
                   16.3; 22.3; 21.4; 15.6; 14.5; 21.2; 18.53526306; 16.3;      21.9;...
                   13.9; 19.0; 20.9; 25.32786942; 24.4; 23.0; 15.0; 23.3; 27.0; 22.9];
             
    S2S3_REMperc = [9.6; 22.1;                           18.2; 15.4;...
                    12.3; 15.7; 24.1; 12.2; 14.1; 18.5; 13.20072269; 9.8;      15.7;...
                    9.7; 21.8; 16.5; 18.11475372; 13.1; 18.9; 10.8; 17.5; 16.3; 18.2];

    if cov == 8 && multiplecov == 1
    S2S3_Sex = [0; 1;               0; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S2S3_Sex;
    R(:,2) = S2S3_N2perc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
    elseif cov == 9 && multiplecov == 1
    S2S3_Sex = [0; 1;               0; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S2S3_Sex;
    R(:,2) = S2S3_N3perc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
    elseif cov == 10 && multiplecov == 1
    S2S3_Sex = [0; 1;               0; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S2S3_Sex;
    R(:,2) = S2S3_REMperc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
    end  
                
     elseif cov == 7
    sbj_num = [2,        10,11,12,...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    
    S2S3_BehS4 = [59.60376984;        105.4432639; 84.72490972; 30.02036111;...
                  -10.33652778; -5.346354167; 17.02793301; -24.38947917; 4.021527778; 23.0390625; 107.1158373; 142.3165278;              39.94444444;...
                 -44.47464286; -6.431770833; 11.19090278; 51.04274306; 9.445563492; 79.09484524; -17.93059028; 18.60871528; 99.12590278; -65.21444444];
    
    if cov == 7 && multiplecov == 1
    S2S3_Sex = [0;                  0; 1; 1;...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S2S3_Sex;
    R(:,2) = S2S3_BehS4;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
    end  
    
    end    
    S2S3_sbj_num = numel(sbj_num);
    
elseif comparison_to_analyse == 3 %S1S3
    
    if cov == 0 || cov == 1 || cov == 5
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];      
     
    S1S3_Sex = [0; 1;               0; 1; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    
    S1S3_BehS2 = [26.8125; 17.46448413;               -7.923611111; -7.313095238; 23.375;...
                  43.97480159; 13.73829365; 19.56406396; -9.993055556; -29.9375; -19.98730159; 89.18055556; 8.513888889;                  -39.27777778;...
                  -19.99305556; 48.47916667; -18.78472222; -35.34722222; -28.00694444; 40.58333333; 39.49305556; 57.39583333; 26.31944444; 9.569444444];
    
    if cov == 5 && multiplecov == 1
    R = [];
    R(:,1) = S1S3_Sex;
    R(:,2) = S1S3_BehS2;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end
    
    
    elseif cov == 6 %BehS3
    sbj_num = [2,3,        10,11,12,...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
          
    S1S3_BehS3 = [8.622619048; -26.09920635;                6.090277778; 60.86805556; 40.2140873;...
                  18.79861111; 6.784722222; -7.173611111; 16.36111111; 15.23611111; -13.5718254; 71; 25.18055556;                  19.60416667;...
                  -21.6875; 30.73611111; -27.25; -5.868055556; -3.833333333; 41.84722222; 27.91666667; 2.618055556; 62.59027778; -46.38888889];
   
    
    if cov == 6 && multiplecov == 1
    S1S3_Sex = [0; 1;               0; 1; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S3_Sex;
    R(:,2) = S1S3_BehS3;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end         
              
    elseif cov == 8 || cov == 9 || cov == 10
    % matching covariates
    sbj_num = [2,3,          10,11,  ...
               13,14,15,16,17,19,20,21,   23,...
               24,25,26,27,28,29,30,31,32,33];      
   
    
     S1S3_N2perc = [27.5; 50.68143082;                     47.1; 49.2; ...
                   39.2; 51.5; 44.0; 52.9; 59.7; 45.8; 59.13201141; 53.9;      47.3;...
                   26.0; 49.3; 37.0; 47.13114929; 39.0; 46.2; 36.0; 48.5; 48.3; 45.4];
               
    S1S3_N3perc = [23.1; 14.56558704;                    13.4; 18.6;...
                   16.3; 22.3; 21.4; 15.6; 14.5; 21.2; 18.53526306; 16.3;      21.9;...
                   13.9; 19.0; 20.9; 25.32786942; 24.4; 23.0; 15.0; 23.3; 27.0; 22.9];
             
    S1S3_REMperc = [9.6; 22.1;                           18.2; 15.4;...
                    12.3; 15.7; 24.1; 12.2; 14.1; 18.5; 13.20072269; 9.8;      15.7;...
                    9.7; 21.8; 16.5; 18.11475372; 13.1; 18.9; 10.8; 17.5; 16.3; 18.2];
         
     if cov == 8 && multiplecov == 1
    S1S3_Sex = [0; 1;               0; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S3_Sex;
    R(:,2) = S1S3_N2perc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
     elseif cov == 9 && multiplecov == 1
    S1S3_Sex = [0; 1;               0; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S3_Sex;
    R(:,2) = S1S3_N3perc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
     elseif cov == 10 && multiplecov == 1
    S1S3_Sex = [0; 1;               0; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S3_Sex;
    R(:,2) = S1S3_REMperc;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    
     end 
    
     
     elseif cov == 7
    sbj_num = [2,        10,11,12,...
              13,14,15,16,17,19,20,21,   23,...
              24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    
    S1S3_BehS4 = [59.60376984;        105.4432639; 84.72490972; 30.02036111;...
                  -10.33652778; -5.346354167; 17.02793301; -24.38947917; 4.021527778; 23.0390625; 107.1158373; 142.3165278;              39.94444444;...
                 -44.47464286; -6.431770833; 11.19090278; 51.04274306; 9.445563492; 79.09484524; -17.93059028; 18.60871528; 99.12590278; -65.21444444];
    
    if cov == 7 && multiplecov == 1
    S1S3_Sex = [0;                0; 1; 1;   ...
               1; 1; 0; 1; 0; 1; 1; 1;    0; ...
               0; 1; 0; 0; 0; 1; 0; 1; 1; 0];  
    R = [];
    R(:,1) = S1S3_Sex;
    R(:,2) = S1S3_BehS4;
    filesave = sprintf('R.mat');
    filesave = fullfile(secondlv_dir,filesave);
    save(filesave,'R')
    end 
    
    end
    
    S1S3_sbj_num = numel(sbj_num);
end
%dir_contrast = cell(1,numel(sbj_num));


for s = 1:numel(sbj_num) 
    p_nb = sbj_num(s);
    p_nb = mat2str(p_nb);
    if comparison_to_analyse == 1
    S1S2_dir_images{s,1} = [S1S2_dir '/p' p_nb '_' GMWMname '_S1S2.nii,1'];
    elseif comparison_to_analyse == 2
    S2S3_dir_images{s,1} = [S2S3_dir '/p' p_nb '_' GMWMname '_S2S3.nii,1'];
    elseif comparison_to_analyse == 3
    S1S3_dir_images{s,1} = [S1S3_dir '/p' p_nb '_' GMWMname '_S1S3.nii,1'];
    end
end


matlabbatch{1}.spm.stats.factorial_design.dir = {secondlv_dir};

if comparison_to_analyse == 1
     matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S1S2_dir_images;
elseif comparison_to_analyse == 2
     matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S2S3_dir_images;
elseif comparison_to_analyse == 3
     matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = S1S3_dir_images;
end

if multiplecov == 0
if cov == 0
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
elseif cov == 1 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_Sex;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'Sex';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 8 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_N2perc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'N2perc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 9 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_N3perc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'N3perc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 10 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_REMperc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'REMperc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && comparison_to_analyse == 1
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S2_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;



elseif cov == 1 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_Sex;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'Sex';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 8 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_N2perc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'N2perc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 9 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_N3perc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'N3perc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 10 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_REMperc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'REMperc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && comparison_to_analyse == 2
matlabbatch{1}.spm.stats.factorial_design.cov.c = S2S3_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 1 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_Sex;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'Sex';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 8 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_N2perc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'N2perc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 9 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S132_N3perc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'N3perc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 10 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_REMperc;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'REMperc';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

elseif cov == 5 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_BehS2;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS2';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 6 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_BehS3;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS3';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
elseif cov == 7 && comparison_to_analyse == 3
matlabbatch{1}.spm.stats.factorial_design.cov.c = S1S3_BehS4;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'BehS4';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
end
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
end

if multiplecov == 1
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});

% You  will  first need to create a *.mat file containing a matrix R or a *.txt file containing the covariates. 
% Each column of R will contain a different  covariate.  
% Unless  the  covariates  names  are  given  in  a cell array called 'names' in the MAT-file 
% containing variable R, the covariates will be named R1, R2, R3, ..etc.

covFile = [secondlv_dir, 'R.mat'];      

matlabbatch{1}.spm.stats.factorial_design.multi_cov.files = {covFile};
end

matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;

if masking == 0
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
elseif masking == 1 && GMWM == 1
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/YourDirectory/VBM/VBM_TPM_0.5thresholded_masks/GM_TPMmask0.5.nii,1'};
elseif  masking == 1 && GMWM == 2
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/YourDirectory/VBM/VBM_TPM_0.5thresholded_masks/WM_TPMmask0.5.nii,1'};

end

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