% Summarise realignment parameters 
% (time series of translations and rotations)

% This text file has six columns of numbers, and the same number of rows 
% as there were scans in the run; the columns contain respectively 
% the x y z translations, and x y z rotations

clc
clear all
warning off

%% Identify sessions
sessions = [1,2,3];                    % -----> define session (1, 2 or 3)

for session = 1:numel(sessions)
if session == 1
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    S1_sbj_num = numel(sbj_num);
elseif session == 2
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,   15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,   33];    
    S2_sbj_num = numel(sbj_num);
elseif session == 3
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];      
    S3_sbj_num = numel(sbj_num);
end

%Participants excluded:
% all sessions: p1 (didnt hear sounds), p4 (withdrew)
% S1: none
% S2: none
% S3: p5,p6,p7,p8,p9 (lockdown), p22 (online)
% Notes: % S2: p24 (mprage twice)

%% Identify subject

for s = 1:numel(sbj_num) % participants
clear matlabbatch 
tic
%% Find files
dir_data = '/home/c1813013/Desktop/data/';
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

% Find fmri files
s_folder = dir('*SRTT*');
s_folder = s_folder(1).name;
    
dir_sfolder = [dir_session s_folder '/'];
cd(dir_sfolder)
    
rp_name = dir('rp*.txt');
rp_name = rp_name(1).name;
 
rp_file = [dir_sfolder rp_name];

%fprintf('Running P%d, S%i \n',sbj_num(s),session)

rp = load(rp_file);

maximum = max(rp);
average = mean(rp);
minimum = min(rp);

if sum(average < -3) >= 1
    fprintf('**** Av <-3 mm/deg movement for P%d, S%i **** \n',sbj_num(s),session)
end

if sum(average > 3) >= 1
    fprintf('**** Av >3 mm/deg movement for P%d, S%i **** \n',sbj_num(s),session)
end

if session == 1
  MaxMov_S1(s,:) = maximum;
  MinMov_S1(s,:) = minimum;
  AvMov_S1(s,:) = average;
elseif session == 2
  MaxMov_S2(s,:) = maximum;
  AvMov_S2(s,:) = average;
  MinMov_S2(s,:) = minimum;
elseif session == 3
  MaxMov_S3(s,:) = maximum;
  AvMov_S3(s,:) = average;
  MinMov_S3(s,:) = minimum;
end

end
end

results_folder = '/YourDirectory/MovementParameters/';

ch_saveFile= sprintf('MovementParameters');       
ch_saveFile = fullfile(results_folder,ch_saveFile);
save(ch_saveFile,'MinMov_S2','MinMov_S2','MinMov_S3','MaxMov_S1','MaxMov_S2','MaxMov_S3','AvMov_S1','AvMov_S2','AvMov_S3');


