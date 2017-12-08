

function social_conformism_sdt_messages(W,K,E,part,block)
    
    
    while KbCheck; end
    
    timeStart = GetSecs;
    vbl = timeStart;
    
    % display trial number
    taskinstr{1} = 'Lequel des 2 stimuli contient la cible?\nAppuyez sur la touche 1 pour le premier stimulus\n ou la touche 2 pour le deuxième stimulus.';
    taskinstr{2} = 'Le stimulus contient-il la cible?\nAppuyez sur "p" pour présent,\net "a" pour absent.';
    txtinstr = sprintf('Partie %i : block %i/%i\n%s',part,block,E.stcBlocks,taskinstr{part});

    while 1
        
        if ((GetSecs-timeStart)>E.durPauseSec)
            txtstart = 'Appuyez sur la touche "c" pour commencer';
            blinkCol = [E.textColor,E.textColor,E.textColor,255*0.5*(1+sin((GetSecs-timeStart)*2*pi*E.textFreqHz))];
        else
            currDelay = ceil(E.durPauseSec-(GetSecs-timeStart));
            txtstart = sprintf('%i', currDelay);
            blinkCol = [E.textColor,E.textColor,E.textColor,255];
        end
        
        Screen('FillRect', W.n, W.bg*255);
        DrawFormattedText(W.n, txtinstr, 'center', 'center', E.textColor, [], [], [], 1.5);
        DrawFormattedText(W.n, txtstart, 'center', 0.75*W.rect(4), blinkCol);
        vbl = Screen('Flip', W.n, vbl+0.75*W.ifi);
        
        [keyIsDown, ~, keyCode] = KbCheck;

        if keyIsDown

            k = find(keyCode,1);
            switch k
                
                case K.start
                    if ((GetSecs-timeStart)>E.durPauseSec)
                        break
                    end
                case K.quit
                    ListenChar(0);
                    LoadIdentityClut(W.n);
                    Screen('CloseAll')
                    error('Interupted by user')
            end
        end

    end
    
    Screen('FillRect', W.n, W.bg*255);
    Screen('Flip', W.n, vbl+0.75*W.ifi);
    
end


