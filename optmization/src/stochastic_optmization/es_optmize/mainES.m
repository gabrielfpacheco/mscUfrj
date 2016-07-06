function [result] = mainES(x0,func,maxEvals,runs,mu,lambda,eps,alpha1,...
                           epsa,epsr,alpha2)

dim    = length(x0); %# de variaveis

M = 1e4; %Valor grande para tornar aptidao sempre positiva

Dados = cell(1,runs);
xMin    = zeros(dim,runs);
fMin    = zeros(1,runs);

for i=1:runs;
    [xMin(:,i),fMin(:,i),Dados{i}] = ES(dim,mu,lambda,eps,maxEvals,...
                                        alpha1,alpha2,x0,func,M,epsa,epsr);
    fprintf('%d percent complete.\n',(i/runs)*100);
end

result.Dados = Dados;
result.xMin = xMin;
result.fMin = fMin;
result.meanFmin = mean(fMin);
result.stdFmin  = std(fMin);

end

function [xMinimum,fMinimum,dados] = ES(dim,mu,lambda,eps,maxEvals,...
                                            alpha1,alpha2,x0,func,M,...
                                            epsa,epsr)
                                                                     
population = repmat(columnfy(x0),1,mu).*exp(randn(dim,mu)/sqrt(dim));      %inicializacao da populacao
sigma      = randn(dim,mu);                                                %inicializacao da estrategia

fit   = fitness(population,func,M);                                        %inicializacao da aptidao
evals = 1;

result = max(fit);                                                         %atualizacao do resultado (maior valor encontrado)

l = 1;
Population(:,:,l) = population;
FuncEval(:,l) = M - fit;
while evals < maxEvals
    parents                        = population;                           %selecao dos pais (geral)
    [children,childrensigma]       = recombination(parents,sigma,...
                                                   mu,lambda,dim);         %recombinacao (discreta para variaveis/intermediaria para os parametros da estrategia)
    [xmen,xmensigma,xmenfit,evals] = mutation(children,childrensigma,...
                                              eps,lambda,dim,evals,...
                                              alpha1,alpha2,func,M);       %mutacao nao correlacionada com diferentes passos de mutacao                                 
    [population,sigma,fit]         = survivors(xmen,xmensigma,xmenfit,mu); %selecao de sobreviventes (todos os filhos) / "comma" => (mu,lambda)
   
    result = max(result,max(fit));
    
    l = l + 1;
    Population(:,:,l) = population; 
    FuncEval(:,l) = M - fit;
    
    if abs(mean(FuncEval(:,l)) - mean(FuncEval(:,l-1))) < epsa + epsr*abs(mean(FuncEval(:,l-1)));
        break;
    end
    
end

dados.lifecycles = l-1;

[funcbest,index]  = min(FuncEval);

xbest = zeros(length(x0),length(index));
for k=1:length(index)
    xbest(:,k)  = Population(:,index(k),k);
end

dados.population = Population;
dados.funcEval = FuncEval;
dados.funcBest = funcbest;
dados.xBest = xbest;

fMinimum = funcbest(end);
xMinimum = xbest(:,end);

end

function [children,childrensigma]=recombination(parents,sigma,...
                                                mu,lambda,dim)
children        = zeros(dim,lambda);
childrensigma   = zeros(dim,lambda);

for i=1:lambda
    r1 = randi([1 mu]);
    p1 = parents(:,r1);
    s1 = sigma(:,r1);
    
    r2 = randi([1 mu]);
    while (r1==r2)                                                         %Para garantir que nao haja pais repetidos
        r2 = randi([1 mu]);
    end
    p2 = parents(:,r2);
    s2 = sigma(:,r2);
    
    p12 = [p1 p2];
    
    childrensigma(:,i) = (s1 + s2)/2;                                      %recombinacao intermediaria
    for j=1:dim
        children(j,i) = p12(j,randi([1 2]));                               %recombinacao discreta
    end
end
end

function [xmen,xmensigma,xmenfit,evals]=mutation(children,childrensigma,...
                                                 eps,lambda,dim,evals,...
                                                 alpha1,alpha2,func,M)

tau1 = alpha1*(1/(sqrt(2*dim)));
tau2 = alpha2*(1/(sqrt(2*sqrt(dim))));

xmen        = zeros(dim,lambda);
xmensigma   = zeros(dim,lambda);
xmenfit     = zeros(1,lambda);

for j=1:lambda
    randn1 = randn;
    randn2 = randn(dim,1);
    
    xchildrensigma = max(childrensigma(:,j)*exp(tau1*randn1)...
                     .*exp(tau2*randn2), eps*ones(dim,1));
    oldchildren    = children(:,j);
    xchildren      = oldchildren + xchildrensigma.*randn(dim,1);
    
    xfit  = fitness(xchildren,func,M);
    evals = evals + 1;
    
    xmen(:,j)      = xchildren;
    xmenfit(j)     = xfit;
    xmensigma(:,j) = xchildrensigma;
end
end

function [population,sigma,fit]=survivors(xmen,xmensigma,xmenfit,mu)
[~,i] = sort(xmenfit,'descend');
i = i(1,1:mu);
population = xmen(:,i);
sigma = xmensigma(:,i);
fit = xmenfit(:,i);
end

function J = fitness(x,func,M)
J = M - func(x);
end