

function K = social_conformism_sdt_keys(platform)


    switch platform
        case 1
            K.left = KbName('LeftArrow');
            K.right = KbName('RightArrow');
            K.up = KbName('UpArrow');
            K.down = KbName('DownArrow');
            K.first = KbName('1');
            K.second = KbName('2');
            K.next = KbName('s');
            K.back = KbName('p');
            K.start = KbName('c');
            K.validate = KbName('v');
            K.quit = KbName('ESCAPE');
%         case 2
% %             for windows
%             K.left = KbName('Left');
%             K.right = KbName('Right');
%             K.up = KbName('Up');
%             K.down = KbName('Down');
%             K.quit = KbName('esc');
        otherwise
            error('Unknown key mapping');
            
    end


end