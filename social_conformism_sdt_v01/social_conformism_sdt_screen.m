


function W = social_conformism_sdt_screen(platform,debug)

    % find parameters for computer
    switch platform
        case 1
            monitor = 0;
            pixSize = 23/1000;
            viewingDistCm = 57.3;
            stereoMode = 0;
            multiSamples = 8;
            fps = 60;
            Screen('Preference', 'SkipSyncTests', 1);
        case 2
            monitor = NaN;
            pixSize = NaN;
            viewingDistCm = NaN;
            stereoMode = NaN;
            multiSamples = NaN;
            fps = NaN;
    end
    
    % open small window if debug mode
    if ~debug
        winsize = [];
    else
        winsize = [0,0,100,100];
    end
    
    % load calibration file
    try
        load('social_conformism_sdt_calibration.mat')
        W.CLUT = CLUT;
        W.dkl2rgb = dkl2rgb;
        W.ldrgyv2rgb = ldrgyv2rgb;
    catch
        error('No calibration file found')
    end
    
    % open window
    [num,rect] = Screen('OpenWindow', monitor, 0, winsize, [], [], stereoMode, multiSamples);
    Screen('BlendFunction', num, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('LoadNormalizedGammaTable', num, CLUT);
    
    HideCursor;
    
    W.monitor = monitor;
    W.n = num;
    W.rect = rect;
    W.center = 0.5*(rect(3:4)-rect(1:2));
    if isnan(fps)
        W.fps = Screen('FrameRate', num);
    else
        W.fps = fps;
    end
    W.ifi = 1/W.fps;
    W.bg = 0.5;
    W.pixSize = pixSize;
    W.viewingDistCm = viewingDistCm;
    W.stereoMode = stereoMode;
    W.multisamples = multiSamples;

    
    Screen('FillRect', num, W.bg*255);
    Screen('Flip', num);
    
end

