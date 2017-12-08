

function R = social_conformism_sdt_header(E,subjectName)
    
    time = clock;   % [year,month,day,hour,minute,seconds]
    
    
    R.subjectName = subjectName;
    R.fileName = sprintf('%s/data/social_conformism_sdt_%s_%i-%i-%i_%i-%i-%i', cd, subjectName, time(3), time(2), time(1), time(4), time(5), round(time(6)));
    
    R.fid = fopen(sprintf('%s.dat',R.fileName),'w');
    
    
    R.responseList =  NaN(E.baselineTrials,1);
    R.rtList = NaN(E.baselineTrials,1);
    R.timeMat = NaN(E.baselineTrials,4);
    
    R.header = sprintf('%s\t','trial', 'cond', 'resp', 'rt');
    
end