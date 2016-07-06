function plot3Animate_SA (fun,res,xlim,ylim,strvar,ax)

axes(ax);

funStr = fun2str(fun,strvar);
itMax  = size(res,1);

ezsurf(funStr,[xlim,ylim],30);
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
        P1 = [res(i,1),res(i,2),res(i,end)];
        P2 = [res(i+1,1),res(i+1,2),res(i+1,end)];
        if ~(P1==P2)
            arrow3(P1,P2,'r--1',0.5,1);
        end;        
       % arrow3([res(i,1),res(i,2),res(i,end)],[res(i+1,1),res(i+1,2),res(i+1,end)],'r--1',0.5,1);
    end
end
