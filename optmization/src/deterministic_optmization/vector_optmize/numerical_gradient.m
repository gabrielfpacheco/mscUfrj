function g = numerical_gradient (fun, x, h)

n = length(x); % Dimensao do problema
g = zeros(n,1);

for i=1:n
    hi    = zeros(n,1);
    hi(i) = h;
    g(i)  = (fun(x+hi)-fun(x-hi))/(2*h);    
end

end

