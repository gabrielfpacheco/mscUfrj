function [res] = gradient_descent(fun,x0,epsg,epsa,epsr,itMax,hg)

% Passo para o calculo do gradiente
% hg = 1e-10;

% Para busca linear
gamma = 2;
delta = 0.1;

xk  = columnfy(x0);
gk  = numerical_gradient(fun,xk,hg);
dk  = -gk/norm(gk,2); alphak = 1;
res = [xk' gk' alphak*dk' fun(xk)];
it  = 1;
while it < itMax
    
    xOld = xk;
    
    % Direcao de descida máxima
    gk = numerical_gradient(fun, xk, hg);
    if (norm(gk) < epsg)
        if it>1
            res(it,:) = [xk' gk' alphak*dk' fun(xk)];
        end
        break
    end
    dk = -gk/norm(gk,2);
        
    % Passo ótimo na direção de descida - Busca Linear
    falpha = @(alpha) fun(xk+alpha*dk);
    [a,b]  = framing(falpha,0,delta,gamma);
    [~,~,~,alphak] = brent(falpha,a,b,epsg,itMax);
    
    % Armazenando resultados
    res(it,:) = [xk' gk' alphak*dk' fun(xk)];
    
    % Calculo do novo ponto
    xk = xOld + alphak*dk;
    
    fk = fun(xk);
    if abs(fk - fun(xOld)) < epsa + epsr*abs(fun(xOld));
        break;
    end

    it = it + 1;
end
