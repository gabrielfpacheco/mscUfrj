function plot2AnimateES_scaled (fun, resultado,strvar,it)

titleStr = makeTitleStr(fun,strvar);
fun = str2fun(fun,strvar);

ev_pop = resultado.Dados{1}.population;

xsup = 1.5*max((max(abs(ev_pop(1,:,it)))));
xinf = -xsup;

ysup = 1.5*max((max(abs(ev_pop(2,:,it)))));
yinf = -ysup;

xlim = [xinf xsup];
ylim = [yinf ysup];

x = min(xlim):(max(xlim)-min(xlim))/100:max(xlim);
y = min(ylim):(max(ylim)-min(ylim))/100:max(ylim);

[X,Y] = meshgrid(x,y);
Z = 0*X;

for i=1:length(X)
    for j=1:length(Y)
        Z(i,j) = fun(X(i,j),Y(i,j));
    end
end

if it == 1
    cor = 'r';
elseif it == size(ev_pop,3)
    cor = 'g';
else
    cor = 'y';
end

contour(X,Y,Z);
hold on; axis square;

xlabel('x_1')
ylabel('x_2')
title(titleStr)

x  = ev_pop(1,:,it);
y  = ev_pop(2,:,it);

scatter(x,y,'MarkerEdgeColor','k','MarkerFaceColor',cor)
    
end
