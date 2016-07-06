function plotNAnimate1(res,strvar)

N = size(res,1);

plot(1:N,res(:,end),'Linew',2)
xlim([1 N])
xlabel('n_{iter}')
ylabel(strcat('f(',strvar,')'))
title('Objective function')
grid