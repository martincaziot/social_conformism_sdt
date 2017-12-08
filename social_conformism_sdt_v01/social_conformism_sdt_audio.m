

function A = social_conformism_sdt_audio(platform)
    
    
    %% set parameters
    soundDurSec = 0.2;
    soundFreq1 = 440;
    soundFreq2 = 330;
    soundFadeInSec = 0.05;
    soundFadeOutSec = 0.05;
    
    switch platform
        case 1
            deviceId = 1;
            sampleFreq = 44100;
            channels = 1;
        case 2
            deviceId = 1;
            sampleFreq = 44100;
            channels = 1;
        case 3
            deviceId = 2;
            sampleFreq = 44100;
            channels = 1;
        otherwise
            error('Unknown audio device');
    end
    
    
    %% generate sounds
    sampleTot = sampleFreq*soundDurSec;
    sampleIn = sampleFreq*soundFadeInSec;
    sampleOut = sampleFreq*soundFadeOutSec;
    samplePlat = sampleTot-sampleIn-sampleOut;
    
    sine1 = sin(linspace(0,1,sampleTot)*soundFreq1*soundDurSec*2*pi);
    sine2 = sin(linspace(0,1,sampleTot)*soundFreq2*soundDurSec*2*pi);
    
    rampIn = sin(linspace(0,1,sampleIn)*pi/2).^2;
    rampOut = cos(linspace(0,1,sampleIn)*pi/2).^2;
    rampTot = [rampIn,ones(1,samplePlat),rampOut];
    
    soundBuffer1 = rampTot.*sine1;
    soundBuffer2 = rampTot.*sine2;
    
    
    %% open PTA
    A.p = PsychPortAudio('Open', deviceId, 1, 0, sampleFreq, channels);

    A.sampleFreq = sampleFreq;
    A.channels = channels;
    A.soundBuffer1 = soundBuffer1;
    A.soundBuffer2 = soundBuffer2;

end


