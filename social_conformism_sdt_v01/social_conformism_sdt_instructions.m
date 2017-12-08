

function social_conformism_sdt_instructions(W,K,E)


    % set text properties
    Screen('TextSize', W.n, E.textSize);
    Screen('TextStyle', W.n, E.textStyle);
    Screen('TextFont', W.n, E.textFont);
    Screen('TextColor', W.n, E.textColor);
    Screen('Preference', 'TextRenderer', 1);
    
    
    while KbCheck; end
    
    keyWasDown = 0;
    
    
    timeStart = GetSecs;
    vbl = timeStart;

    page = 1;
    maxpage = 4;

    imsize = 800;
    
    while 1

        % compute texts
        switch page

            case 1
                txtinstr = 'Bonjour, bienvenue dans cette expérience sur\nl''effet des groupes sur la perception visuelle.\nCette expérience consiste en 3 parties et\ndurera environ 45 minutes.';
                iminstr = '';

            case 2
                txtinstr = 'Votre tâche est de détecter la cible suivante:';
                iminstr = 'signal.png';

            case 3
                txtinstr = 'Lorsqu''elle est supeposée à du bruit suivant:';
                iminstr = 'noise.png';

            case 4
                txtinstr = 'Ressemblant au stimulus suivant:';
                iminstr = 'signalnoise.png';

            case 5
                txtinstr = 'Dans la première partie de l''expérience,\ndeux stimuli seront présenté successivement,\navec seulement 1 contenant la cible.\nVous devrais répondre si la cible était contenue dans le 1er ou le 2ème stimulus.';
                iminstr = '';

            case 6
                txtinstr = 'Dans la première partie de l''expérience,\ndeux stimuli seront présenté successivement,\navec seulement 1 contenant la cible.\nVous devrais répondre si la cible était contenue dans le 1er ou le 2ème stimulus.';
                iminstr = '';

            otherwise
                ListenChar(0);
                Screen('CloseAll');
                error('Unrecognized instructions');

        end

        txtnext = 'Appuyez sur la touche "s"    \npour passer à la page suivante    ';
        txtback = '    Appuyez sur la touche "p"\n    pour revenir à la page précédente';
        txtstart = 'Appuyez sur la touche "c"    \npour commencer    ';


        if ~isempty(iminstr)
            I = imread(sprintf('./stim/%s',iminstr));
        else
            I = 255*W.bg*ones([imsize,imsize,3]);
        end
        imtex = Screen('MakeTexture',W.n,I);


        % display texts
        blinkCol = [E.textColor,E.textColor,E.textColor,255*0.5*(1+sin((GetSecs-timeStart)*2*pi*E.textFreqHz))];

        Screen('FillRect', W.n, W.bg*255);
        if ~isempty(iminstr)
            Screen('DrawTexture', W.n, imtex, [], [W.center(1)-0.5*imsize,W.center(2)-0.5*imsize,W.center(1)+0.5*imsize,W.center(2)+0.5*imsize]);
        end
        DrawFormattedText(W.n, txtinstr, 'center', 100, E.textColor, [], [], [], 1.5);
        if ~(page==maxpage)
            DrawFormattedText(W.n, txtnext, 'right', 850, blinkCol, [], [], [], 1);
        else
            DrawFormattedText(W.n, txtstart, 'right', 850, blinkCol, [], [], [], 1);
        end
        if (page>1)
            DrawFormattedText(W.n, txtback, 'left', 850, E.textColor, [], [], [], 1);
        end
        vbl = Screen('Flip', W.n, vbl+0.75*W.ifi);
        
        Screen('Close',imtex);
        

        % check keys
        [keyIsDown,~,keyCode] = KbCheck;
        if keyIsDown

            if ~keyWasDown
                k = find(keyCode,1);
                switch k
                    case K.next
                        page = min(page+1,maxpage);
                    case K.back
                        page = max(page-1,1);
                    case K.start
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
            
end


