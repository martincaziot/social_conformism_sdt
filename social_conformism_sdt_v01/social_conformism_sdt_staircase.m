


function intNext = social_conformism_sdt_staircase(intVec,respVec,step,threshold)
    
%     nn = length(intVec);
% 
%     if ~respVec(nn)
%         int_next = intVec(nn) + step;
%     else
%         if (nn>1) && respVec(nn-1)
%             int_next = intVec(nn) - step;
%         else
%             int_next = intVec(nn);
%         end
%     end


    % This is a corrected version of Kesten's Accelerated Stochastic
    % Approximation (1958)
    
%     nn = length(intList);
%     intCurr = intList(end);
%     resCurr = resList(end);
%     stepSize = firstStep/max(threshold,1-threshold);
%     

    nn = length(intVec);
    intCurr = intVec(end);
    respCurr = respVec(end);
    stepSize = step/max(threshold,1-threshold);
    
    if nn>2
        reversals = sum(sign(respVec(3:end)-respVec(2:end-1))>0);
    else
        reversals = 0;
    end
    
    intNext = intCurr + (stepSize/(min(nn,2)+reversals))*(threshold-respCurr);

end

