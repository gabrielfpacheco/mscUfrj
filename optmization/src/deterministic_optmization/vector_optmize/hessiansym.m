function [g,G]=hessiansym(fun,x)

n= length(x);

str='';
s1 = {' '};
for i=1:n
    str = strcat(str,'x',num2str(i),s1);
end
str = strcat('syms',s1,str);
eval(str{1})

for i=1:n
     xi = strcat('x',num2str(i));
     g(i) = diff(eval(fun),eval(xi));
end

syms G;

for i = 1:n
    for j = 1:n
        xj = strcat('x',num2str(j));
        G(i,j) =diff(g(i),eval(xj));
    end  
end