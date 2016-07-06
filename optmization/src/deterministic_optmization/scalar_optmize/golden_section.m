function [I,res]=golden_section(fun,a,b,tol,itMax)

% ------------ Golden Section ------------
%    x1---------x2-----x3---------x4
%    a-----------------------------b
%                  Li
%    x1------x2-x3-----x4
%    a-----------------b
%             Lf
% -------------------------------------

x1=a; x4=b; %Li=b-a;
u=(sqrt(5)-1)/2;
x2=u*x1+(1-u)*x4;
x3=(1-u)*x1+u*x4;

% figure;
% delta = (b-a)/100;
% t = a:delta:b;
% plot(t,fun(t)); hold on; grid on;
% plot(a,fun(a),'r+')
% plot(b,fun(b),'r+')

f2=feval(fun,x2);
f3=feval(fun,x3);

f1 = feval(fun,x1); %to plot
f4 = feval(fun,x4); %to plot
res = [x1,x4,f1,f4];

%figure(1)
%x=[(res(1,1)-0.01):0.01:(res(1,2)+0.01)];         %to plot
x=[(x1-0.01):0.01:(x4+0.01)];         %to plot
%plot(x,feval(fun,x),'LineWidth',2); %to plot
%hold
%xlim([x1 x4]);                        %to plot
%xlabel('x');                        %to plot
%ylabel('f(x)');                     %to plot
%title('Golden Section''s Method');

i=1;
while(i<itMax)

if f2<f3
    a=x1; b=x3; Lf=b-a;
    if Lf<tol
        %I=[a,b];
        break;
    else
        x4=x3;
        x3=x2;
        f4=f3;
        f3=f2;       
        x2=u*a+(1-u)*b;
        f2=feval(fun,x2);        
    end
else
    a=x2; b=x4; Lf=b-a;
    if Lf<tol
        %I=[a,b];
        break;        
    else
        x1=x2;
        f1=f2;
        x2=x3;
        f2=f3;
        x3=(1-u)*a+u*b;
        f3=feval(fun,x3);         
    end
end

res = [res; [x1,x4,f1,f4]];        

i=i+1;

end

fa = feval(fun,a); %to plot
fb = feval(fun,b); %to plot
res = [res ;[a,b,fa,fb]];

I=[res(end,3),res(end,4)];

% xmin = .5*(a+b);
% plot(xmin,fun(xmin),'ro')

end