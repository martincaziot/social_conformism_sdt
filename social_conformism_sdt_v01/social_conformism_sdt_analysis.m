

clear all;
close all;
clc;



cd('/Users/baptiste/Documents/MATLAB/multisensory/multisensory_looming/multisensory_looming_combination_v03/');


fileList = {
% % % %     'multisensory_looming_combination_baptiste_2-3-2016_22-19-4'
% % % %     'multisensory_looming_combination_test_7-3-2016_18-2-21'
%     'multisensory_looming_combination_test_7-3-2016_20-23-28'
%     'multisensory_looming_combination_test_7-3-2016_20-47-30'
%     'multisensory_looming_combination_test_8-3-2016_17-3-1'
    'multisensory_looming_combination_baptisteC_10-3-2016_14-29-16'
};

nSub = length(fileList);

colorVal = [0,0,1;0,1,0;1,0,0];


fitpf = @(param,data) -sum(log( (data(:,2).*normcdf(data(:,1),param(1),param(2)))+((1-data(:,2)).*(1-normcdf(data(:,1),param(1),param(2)))) ));

for su=1:nSub
    
    load([cd '/data/' fileList{su}]);
    
    for co=1:3
        
        filter = (E.condList==co);
        vec = sortrows([E.distanceListCm(filter),R.responseList(filter)==+1],1);
        
        fitval(co,:,su) = fminsearch(fitpf,[0,1],[],vec);
        
        nbins = 5;
        
        figure(1)
        hold on
        plot(mean(reshape(vec(:,1),size(vec,1)/nbins,nbins)),mean(reshape(vec(:,2)==1,size(vec,1)/nbins,nbins)),'o','Color',colorVal(co,:));
        
    end
    
    pred(su) = sqrt(prod(fitval(1:2,2,su).^2)./sum(fitval(1:2,2,su).^2));
    
    range = 10;
    
    figure(1)
    hold on
    for co=1:3
        plot(linspace(-range,+range,100),normcdf(linspace(-range,+range,100),fitval(co,1,su),fitval(co,2,su)),'Color',colorVal(co,:));
    end
    legend({'Visual','Auditory','Both'})
    xlabel('Distance (cm)')
    ylabel('Ratio "right" answers')
    
    figure(2)
    subplot(1,2,1)
    hold on
    for co=1:3
        plot(su+(co-2)*0.1,fitval(co,1,su),'o', 'Color',colorVal(co,:));
    end
    axis([0,nSub+1,-1,+1])
    xlabel('Subject')
    ylabel('Bias (deg)')
    
    subplot(1,2,2)
    hold on
    for co=1:3
        plot(su+(co-2)*0.1,fitval(co,2,su),'o', 'Color',colorVal(co,:));
    end
    plot([su-0.5,su+0.5],[1,1]*pred(su),'k--');
    axis([0,nSub+1,0,10])
    legend({'Visual','Auditory','Both','Optimal'})
    xlabel('Subject')
    ylabel('Std (deg)')
    
end


figure(2)
subplot(1,2,1)
for co=1:3
    plot([0.5,nSub+0.5],mean(fitval(co,1,:),3)*[1,1],'Color',colorVal(co,:));
    plot(0.5*(nSub+1)*[1,1],mean(fitval(co,1,:),3)+std(fitval(co,1,:),[],3)*[+1,-1]./sqrt(nSub),'Color',colorVal(co,:));
end
subplot(1,2,2)
for co=1:3
    plot([0.5,nSub+0.5],mean(fitval(co,2,:),3)*[1,1],'Color',colorVal(co,:));
    plot(0.5*(nSub+1)*[1,1],mean(fitval(co,2,:),3)+std(fitval(co,2,:),[],3)*[+1,-1]./sqrt(nSub),'Color',colorVal(co,:));
end


figure(3)
hold on
plot(pred,squeeze(fitval(co,2,:)),'o')
plot([0,5],[0,5],'k--');
axis([0,5,0,5])
xlabel('Predicted')
ylabel('Observed')





