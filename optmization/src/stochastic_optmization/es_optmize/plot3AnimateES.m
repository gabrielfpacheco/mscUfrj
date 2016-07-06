function plot3AnimateES (fun,res,xlim,ylim,strvar)

funStr = fun2str(fun,strvar);
itMax  = size(res,1);

ezsurf(funStr,[xlim ylim],70);
hold on; axis square;
zlabel(strcat('f(',strvar,')'));

cor = 'r';
for i=1:itMax
    
    x  = res(i,1); 
    y  = res(i,2);
    
    scatter3(x,y,res(i,end),'MarkerEdgeColor','k','MarkerFaceColor',cor);
    pause(0.5/itMax);
    cor = 'y';
    if i==itMax-1
        cor = 'g';
    end
    
    if i~=itMax
        arrow3([res(i,1),res(i,2),res(i,end)],[res(i+1,1),res(i+1,2),res(i+1,end)],'r--1',0.5,1);
    end
end
hold off;
