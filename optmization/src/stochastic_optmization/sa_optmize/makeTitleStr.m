function [ titleStr ] = makeTitleStr( fun,strvar )

titleStr = func2str(fun);
titleStr = strrep(titleStr,strcat('@(',strvar,')'),'');
titleStr = strrep(titleStr,strcat(strvar,'(1)'),strcat(strvar,'_1'));
titleStr = strrep(titleStr,strcat(strvar,'(2)'),strcat(strvar,'_2'));
titleStr = strrep(titleStr,'*',' ');

end

