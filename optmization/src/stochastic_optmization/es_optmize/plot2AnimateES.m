function plot2AnimateES (fun, resultado, xlim, ylim,strvar)

titleStr = makeTitleStr(fun,strvar);
fun = str2fun(fun,strvar);
ev_pop = resultado.Dados{1}.population;

itMax  = size(ev_pop,3);

x = min(xlim):(max(xlim)-min(xlim))/100:max(xlim);
y = min(ylim):(max(ylim)-min(ylim))/100:max(ylim);

[X,Y] = meshgrid(x,y);
Z = 0*X;

for i=1:length(X)
    for j=1:length(Y)
        Z(i,j) = fun(X(i,j),Y(i,j));
    end
end

contour(X,Y,Z);
hold on; axis square;

xlabel('x_1')
ylabel('x_2')
title(titleStr)

cor = 'r';
for it=1:itMax
    
    x  = ev_pop(1,:,it);
    y  = ev_pop(2,:,it);
        
%     dx = res(i,5);
%     dy = res(i,6);
    %quiver(x,y,dx,dy,'r')
    
    scatter(x,y,'MarkerEdgeColor','k','MarkerFaceColor',cor)
    pause(0.5/itMax);
    cor = 'y';
    if it==itMax-1
        cor = 'g';
    end
end
