function plot2Animate (fun, res, xlim, ylim, strvar)

titleStr = makeTitleStr(fun,strvar);
fun = str2fun(fun,strvar);

itMax  = size(res,1);

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

xlabel(strcat(strvar,'_1'))
ylabel(strcat(strvar,'_2'))
title(titleStr)

cor = 'r';
for i=1:itMax
    
    x  = res(i,1); 
    y  = res(i,2);
        
%    dx = res(i,5);
%    dy = res(i,6);
%    quiver(x,y,dx,dy,'r')
    
    scatter(x,y,'MarkerEdgeColor','k','MarkerFaceColor',cor)
    pause(0.5/itMax);
    cor = 'y';
    if i==itMax-1
        cor = 'g';
    end
end
