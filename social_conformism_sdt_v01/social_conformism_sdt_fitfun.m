

function cost = social_conformism_sdt_fitfun(p,x)

    pffun = @(p,x) 0.5+0.5*normcdf(x,p(1),p(2));
%     pffit = @(p,x) sum(log( x(:,2).*pffun(p,x(:,1)) + (1-x(:,2)).*(1-pffun(p,x(:,1))) ));
    
    
    cost = -sum(log( x(:,2).*pffun(p,x(:,1)) + (1-x(:,2)).*(1-pffun(p,x(:,1))) ));

    
    inttemp = x(:,1);
    resptemp = x(:,2);
    [nresp,bins] = hist(inttemp(:),linspace(-20,0,21));
    [ncor,bins] = hist(inttemp(resptemp==1),linspace(-20,0,21));
%     close all
    figure(1)
    hold on
    for bin=1:21
        if (nresp(bin)>0)
            plot(bins(bin),ncor(bin)./nresp(bin),'b.','MarkerSize',max(nresp(bin)*5,1))
        end
    end
    plot(linspace(-20,0,101),pffun(p,linspace(-20,0,101)),'r','LineWidth',4)
    axis([-20,0,0.45,1.05])
    drawnow;

end

