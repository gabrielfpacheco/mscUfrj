function []=SA_plot1(K,fres,T_cut)

    f = figure(1);clf;

    hax = axes;
    
    plot(fres);
    xlim([0 size(fres,1)]);
    title('Objective Function Decreasing With Temperature');
    xlabel('iter');
    ylabel('f(x)');
    hold on; 

    for i=1:K 
        SP=T_cut(i); %your point goes here 
        line([SP SP],get(hax,'YLim'),'Color',[1 0 0]);
    end
    
    hold off;
end