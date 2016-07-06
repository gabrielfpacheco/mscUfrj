function vColumn = columnfy( v )

dimV    = size(v);
vColumn = v;

if (min(dimV) > 1)
    error('This entry is not a vector!')
elseif (dimV(1) == 1)
    vColumn = v';    
end

