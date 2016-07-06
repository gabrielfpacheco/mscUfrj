function [I,res,exp,xmin] = brent(f,a,b,tolerance,itMax)

rGold = (sqrt(5)-1)/2;
cGold = 1- rGold;
%itMax = 1e3;
zEps  = tolerance;
tol   = sqrt(eps);
delta = (b-a)/100;
exp = 0;

% Teste de enquadramento inicial
xmin = a;
for xi=a+delta:delta:b
    if ( f(a) >= f(xi) && f(xi) < f(b) )
        break;
    end
    
    if f(xi)<f(xmin)
        xmin = xi;
    end
    
    if (abs(xi-b) < delta/10)
        I=[];
        res = [a,b,f(a),f(b)];
        exp=1;
        return;
    end
end

v = xi;
w = v;
x = v;
e = 0;
d = 0;

fx = f(x);
fv = fx;
fw = fx;

res = [a b f(a) f(b)];

it = 1;
while it <= itMax
    
    xm = 0.5*(a+b);
    tol1 = tol*abs(x)+zEps;
    tol2 = 2*tol1;
    
    if (abs(x-xm) <= (tol2-0.5*(b-a)))
        break;
    end
    
    p = 0; q = 0; etemp = 0;
    
    if (abs(e) > tol1)
        r = (x-w)*(fx-fv);
        q = (x-v)*(fx-fw);
        p = (x-v)*q - (x-w)*r;
        q = 2*(q-r);
        if (q > 0)
            p = -p;
        end
        q = abs(q);
        etemp = e;
        e = d;
    end
        
    if (~(abs(p) >= 0.5*q*etemp || p <= q*(a-x) || p >= q*(b-x)))
        d = p/q;
        u = x+d;
        if ( (u-a) < tol2 || (b-u) < tol2 )
            d = tol1*sign(xm-x);
        end
    else
        if (x >= xm)
            e = a - x;
        else
            e = b - x;
        end
        d = cGold*e;
    end   
    
    if (abs(d) >= tol1)
        u = x + d;
    else
        u = x + tol1*sign(d);
    end
    
    fu = f(u);
    if ( fu <= fx )
        if ( u >= x )
            a = x;
        else
            b = x;
        end
        v  = w;
        fv = fw;
        w  = x;
        fw = fx;
        x  = u;
        fx = fu;
    else
        if ( u < x )
            a = u;
        else
            b = u;
        end
        if ( fu <= fw || w == x )
            v  = w;
            fv = fw;
            w  = u;
            fw = fu;
        elseif (fu <= fv || v == x || v == w)
            v = u;
            fv = fu;
        end
    end
    
    res = [res; [a b f(a) f(b)] ];
    
    it = it + 1;
end

I = [res(end,3),res(end,4)];

xmin = x;

end