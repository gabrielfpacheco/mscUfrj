function [I,res]=fibonacci(fun,a,b,n)

k=n+1;
p=(1-sqrt(5))/(1+sqrt(5));
alpha=(2*(1-(p^k)))/((1+sqrt(5))*(1-(p^(k+1))));

res = zeros(n+1,4);

% figure;
% delta = (b-a)/100;
% t = a:delta:b;
% plot(t,fun(t)); hold on; grid on;
% plot(a,fun(a),'r+')
% plot(b,fun(b),'r+')

fa = feval(fun,a); %to plot
fb = feval(fun,b); %to plot

for i=1:n
x1=a; x4=b; Li=b-a;

x2=alpha*x1+(1-alpha)*x4; f2=feval(fun,x2);
x3=alpha*x4+(1-alpha)*x1; f3=feval(fun,x3);

f1 = feval(fun,x1); %to plot
f4 = feval(fun,x4); %to plot

res(i,:) = [a,b,f1,f4];

if f2<f3
    a=x1; b=x3;
else
    a=x2; b=x4; 
end
Lf=b-a;
alpha=(Li-Lf)/Lf;
end

fa = feval(fun,a); %to plot
fb = feval(fun,b); %to plot
res(end,:) = [a,b,fa,fb];

I=[res(end,3),res(end,4)];

% xmin = .5*(a+b);
% plot(xmin,fun(xmin),'ro')

end
