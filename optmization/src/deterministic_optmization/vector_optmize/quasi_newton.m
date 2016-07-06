function [res] = quasi_newton(fun,x0,epsg,epsa,epsr,itMax,method,hg)

% Para busca linear
gamma = 2;
delta = 0.1;

n     = length(x0);
xknew = columnfy(x0);
gknew = numerical_gradient(fun,xknew,hg);
fknew = fun(xknew);
Hk    = eye(n);
dk    = -Hk*gknew;
res   = [xknew' gknew' dk' fknew];

switch method
    case 'DFP'
        calc_Hk  = @(H,g,d) H - (H*g*g'*H)/(g'*H*g) + (d*d')/(d'*g);
    case 'BFGS'
        calc_Hk = @(H,g,d) H - (d*g'*H + H*g*d')/(d'*g) + ... 
                   (1 + (g'*H*g)/(d'*g))*((d*d')/(d'*g));
end

it = 1;
while it<itMax
    
    xk = xknew;
    gk = gknew;
    fk = fknew;
    
    % Passo otimo na direcao de descida - Busca Linear
    falpha = @(alpha) fun(xk+alpha*dk);
    [a,b]  = framing(falpha,0,delta,gamma);
    [~,~,~,alphak] = brent(falpha,a,b,epsg,itMax);
    
    % Armazenando dados
    res(it,:) = [xk' gk' alphak*dk' fk];
        
    % Calculo do novo ponto
    xknew = xk + alphak*dk;
    gknew = numerical_gradient(fun,xknew,hg);
    
    if (norm(gknew) < epsg)
        break;
    end
    
    deltak = xknew - xk;
    gammak = gknew - gk;
    
    Hk = calc_Hk(Hk,gammak,deltak);   
    dk = -Hk*gknew;
    
    fknew = fun(xknew);
    if abs(fknew - fk) < epsa + epsr*abs(fk);
        break;
    end

    it = it + 1;
end
res(it+1,:) = [xknew' gknew' 0*dk' fun(xknew)];