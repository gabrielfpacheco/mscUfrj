function [fun] = str2funcES(strfun,strvar,dim)
%STR2FUNCES 
%   Parses string function to handle function for proper usage on the
%   algorithm.

for i=1:dim
    strfun = strrep(strfun,strcat(strvar,'(',num2str(i),')'),strcat(strvar,'(',num2str(i),',:)'));
end
strfun = strrep(strfun,'.*','*'); strfun = strrep(strfun,'*','.*');
strfun = strrep(strfun,'.^','^'); strfun = strrep(strfun,'^','.^'); 
strfun = strrep(strfun,'./','/'); strfun = strrep(strfun,'/','./');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);

end

