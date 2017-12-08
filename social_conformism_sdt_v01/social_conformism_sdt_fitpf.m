


function snrThreshold = social_conformism_sdt_fitpf(E)

    pffun = @(p,x) 0.5+(0.5-normcdf(p(3)))*normcdf(x,p(1),p(2));
    pffit = @(p,x) -sum(log( x(:,2).*pffun(p,x(:,1)) + (1-x(:,2)).*(1-pffun(p,x(:,1))) ));
    
    
    vec = sortrows([E.stcVal(:),E.stcResp(:)],1);
    
    
    fitparam = fminsearch(pffit,[-10,5,norminv(0.01)],[],vec);
    snrThreshold = fitparam(1);
    
    
%     [nresp,bins] = hist(E.stcVal(:),linspace(-20,0,21));
%     [ncor,bins] = hist(E.stcVal(E.stcResp==1),linspace(-20,0,21));
%     close all
%     figure(1)
%     hold on
%     for bin=1:21
%         if (nresp(bin)>0)
%             plot(bins(bin),ncor(bin)./nresp(bin),'b.','MarkerSize',max(nresp(bin)*5,1))
%         end
%     end
%     plot(linspace(-20,0,101),pffun(fitparam,linspace(-20,0,101)),'g','LineWidth',4)
%     axis([-20,0,0.45,1.05])
%     
%     
%     nbstrp = 100;
%     bstrpmat = ceil(size(vec,1)*rand([size(vec,1),nbstrp]));
%     
%     bstrpparam = NaN(nbstrp,3);
%     for bb=1:nbstrp
%         bstrpparam(bb,:) = fminsearch(pffit,[-10,5,norminv(0.01)],[],vec(bstrpmat(:,bb),:));
% %         bstrpparam(bb,:) = fminsearch('social_conformism_sdt_fitfun',[-10,5],[],vec(bstrpmat(:,bb),:));
% %         inttemp = vec(bstrpmat(:,bb),1);
% %         resptemp = vec(bstrpmat(:,bb),2);
% %         [nresp,bins] = hist(inttemp(:),linspace(-20,0,21));
% %         [ncor,bins] = hist(inttemp(resptemp==1),linspace(-20,0,21));
% %         close all
% %         figure(1)
% %         hold on
% %         for bin=1:21
% %             if (nresp(bin)>0)
% %                 plot(bins(bin),ncor(bin)./nresp(bin),'b.','MarkerSize',max(nresp(bin)*5,1))
% %             end
% %         end
%         plot(linspace(-20,0,101),pffun(bstrpparam(bb,:),linspace(-20,0,101)),'r--','LineWidth',0.5)
% %         axis([-20,0,0.45,1.05])
%         drawnow;
%     end
%     
%     snrThreshold = median(bstrpparam(:,1));
    
%     plot(linspace(-20,0,101),pffun(fitparam,linspace(-20,0,101)),'r','LineWidth',4)
%     plot(linspace(-20,0,101),pffun(median(bstrpparam),linspace(-20,0,101)),'r','LineWidth',4)
    
end

