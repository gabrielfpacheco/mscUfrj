%% Remove project dependencies when closing project 
rmpath(genpath(pwd));
if isunix % UNIX OS
    rmpath(genpath(strcat(pwd,'/deterministic_optmization')))
    rmpath(genpath(strcat(pwd,'/stochastic_optmization')))
else % Windows OS
    rmpath(genpath(strcat(pwd,'\deterministic_optmization')))
    rmpath(genpath(strcat(pwd,'\stochastic_optmization')))
end

disp('-----------------------------------')
disp('All dependencies have been removed!')
disp('-----------------------------------')