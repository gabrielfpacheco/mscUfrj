function [res] = conjugate_gradient (fun,x0,epsg,epsa,epsr,itMax,method,hg)

% Passo para o calculo do gradiente
% hg = 1e-10;

% Para busca linear
gamma  = 2;
delta  = 0.1;

switch method
    case 'Polak-Rebiere'
        calc_beta = @(gkk,gk) (norm(gkk,2)-gkk'*gk)/norm(gk,2);
    case 'Fletcher-Reeves'
        calc_beta = @(gkk,gk) norm(gkk,2)/norm(gk,2);
end

xk  = columnfy(x0);
gk  = numerical_gradient(fun,xk,hg);
dk  = 0*gk; alphak=1;
res = [xk' gk' alphak*dk' fun(xk)];
it  = 1;
while it < itMax
    
    xOld = xk;
    dOld = dk;
    gOld = gk;
    
    % Direcao de descida maxima
    gk = numerical_gradient(fun, xk, hg);
    if (norm(gk) < epsg)
        if it>1
            res(it,:) = [xk' gk' alphak*dk' fun(xk)];
        end
        break
    end
    dk = -gk/norm(gk,2);

    beta = max(0, calc_beta(gk,gOld)); % Reset automatico
    dk   = dk + beta*dOld;
       
    % Passo otimo na direcao de descida - Busca Linear
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