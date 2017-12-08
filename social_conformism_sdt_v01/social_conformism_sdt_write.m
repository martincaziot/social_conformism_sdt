


function textLine = social_conformism_aftereffect_write(E,R,tt)



    textLine = sprintf('\n%i\t%i\t%2.1f\t%i\t%2.2f',...
        tt, E.satList(tt), R.responseList(tt), R.rtList(tt));
    

end