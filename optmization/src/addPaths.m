%% Add project dependencies to the project path
clc;
addpath(genpath(pwd));
if isunix % UNIX OS
    addpath(genpath(strcat(pwd,'/deterministic_optmization')))
    addpath(genpath(strcat(pwd,'/stochastic_optmization')))
else % Windows OS
    addpath(genpath(strcat(pwd,'\deterministic_optmization')))
    addpath(genpath(strcat(pwd,'\stochastic_optmization')))
end

disp('-----------------------------------')
disp('All dependencies have been included')
disp('-----------------------------------')