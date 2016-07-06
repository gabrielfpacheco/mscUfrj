function [res,fres,Jmin,Xmin] = SA(fun,X0,N,K,T0,eps,type,success_rate)

Kv = [1:1:K];

switch type
    case 'SA'
        T = T0./log2(1+Kv);
    case 'FSA' %also change to couchy distribution
        T = T0./(Kv);
end

nvar = length(X0);

Xc = X0;
Jc = fun(Xc);

fres = zeros(N*K,1);
Xres = zeros(nvar,K);

counter = 1;
Jmin = Jc;
Xmin = Xc;

res = zeros(K,nvar+3);

for i=1:K
    
    success = 0;
        
    for n=1:N
    
        R = randn(1,nvar);
        Xhat = Xc + R*eps;
        Jhat = fun(Xhat);
        deltaJ = Jhat-Jc;
        
        if rand < exp(-deltaJ/T(i)) ;
            Xc = Xhat;
            Jc = Jhat;
            success = success + 1;
            
            if Jhat<Jmin
                Jmin = Jhat;
                Xmin = Xc;
            end
                
        end
        
         %       Xres(:,n,k) = Xc;
        fres(counter) = Jc;       
        counter = counter + 1;
        
        if success == N*success_rate
            break;
        end
        
    end
    
    res(i,:) = [Xc Jc T(i) counter] ;
    
end

fres(counter:end) = [];

end