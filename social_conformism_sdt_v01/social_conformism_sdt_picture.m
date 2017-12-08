

function social_conformism_sdt_picture(W,K,E)
    
    
    while KbCheck; end
    
    while 1
        [~,~,buttons] = GetMouse;
        if sum(buttons)==0
            break;
        end
    end
    keyWasDown = 0;
    wasClicked = 0;
    
    
    timeStart = GetSecs;
    vbl = timeStart;

    page = 1;
    maxpage = 4;

    imscale = 0.75;
    webrect = [1280,720];
    cursordiam = 200;
    cursorpos = 0.5*webrect;
    cursorwidth = 10;
    
    
    while 1
        
        % compute texts
        switch page
            case 1
                txtinstr = 'Vous allez maintenant prendre une photo.';
                iminstr = 255*W.bg*ones([webrect(2),webrect(1),3]);
                imtex = Screen('MakeTexture', W.n, iminstr);
            case 2
                txtinstr = 'Cliquez pour prendre une photo.';
                iminstr = snapshot(cam);
                SetMouse(W.center(1),W.center(2));
            case 3
                txtinstr = 'Utilisez la souris pour déplacer le contour,\n utilisez la roulette pour changer la taille du contour\n et cliquez pour valider.';
            case 4
                txtinstr = 'Etes-vous satisfait(e)?';
        end
        
        txtback = '    Cliquez droit pour annuler';
        txtstart = 'Appuyez sur la touche "v"    \npour valider    ';
        
        
        % get mouse position
        [mousex,mousey,buttons] = GetMouse;
        if (page<4)
            cursorpos(1) = min(max(mousex,W.center(1)-0.5*imscale*(webrect(1)-cursordiam)),W.center(1)+0.5*imscale*(webrect(1)-cursordiam));
            cursorpos(2) = min(max(mousey,W.center(2)-0.5*imscale*(webrect(2)-cursordiam)),W.center(2)+0.5*imscale*(webrect(2)-cursordiam));
            SetMouse(cursorpos(1),cursorpos(2));
            cursorrect = [cursorpos-imscale*cursordiam,cursorpos+imscale*cursordiam];
%             if (page>2)
%                 cursorpos(1) = cursorpos(1)*webrect(1)/W.rect(3);
%                 cursorpos(2) = cursorpos(2)*webrect(2)/W.rect(4);
%                 Screen('FrameOval', imtex, 0, [cursorpos-0.5*cursordiam,cursorpos+0.5*cursordiam], cursorwidth, cursorwidth);
%             end
        end
        if sum(buttons)
            if ~wasClicked
                if buttons(2)
                    page = 2;
                elseif buttons(1) && (page<maxpage)
                    page = page+1;
                end
            end
            wasClicked = 1;
        else
            wasClicked = 0;
        end
        
%         % get mouse wheel
%         deltaW = GetMouseWheel;
%         cursordiam = min(max(cursordiam+deltaW,0),webrect(2));
        
        
        % display texts
        blinkCol = [E.textColor,E.textColor,E.textColor,255*0.5*(1+sin((GetSecs-timeStart)*2*pi*E.textFreqHz))];
        
        Screen('FillRect', W.n, W.bg*255);
        DrawFormattedText(W.n, txtinstr, 'center', 50, E.textColor, [], [], [], 1.5);        
        Screen('DrawTexture', W.n, imtex, [], [W.center-0.5*imscale*webrect,W.center+0.5*imscale*webrect]);
        if (page>2)
            Screen('FrameOval', W.n, 0, cursorrect, cursorwidth, cursorwidth);
        end
        if (page==maxpage)
            DrawFormattedText(W.n, txtstart, 'right', 850, blinkCol, [], [], [], 1);
        end
        if (page>2)
            DrawFormattedText(W.n, txtback, 'left', 850, E.textColor, [], [], [], 1);
        end
        vbl = Screen('Flip', W.n, vbl+0.75*W.ifi);
        
        
        if (page==1)
            cam = webcam('FaceTime');
            page = 2;            
        end
        
        
        % generate webcam image
        if (page==2)
            Screen('Close', imtex);
            imtex = Screen('MakeTexture', W.n, iminstr);
%             imrect = Screen('Rect',imtex);
        end
        
        
        % check keys
        [keyIsDown,~,keyCode] = KbCheck;
        if keyIsDown
            
            if ~keyWasDown
                k = find(keyCode,1);
                switch k
                    case K.validate
                        if (page==maxpage)
                            break
                        end
                    case K.quit
                        ListenChar(0);
                        LoadIdentityClut(W.n);
                        Screen('CloseAll')
                        error('Interupted by user')
                end
            end
            
            keyWasDown = 1;
        else
            keyWasDown = 0;
        end
        
    end
    
    Screen('Close', imtex);
    
end


