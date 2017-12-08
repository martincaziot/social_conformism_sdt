


%% social_conformism_sdt
% 
% Find effect of social influence from groups with different d-primes and
% criterions
% 
% This experiment requires the mathworks webcam plugin which can be
% installed with the package installer. Type "webcamlist" in the terminal
% to check whether the plugin is already installed.
%
% Prior to running this experiment on a new platform, please fill the
% following fields:
%   (1) The username line ~30 and appropriate os name and user type
%   (2) The folder path line ~49
%   (3) The monitor parameters in the _screen function (find monitor
%   numbers with Screen('Screens'), pixel size can be found by displaying a
%   square and measuring is size. E.g. copy paste following code for a 1000
%   pixels square, then fill size_in_cm/1000.
%   w = Screen('OpenWindow', 0, 0); Screen('FillRect', w, 255, [50,50,1050,1050]); Screen('Flip', w); while ~KbCheck; end; Screen('CloseAll');
%   (4) The keys mapping in the _keys function
%   (5) The audio parameters in the _audio function (find audio devices
%   with a = PsychPortAudio('GetDevices'), and find the DeviceIndex 
%   associated with the DeviceName that has a name like 'Built-in Output'
%
% Baptiste Caziot, February 2017


clearvars;
close all;


debug = 0;



%% detect platform
% baptiste/mac
os{1} = 'MACI64';   usertype{1} = 'USER';       username{1} = 'baptiste';
% os{2} = 'PCWIN64';  usertype{2} = 'username';   username{2} = 'whatever';
% os{3} = 'GLNXA64';  usertype{3} = 'USER';       username{3} = 'whatever';

platform = 0;
for pp=1:length(os)
    if strcmp(computer,os{pp}) && strcmp(getenv(usertype{pp}),username{pp})
        platform = pp;
        break
    end
end
if ~platform
    error('Unknown platform');
end

switch platform
    case 1
        cd('/Users/baptiste/Documents/MATLAB/social/social_conformism_sdt/social_conformism_sdt_v01');
    case 2
        cd('/Users/tobefilled/');
end



%% set up experiment
% query subject name
while 1
    subjectName = input('\nSubject Name? ', 's');
    if isempty(regexp(subjectName, '[/\*:?"<>|]', 'once'))
        break
    else
        fprintf('\nInvalid file name!');
    end
end
% query group number
while 1
    groupNum = input('\n\nGroup number (1-4)? ','s');
    if sum(str2double(groupNum)==(1:4))
        break
    end
end

% open PTB window
W = social_conformism_sdt_screen(platform,debug);

% set up keys
K = social_conformism_sdt_keys(platform);

% set up experimental design
E = social_conformism_sdt_setup(W,groupNum);

% open psychportaudio
A = social_conformism_sdt_audio(platform);

% create data text file
R = social_conformism_sdt_header(E,subjectName);



%% initialize experiment
ListenChar(2);
clc;

if strcmp(R.subjectName,'robot')
	 E.durPauseSec = 0;
elseif strcmp(R.subjectName,'train1')
    E.condList(:) = 3;
elseif strcmp(R.subjectName,'train2')
    E.condList(:) = 3;
elseif strcmp(R.subjectName,'train3')
    E.condList(:) = 2;
end

R.timeStart = GetSecs;

% display instructions
social_conformism_sdt_instructions(W,K,E);

% acquire screenshot
social_conformism_sdt_picture(W,K,E);



%% estimate threshold
block = 0;
if ~(strcmp(R.subjectName,'train2')||strcmp(R.subjectName,'train3'))
    for ss=1:E.stcTrials
        
        % display messages
        if ss>block*(E.stcTrials/E.stcBlocks)
            block = block+1;
            social_conformism_sdt_messages(W,K,E,1,block);
        end
        
        E.stcNn(E.stcList(ss)) = E.stcNn(E.stcList(ss))+1;
        
        % display trial
        if ~strcmp(R.subjectName,'robot')
            R = social_conformism_sdt_threshold(W,A,K,E,R,ss);
        else
            R.stcCorrectList(ss) = ( 0.5+0.45*normcdf(E.stcVal(E.stcNn(E.stcList(ss)),E.stcList(ss)),-10,2) > rand );
            R.stcRtList(ss) = 0;
        end
        
        E.stcResp(E.stcNn(E.stcList(ss)),E.stcList(ss)) = R.stcCorrectList(ss);
        if E.stcNn(E.stcList(ss))<E.stcLength
            intVec = E.stcVal(1:E.stcNn(E.stcList(ss)),E.stcList(ss));
            respVec = E.stcResp(1:E.stcNn(E.stcList(ss)),E.stcList(ss));
            E.stcVal(E.stcNn(E.stcList(ss))+1,E.stcList(ss)) = social_conformism_sdt_staircase(intVec,respVec,E.stcStep,E.stcThreshold);
        end
        
%         textLine = social_conformism_aftereffect_write(E,R,tt);
%         fprintf(textLine);
        
    end
    
    E.snrThreshold = social_conformism_sdt_fitpf(E);
    
else
    E.snrThreshold = -10; 
end
save(R.fileName);



%% measure baseline
block = 0;
if ~strcmp(R.subjectName,'train3')
    for tt=1:E.baselineTrials
        
        % display messages
        if tt>block*(E.baselineTrials/E.baselineBlocks)
            block = block+1;
            social_conformism_sdt_messages(W,K,E,2,block);
        end
        
        % display trial
        if ~strcmp(R.subjectName,'robot')
            R = social_conformism_sdt_trial(W,A,K,E,R,tt);
        else
            R.responseList(tt) = (normcdf(E.snrThreshold,-10,2)>rand);
            R.rtList(tt) = 0;
        end
        
        
    %     textLine = social_conformism_aftereffect_write(E,R,tt);
    %     fprintf(textLine);
        
    end
    
else
    
    E.baselineDprime = 1;
    E.baselineCriterion = 0;
    
end



%% main experiment
for tt=1:E.nGroupTrials
	
%     % display messages
%     if tt>block*(E.nTrials/E.nBlocks)
%         block = block+1;
%         social_conformism_sdt_messages(W,E,block);
%         fprintf('\n%s\n', R.header);
%     end
    
    
    % display trial
    if ~strcmp(R.subjectName,'robot')
        R = social_conformism_sdt_trial(W,A,K,E,R,tt);
    else
        R.responseList(tt) = sign(normcdf(E.distanceListCm(tt),0,2)-rand);
        R.rtList(tt) = 0;
    end
    
%     textLine = social_conformism_aftereffect_write(E,R,tt);
%     fprintf(textLine);
    
end



%% save and close
R.timeStop = GetSecs;

save(R.fileName);

fclose(R.fid);

social_conformism_sdt_messages(W,E,0);

fprintf('\n\nTime total: %i min', round((R.timeStop-R.timeStart)/60));

LoadIdentityClut(W.n);

Screen('CloseAll');

ListenChar(0);



