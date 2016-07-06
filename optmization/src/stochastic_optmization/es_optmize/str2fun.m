function fun = str2fun(fun,strvar)

funStr = func2str(fun);

funStr = strrep(funStr,strcat('@(',strvar,')'),'');
funStr = strrep(funStr,strcat(strvar,'(1)'),strcat(strvar,'1'));
funStr = strrep(funStr,strcat(strvar,'(2)'),strcat(strvar,'2'));

funStr = strrep(funStr,'.*','*'); funStr = strrep(funStr,'*','.*');
funStr = strrep(funStr,'.^','^'); funStr = strrep(funStr,'^','.^'); 
funStr = strrep(funStr,'./','/'); funStr = strrep(funStr,'/','./');

if isempty(strfind(funStr,strcat(strvar,'1'))) || isempty(strcmp(funStr,strcat(strvar,'2')))
    funStr = regexprep([' ' funStr ' '],strcat('(?<=[^a-zA-Z])',strvar,'(?=[^a-zA-Z])'),strcat('[',strvar,'1',',',strvar,'2]'''));
end

funStr = strcat(strcat('@(',strvar,'1,',strvar,'2',')'),funStr);
fun    = eval(funStr);

end