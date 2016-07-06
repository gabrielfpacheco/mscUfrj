function [res]=newton_modified_lm(fun,x0,epsg,epsa,epsr,itMax,method,hg,hG)

n     = length(x0);
h     = 1e-10;
gamma = 2;
delta = 0.1;
tau = 1e-3;

x  = columnfy(x0);
n = length(x0);
it = 1;
v = 2;

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

A = gk'*gk;
g = gk'*fk;
mu = tau*max(max(A,[],1),[],2);
Fk = Gk+mu*eye(n);
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
    rho = (fk-fk_new)/(0.5*(dk'*(mu*dk-g))); %%?
    
    if abs(fk_new - fk) < epsa + epsr*abs(fk);
        break;
    end    
    
    if rho>0  %%?
        x = x_new;
        fk = fk_new;
        
        switch method
            case 'Analytic'
                gk = evaluate_subs(gk_fun,x,n);
                Gk = evaluate_subs(Gk_fun,x,n);
            case 'Numeric'
                gk = numerical_gradient(fun,x,hg)';
                Gk = numerical_hessian(fun,x,hG);
        end
        
        g = gk'*fk;
        mu=mu*max(1/3,1-(2*rho-1)^3);
        v=2;
    else
        mu = mu*v;
        v = 2*v;
    end
    
    if (norm(gk) < epsg)
        break;
    end
        
    res(it,:) = [x_new' gk alpha*dk' fk];
    
    Fk = Gk+mu*eye(n);
    dk = -Fk\gk';
    
    it = it+1;
        
end

function f = evaluate_subs(fun,x,n)

for j = 1:n
     xj = strcat('x',num2str(j));
     fun = subs(fun,xj,x(j));    
end

f = eval(fun);