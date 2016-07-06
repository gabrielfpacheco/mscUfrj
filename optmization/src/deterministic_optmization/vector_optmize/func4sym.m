function strfun = func4sym(fun,n)

str = '@(';

strfun = func2str(fun);

for i=1:n
    xi = strcat('x',num2str(i));
    str_aux = strcat('x(',num2str(i),')');
    strfun = strrep(strfun,str_aux,xi);
    if i == 1
        str = strcat(str,xi);
    elseif i == n
        str = strcat(str,',',xi,')');
    else
        str = strcat(str,',',xi);
    end
end

strfun = strrep(strfun,'@(x)',str);
