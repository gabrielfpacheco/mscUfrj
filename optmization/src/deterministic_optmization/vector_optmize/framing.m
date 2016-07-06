function [a,b]=framing(fun,x0,delta,gamma)

x1=x0;
x2 = x1 + delta;
f1 = feval(fun,x1);
f2 = feval(fun,x2);

if not(f2<=f1)
    a=x1; b=x2;
    x1=b; x2=a;
    faux = f1;
    f1=f2; f2=faux;
    delta=-delta;
end

i=1;
while i<100000

x3 = x2+gamma*delta;
f3 = feval(fun,x3);

if f3>f2
    break;
else
    x1=x2; f1=f2;
    x2=x3; f2=f3;
end

i=i+1;

end

if x1<x3
    a=x1;b=x3;
else
    a=x3;b=x1;
end

end