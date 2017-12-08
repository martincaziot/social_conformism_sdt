

function R = social_conformism_sdt_trial(W,A,K,E,R,tt)
    
    [group{1},~,alpha{1}] = imread('~/Pictures/work/stimuli/social/dezecache_cropped.png');
    [group{2},~,alpha{2}] = imread('~/Pictures/work/stimuli/social/kosem_cropped.png');
    [group{3},~,alpha{3}] = imread('~/Pictures/work/stimuli/social/martin_cropped.png');
    [group{4},~,alpha{4}] = imread('~/Pictures/work/stimuli/social/ligneul_cropped.png');
    
    for gg=1:length(group)
        temp = repmat(rgb2gray(group{gg}),[1,1,3]);
        temp(:,:,4) = alpha{gg};
        groupTex{gg} = Screen('MakeTexture',W.n,temp);
        groupRect(gg,:) = Screen('Rect', groupTex{gg});
    end
    groupCenter = 0.5*(groupRect(:,3:4));
    groupRadius = min(groupCenter,[],2);
    imdist = 200;
    imsize = 100;
    groupScale = imsize./groupRadius;
    groupRect = repmat(W.center,length(group),2) + ...
        repmat([cos(((0:3)*pi/2)'),-sin(((0:3)*pi/2)')]*imdist,1,2) + ...
        repmat(groupScale,1,4).*(groupRect-repmat(groupCenter,1,2));
    cursorRect = repmat(W.center,length(group),2) + ...
        repmat([cos(((0:3)*pi/2)'),-sin(((0:3)*pi/2)')]*imdist,1,2) + ...
        repmat(imsize*[-1,-1,+1,+1],4,1)+E.fixationThicknessPix*repmat([-2,-2,+2,+2],4,1);
    
    fixRect = [W.center-0.5*E.fixationSizePix,W.center+0.5*E.fixationSizePix];
    
    % display fixation
    Screen('FillRect', W.n, W.bg*255);
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, 0);
    timeFixation = vbl;
    
    if strcmp(R.subjectName,'screenshot')
        I = Screen('GetImage', W.n, 2*[W.center-450,W.center+450]);
        imwrite(I,'color_fixation.png');
    end
    
    
    
    % generate window
    currSnr = E.snrThreshold;
    sigInt = E.stimNoiseStd*exp(currSnr*log(10)/10);
    
    xx = 2*pi*repmat(linspace(0,1,E.stimSizePix),E.stimSizePix,1).*E.stimSizeDeg.*E.stimCycDeg;
    grating = sigInt*sin(xx+2*pi*rand);
    
    
    noise = E.stimNoiseStd*randn(E.stimSizePix);
    
    signalMat(:,:,1:3) = repmat(0.5+0.5*(noise+grating),[1,1,3]);
    signalMat(:,:,4) = 1;
    
    signalTex = Screen('MakeTexture', W.n, signalMat*255);
    
    
    % compute window
    [xx1,yy1] = meshgrid(1:W.rect(3),1:W.rect(4));
    
    dd = sqrt((xx1-0.5*(W.rect(3)+1)).^2+(yy1-0.5*(W.rect(4)+1)).^2);
    
    window = normcdf(dd,0.5*E.stimSizePix*E.stimFadingMeanRat,E.stimSizePix*E.stimFadingStdRat);
    windowMat(:,:,1:3) = W.bg*ones([W.rect(4),W.rect(3),3]);
    windowMat(:,:,4) = window;
    windowTex = Screen('MakeTexture', W.n, windowMat*255);
    
    
    % compute gabors rect
    stimRect = Screen('Rect', windowTex);
    stimRect = [W.center,W.center]+stimRect-repmat(0.5*(stimRect(3:4)-stimRect(1:2)),1,2);
    
    
    % display fixation
    Screen('FillRect', W.n, W.bg*255);
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, vbl+E.durFixSec-E.durGapSec-0.5*W.ifi);
    
    
    %% display stimulus
    

    % display test stim
    Screen('FillRect', W.n, W.bg*255);
    Screen('DrawTexture', W.n, signalTex, [], stimRect);
    Screen('DrawTexture', W.n, windowTex, [], stimRect);
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, vbl+E.durGapSec-0.25*W.ifi);
    timeTest = vbl;

    if strcmp(R.subjectName,'screenshot')
        I = Screen('GetImage', W.n, 2*[W.center-450,W.center+450]);
        imwrite(I,'color_test.png');
    end

    % blank test
    Screen('FillRect', W.n, W.bg*255);
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, vbl+E.durStimSec-0.25*W.ifi);
    timeBlankTest = vbl;
	
    
    randWait = [E.durFixSec;7.5./max(10+randn(3,1),0)];
    cursorCol = repmat(E.fixationColor,4,1);
    respCol = [255,0,0 ; 0,255,0];
    for gg1=1:length(group)
        Screen('FillRect', W.n, W.bg*255);
        for gg2=1:length(group)
            Screen('DrawTexture', W.n, groupTex{gg2}, [], groupRect(gg2,:));
        end
        for gg3=1:gg1
            Screen('FrameOval', W.n,  cursorCol(gg3,:), cursorRect(gg3,:), 4*E.fixationThicknessPix);
        end
        cursorCol(gg1,:) = respCol(randi(2),:);
        Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
        vbl = Screen('Flip', W.n, vbl+randWait(gg1)-0.25*W.ifi);
    %     timeBlankTest = vbl;
    end
    
    
    while KbCheck; end
    
    while 1
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            k = find(keyCode,1);
            switch k
                case K.first
                    R.respList(tt) = 1;
                    break
                case K.second
                    R.respList(tt) = 2;
                    break
                case K.quit
                    ListenChar(0);
                 	LoadIdentityClut(W.n);
                    Screen('CloseAll')
                    fclose(R.fid);
                    error('Interupted by user')
            end
        end
    end
    timeResponse = GetSecs;
    
    
    cursorCol(4,:) = respCol(R.respList(tt),:);
    Screen('FillRect', W.n, W.bg*255);
    for gg=1:length(group)
        Screen('DrawTexture', W.n, groupTex{gg}, [], groupRect(gg,:));
    end
    for gg=1:length(group)
        Screen('FrameOval', W.n,  cursorCol(gg,:), cursorRect(gg,:), 4*E.fixationThicknessPix);
    end
    
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, vbl+E.durFixSec-0.25*W.ifi);
%     timeBlankTest = vbl;
    
    
    % blank test
    Screen('FillRect', W.n, W.bg*255);
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, vbl+E.durGapSec-0.25*W.ifi);
    timeBlankTest = vbl;
    
    
    
    
    R.rtList(tt) = timeResponse-timeTest;
    R.timeMat(tt,:) = [timeFixation,timeTest,timeBlankTest,timeResponse];
    
%     R.correctList(ss) = (E.stcOrder(ss)==R.stcRespList(ss));
    
    
%     if R.stcCorrectList(ss)
%         PsychPortAudio('FillBuffer', A.p, A.soundBuffer1);
%     else
%         PsychPortAudio('FillBuffer', A.p, A.soundBuffer2);
%     end
%     PsychPortAudio('Start', A.p, 1, 0);

    for gg=1:length(group)
        Screen('Close', groupTex{gg});
    end
    Screen('Close', signalTex);
    Screen('Close', windowTex);
    
    
    
end

