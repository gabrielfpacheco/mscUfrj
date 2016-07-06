function G = numerical_hessian(fun,x,h) 

n = length(x);
G = zeros(n);

deriv = @(xk,hk) (fun(xk+hk)-fun(xk-hk))/(2*h);

for i = 1:n
    hi = zeros(n,1); hi(i)  = h;
    for j = i:n
        hj = zeros(n,1); hj(j)  = h;
        xj = x + hj;
        
        G(i,j) = (deriv(xj+hi,hj)-deriv(xj-hi,hj))/(2*h);
        
        if i~=j
            G(i,j) = 2*G(i,j);
        end
    end
end

G = (G + G')/2;
