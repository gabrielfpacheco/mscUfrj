function [res] = newton_numeric(fun,x0,epsg,epsa,epsr,itMax,hg,hG)

n = length(x0);
x  = x0';
gk = numerical_gradient(fun,x,hg);
Gk = numerical_hessian(fun,x,hG);
dk = -Gk\gk;
res = [x' gk' dk' fun(x)];

e = strcat('Tolerância de Número de Iterações Atingida: itMax = ',num2str(itMax));

it = 1;
while it < itMax
    
    xOld = x;
       
    gk = numerical_gradient(fun,x,hg);
    Gk = numerical_hessian(fun,x,hG);
    dk = -Gk\gk;
    x  = xOld + dk;
    fk = fun(x);
    fk_Old = fun(xOld);
    
    it = it+1;
    
    % Armazenando resultados
    res(it,:) = [x' gk' dk' fk];
    
    if (norm(gk) < epsg)
        eg = norm(gk);
        e = strcat('Tolerância do Gradiente Atingida: eg = ',num2str(eg));
        break
    end
    
    if abs(fk - fk_Old) < epsa + epsr*abs(fk_Old);
        ea = abs(fk - fk_Old);
        er = ea/abs(fk_Old);
        e = strcat('Tolerância Relativa/Absoluta Atingida: ea = ',num2str(ea),' e er = ',num2str(er));
        break;
    end
        
end

disp(e)

end