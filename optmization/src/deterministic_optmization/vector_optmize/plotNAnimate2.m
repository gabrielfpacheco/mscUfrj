function plotNAnimate2(res,n,strvar)

N = size(res,1);

plot(1:N,sqrt(sum(res(:,n+1:2*n+1)'.^2)),'Linew',2)
xlim([1 N])
xlabel('n_{iter}')
ylabel(strcat('$|\nabla(',strvar,')|$'), 'Interpreter','latex')
title('Gradient''s norm')

grid