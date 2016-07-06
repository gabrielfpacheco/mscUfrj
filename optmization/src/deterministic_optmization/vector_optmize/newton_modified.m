function [res]=newton_modified(fun,x0,epsg,epsa,epsr,itMax,method,hg,hG)

n     = length(x0);
gamma = 2;
delta = 0.1;

x  = columnfy(x0);
it = 1;

fk = feval(fun,x);

switch method
    case 'Analytic'
        strfun = func4sym(fun,n);
        [gk_fun,Gk_fun]=hessiansym(strfun,x);
        gk = evaluate_subs(gk_fun,x,n);
        Gk = evaluate_subs(Gk_fun,x,n);
    case 'Numeric'
        gk = numerical_gradient(fun,x,hg)';
        Gk = numerical_hessian(fun,x,hG);
end

gamma_hessian = get_gamma(Gk);
Fk = Gk+gamma_hessian*eye(n);
dk = -Fk\gk';
res = [x' gk dk' fk];

while it < itMax
    
    % Passo ótimo na direção de descida - Busca Linear
    falpha = @(alpha) fun(x+alpha*dk);
    [a,b]  = framing(falpha,0,delta,gamma);
    [~,~,~,alphak] = brent(falpha,a,b,epsg,itMax);
    
    % Calculo do novo ponto
    x_new = x + alphak*dk;
    fk_new = feval(fun,x_new);

    switch method
         case 'Analytic'
            gk = evaluate_subs(gk_fun,x_new,n);
            Gk = evaluate_subs(Gk_fun,x_new,n);
         case 'Numeric'
            gk = numerical_gradient(fun,x_new,hg)';
            Gk = numerical_hessian(fun,x_new,hG);
    end       
    
    gamma_hessian = get_gamma(Gk);
    Fk = Gk+gamma_hessian*eye(n);
    dk = -Fk\gk';
    
    it = it+1;
    
    res(it,:) = [x_new' gk alphak*dk' fk_new];
    
    if abs(fk_new - fk) < epsa + epsr*abs(fk);
        break;
    end    
   
    if (norm(gk) < epsg)
        break;
    end
    
    x = x_new;
    fk = fk_new;   
end
end

function f = evaluate_subs(fun,x,n)

for j = 1:n
     xj = strcat('x',num2str(j));
     fun = subs(fun,xj,x(j));    
end

f = eval(fun);
end

function gamma_hessian=get_gamma(Gk)

lambda = eig(Gk);
min_lambda = min(lambda);

if min_lambda<0
    gamma_hessian = -min_lambda+1;
else
    gamma_hessian = 0;
end

end
