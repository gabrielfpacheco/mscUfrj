function [res]=newton_symb(fun,x0,epsg,epsa,epsr,itMax)

n= length(x0);

x = columnfy(x0);
strfun = func4sym(fun,n);
[gk_fun,Gk_fun]=hessiansym(strfun,x);
gk = evaluate_subs(gk_fun,x,n)';
Gk = evaluate_subs(Gk_fun,x,n);
dk = -Gk\gk;
res = [x' gk' dk' fun(x)];

e = strcat('Toler�ncia de N�mero de Itera��es Atingida: itMax = ',num2str(itMax));

it = 1;
while it < itMax
    
    xOld = x;
           
    gk = evaluate_subs(gk_fun,x,n)';
    if (norm(gk) < epsg)
        eg = norm(gk);
        e = strcat('Tolerancia do Gradiente Atingida: eg = ',num2str(eg));
        break
    end
    
    Gk = evaluate_subs(Gk_fun,x,n);
    dk = -Gk\gk;
    x  = xOld + dk;
    
    fk = fun(x);
    fk_Old = fun(xOld);
    
    it = it+1;   

    % Armazenando resultados
    res(it,:) = [x' gk' dk' fk];
    
    if abs(fk - fk_Old) < epsa + epsr*abs(fk_Old)
        ea = abs(fk - fk_Old);
        er = ea/abs(fk_Old);
        e = strcat('Tolerancia Relativa/Absoluta Atingida: ea = ',num2str(ea),' e er = ',num2str(er));
        break;
    end
        
end

disp(e)

end


function f = evaluate_subs(fun,x,n)

for j = 1:n
     xj = strcat('x',num2str(j));
     fun = subs(fun,xj,x(j));    
end

f = eval(fun);

end