

function R = social_conformism_sdt_threshold(W,A,K,E,R,ss)
    
    
    fixRect = [W.center-0.5*E.fixationSizePix,W.center+0.5*E.fixationSizePix];
    
    % display fixation
    Screen('FillRect', W.n, W.bg*255);
    Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
    vbl = Screen('Flip', W.n, 0);
    timeFixation = vbl;
    
    
    % generate window
    currSnr = E.stcVal(E.stcNn(E.stcList(ss)),E.stcList(ss));
    sigInt = E.stimNoiseStd*exp(currSnr*log(10)/10);
    
    xx = 2*pi*repmat(linspace(0,1,E.stimSizePix),E.stimSizePix,1).*E.stimSizeDeg.*E.stimCycDeg;
    grating = sigInt*sin(xx+2*pi*rand);
    
    
    noise1 = E.stimNoiseStd*randn(E.stimSizePix);
    noise2 = E.stimNoiseStd*randn(E.stimSizePix);
    
    noiseMat = repmat(0.5+0.5*noise1,[1,1,3]);
    noiseMat(:,:,4) = 1;
    
    signalMat(:,:,1:3) = repmat(0.5+0.5*(noise2+grating),[1,1,3]);
    signalMat(:,:,4) = 1;
    
    noiseTex = Screen('MakeTexture', W.n, noiseMat*255);
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
    
    
    %% display stimulus
    timeTest = NaN(2,1);
    timeBlankTest = NaN(2,1);
    
    for ii=1:2
        
        % display test stim
        Screen('FillRect', W.n, W.bg*255);
        if (E.stcOrder(ss)==ii)
            Screen('DrawTexture', W.n, signalTex, [], stimRect);
        else
            Screen('DrawTexture', W.n, noiseTex, [], stimRect);
        end
        Screen('DrawTexture', W.n, windowTex, [], stimRect);
        Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
        vbl = Screen('Flip', W.n, timeFixation + E.durFixSec + (ii-1)*(E.durStimSec+E.durGapSec) - 0.25*W.ifi);
        timeTest(ii) = vbl;
        
        % blank test
        Screen('FillRect', W.n, W.bg*255);
        Screen('FrameRect', W.n,  E.fixationColor, fixRect, E.fixationThicknessPix);
        vbl = Screen('Flip', W.n, timeFixation + E.durFixSec + E.durStimSec + (ii-1)*(E.durStimSec+E.durGapSec) - 0.25*W.ifi);
        timeBlankTest(ii) = vbl;
        
    end
    
    
    while KbCheck; end
    
    while 1
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            k = find(keyCode,1);
            switch k
                case K.first
                    R.stcRespList(ss) = 1;
                    break
                case K.second
                    R.stcRespList(ss) = 2;
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
    
    R.stcRtList(ss) = timeResponse-timeTest(2);
    R.stcTimeMat(ss,:) = [timeFixation,timeTest(1),timeBlankTest(1),timeTest(2),timeBlankTest(2),timeResponse];
    
    R.stcCorrectList(ss) = (E.stcOrder(ss)==R.stcRespList(ss));
    
    % play feedback
    if R.stcCorrectList(ss)
        PsychPortAudio('FillBuffer', A.p, A.soundBuffer1);
    else
        PsychPortAudio('FillBuffer', A.p, A.soundBuffer2);
    end
    PsychPortAudio('Start', A.p, 1, 0);

    
    Screen('Close', noiseTex);
    Screen('Close', signalTex);
    Screen('Close', windowTex);
    
end

