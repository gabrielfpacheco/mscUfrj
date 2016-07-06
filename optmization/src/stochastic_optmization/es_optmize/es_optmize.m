function varargout = es_optmize(varargin)
% es_optmize M-file for es_optmize.fig
%      es_optmize, by itself, creates a new es_optmize or raises the existing
%      singleton*.
%
%      H = es_optmize returns the handle to a new es_optmize or the handle to
%      the existing singleton*.
%
%      es_optmize('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in es_optmize.M with the given input arguments.
%
%      es_optmize('Property','Value',...) creates a new es_optmize or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the ES_OPTMIZE before es_optmize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to es_optmize_OpeningFcn via varargin.
%
%      *See ES_OPTMIZE Options on GUIDE's Tools menu.  Choose "ES_OPTMIZE allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help es_optmize

% Last Modified by GUIDE v2.5 03-Jan-2016 20:35:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @es_optmize_OpeningFcn, ...
                   'gui_OutputFcn',  @es_optmize_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before es_optmize is made visible.
function es_optmize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to es_optmize (see VARARGIN)

% Choose default command line output for es_optmize
handles.output = hObject;

set(handles.eps_txt,'Enable','On');
set(handles.alpha1_txt,'Enable','On');
set(handles.alpha2_txt,'Enable','On');
set(handles.pop_size,'Enable','On');
set(handles.num_child,'Enable','On');
set(handles.maxevals_txt,'Enable','On');
set(handles.execnum_txt,'Enable','On');


handles.type = '3D';
handles.lim = [];

set(handles.maxevals_txt,'Enable','On');  
set(handles.calculate_button,'Enable','Off'); 
set(handles.funChange1,'Enable','Off');
set(handles.funChange2,'Enable','Off');


tickimg = imshow('green-tick-gray.png','Parent',handles.tickax);
colormap('bone');
freezeColors(handles.tickax);
colormap('winter')

set(tickimg,'Visible','Off');  
handles.tickimg = tickimg;

set(handles.refresh_button,'Enable','Off'); 
set(handles.figure_button,'Enable','Off'); 

set(handles.xlim_inf_txt,'Enable','Off'); 
set(handles.xlim_sup_txt,'Enable','Off');
set(handles.ylim_inf_txt,'Enable','Off'); 
set(handles.ylim_sup_txt,'Enable','Off'); 

%Default
set(handles.eps_txt,'String','1e-2');
set(handles.alpha1_txt,'String','1.0');
set(handles.alpha2_txt,'String','1.0');
set(handles.pop_size,'String','30');
set(handles.num_child,'String','200');
set(handles.maxevals_txt,'String','2e4');
set(handles.epsa_txt,'String','1e-10');
set(handles.epsr_txt,'String','1e-6');
set(handles.execnum_txt,'String','1');
set(handles.var_txt,'String','x');

% ------- Test functions --------------------------------------------------
% strfun = 'sin(x(1))^2+sin(x(2))^2';
% strfun = '2.5*(x(1))^2+(x(2))^2+3*x(1)*x(2)-5.5*x(1)-3.5*x(2)';
% strfun = '-exp(-x(1)^2-2*x(2)^2-2)';
% strfun = '(1-x(1))^2 + 2*(x(1)-x(2)^2)^2'; % Rosembrock
 strfun = '-20*exp(-0.2*sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 20 + exp(1)'; %Ackley
%--------------------------------------------------------------------------

set(handles.objfun_txt,'String',strfun)

set(handles.x0_txt,'String','[2 1]')

handles.x0 = str2num(get(handles.x0_txt,'String'));

axes(handles.ax1);
cla;
smile;
xlim([-10 10])
ylim([-10 10])
zlim([-10 12])

hold off;

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = es_optmize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in validate.
function validate_Callback(hObject, eventdata, handles)
% hObject    handle to validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
str = strcat('func = @(',strvar,')',strfun);
x0 = str2num(get(handles.x0_txt,'String'));

try
    eval(str);
    func(x0);
    set(handles.calculate_button,'Enable','On'); 
    set(handles.tickimg,'Visible','On');  
catch
    errordlg({'Input must be a function!' 'Ex.: x^2+2*x+5'},'Error');
    set(handles.calculate_button,'Enable','Off'); 
    set(handles.tickimg,'Visible','Off');  
end


% --- Executes on button press in calculate_button.
function calculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = str2func(strcat('@(',strvar,')',strfun));
%fun = str2func(strfun_complete)
x0 = str2num(get(handles.x0_txt,'String'));
dim = length(x0);

mu = str2double(get(handles.pop_size,'String'));
lambda = str2double(get(handles.num_child,'String'));
maxEvals = str2double(get(handles.maxevals_txt,'String'));
runs = str2double(get(handles.execnum_txt,'String'));
eps = str2double(get(handles.eps_txt,'String'));
alpha1 = str2double(get(handles.alpha1_txt,'String'));
alpha2 = str2double(get(handles.alpha2_txt,'String'));
epsa = str2double(get(handles.epsa_txt,'String'));
epsr = str2double(get(handles.epsr_txt,'String'));

dados = {};
for i=1:length(x0)
    dados{i} = strcat('x',num2str(i));
end
dados{i+1} = 'f(x)';

set(handles.uitable2,'ColumnName',dados)

fun = str2funcES(strfun,strvar,dim);
handles.fun = fun;

resultado = mainES(x0,fun,maxEvals,runs,mu,lambda,eps,alpha1,alpha2,epsa,epsr);

methodtitle = '';

res = [resultado.Dados{1}.xBest' resultado.Dados{1}.funcBest'];

resstr = convert2str(res);
set(handles.uitable2,'Data', resstr);

ax = handles.ax1;

set(handles.funChange1,'Enable','Off')
set(handles.funChange2,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')
set(handles.calculate_button,'Enable','Off')

minimum = res(end,end);
minstr = sprintf('%.4f',minimum);
niter = size(res,1)-1;
set(handles.min_txt,'String',num2str(minstr));
set(handles.niter_txt,'String',num2str(niter));

handles.fun = strfun_complete;
handles.resultado = resultado;
handles.res = res;
print_res(strfun_complete,ax,handles);

set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')
set(handles.calculate_button,'Enable','On')

set(handles.xlim_inf_txt,'Enable','On');
set(handles.ylim_inf_txt,'Enable','On');
set(handles.xlim_sup_txt,'Enable','On');
set(handles.ylim_sup_txt,'Enable','On'); 

if strcmp(handles.type,'3D')
    set(handles.funChange1,'Enable','Off');
    set(handles.funChange2,'Enable','On');
elseif strcmp(handles.type,'ND1')
    set(handles.funChange2,'Enable','Off');
    if length(handles.x0)>2
         set(handles.funChange1,'Enable','Off');
         set(handles.refresh_button,'Enable','Off');
    else
        set(handles.funChange1,'Enable','On');
    end
    
else
    set(handles.funChange1,'Enable','On');
    set(handles.funChange2,'Enable','On');
end


% add some additional data as a new field called numberOfErrors

handles.fun = fun;
handles.funforplot = fun;
handles.methodtitle = methodtitle;

% Save the change you made to the structure
guidata(hObject,handles)

function objfun_txt_Callback(hObject, eventdata, handles)
% hObject    handle to objfun_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of objfun_txt as text
%        str2double(get(hObject,'String')) returns contents of objfun_txt as a double


% --- Executes during object creation, after setting all properties.
function objfun_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objfun_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_txt_Callback(hObject, eventdata, handles)
% hObject    handle to step_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_txt as text
%        str2double(get(hObject,'String')) returns contents of step_txt as a double


% --- Executes during object creation, after setting all properties.
function step_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol_txt_Callback(hObject, eventdata, handles)
% hObject    handle to tol_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol_txt as text
%        str2double(get(hObject,'String')) returns contents of tol_txt as a double


% --- Executes during object creation, after setting all properties.
function tol_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iter_txt_Callback(hObject, eventdata, handles)
% hObject    handle to iter_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iter_txt as text
%        str2double(get(hObject,'String')) returns contents of iter_txt as a double


% --- Executes during object creation, after setting all properties.
function iter_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iter_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_txt_Callback(hObject, eventdata, handles)
% hObject    handle to b_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b_txt as text
%        str2double(get(hObject,'String')) returns contents of b_txt as a double


% --- Executes during object creation, after setting all properties.
function b_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function x0_txt_Callback(hObject, eventdata, handles)
% hObject    handle to x0_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0_txt as text
%        str2double(get(hObject,'String')) returns contents of x0_txt as a double
handles.lim = [];

handles.x0 = str2num(get(hObject,'String'));

if length(handles.x0)>2
    handles.type = 'ND1'; 
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function x0_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function eps_txt_Callback(hObject, eventdata, handles)
% hObject    handle to eps_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps_txt as text
%        str2double(get(hObject,'String')) returns contents of eps_txt as a double


% --- Executes during object creation, after setting all properties.
function eps_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maxevals_txt_Callback(hObject, eventdata, handles)
% hObject    handle to maxevals_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxevals_txt as text
%        str2double(get(hObject,'String')) returns contents of maxevals_txt as a double


% --- Executes during object creation, after setting all properties.
function maxevals_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxevals_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function var_txt_Callback(hObject, eventdata, handles)
% hObject    handle to var_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_txt as text
%        str2double(get(hObject,'String')) returns contents of var_txt as a double


% --- Executes during object creation, after setting all properties.
function var_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on objfun_txt and none of its controls.
function objfun_txt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to objfun_txt (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.calculate_button,'Enable','Off');
set(handles.refresh_button,'Enable','Off');
set(handles.figure_button,'Enable','Off');
set(handles.tickimg,'Visible','Off');  



% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

function resstr=convert2str(res)

    resstr = cell(size(res));
    for i=1:size(res,1)
        for j=1:size(res,2)
            resstr{i,j}= sprintf('%.4f',res(i,j));
        end
    end
    
function []=print_res(fun,ax,handles)

axes(ax);

n = length(handles.x0); 

set(handles.xlim_inf_txt,'Visible','On');
set(handles.xlim_sup_txt,'Visible','On');
set(handles.ylim_inf_txt,'Visible','On');
set(handles.ylim_sup_txt,'Visible','On');
set(handles.x1lim_txt,'Visible','On');
set(handles.x2lim_txt,'Visible','On');


res = handles.res;
resultado = handles.resultado;
ev_pop = resultado.Dados{1}.population;

if n<3    
    if ~isempty(handles.lim)
        xlim = handles.lim(1:2);
        ylim = handles.lim(3:4);
        
        handles.lim = [];
    else
        
        xsup = 1.5*(max(abs(res(:,1))));
        xinf = -xsup;
        
        ysup = 1.5*(max(abs(res(:,2))));
        yinf = -ysup;
        
        xlim = [xinf xsup];
        ylim = [yinf ysup];
        
    end
    
    set(handles.xlim_inf_txt,'String',num2str(xlim(1)));
    set(handles.xlim_sup_txt,'String',num2str(xlim(2)));
    set(handles.ylim_inf_txt,'String',num2str(ylim(1)));
    set(handles.ylim_sup_txt,'String',num2str(ylim(2)));
else
    xlim = [1 size(res,1)];
    ylim = [min(res(:,end)) max(res(:,end))];
    
    set(handles.xlim_inf_txt,'Visible','Off');
    set(handles.xlim_sup_txt,'Visible','Off');
    set(handles.ylim_inf_txt,'Visible','Off');
    set(handles.ylim_sup_txt,'Visible','Off');
    set(handles.x1lim_txt,'Visible','Off');
    set(handles.x2lim_txt,'Visible','Off');    
end

colormap(ax,'winter')

strvar = get(handles.var_txt,'String');
switch handles.type
    case '2D'
        
        xsup = 1.5*max((max(abs(ev_pop(1,:,:)))));
        xinf = -xsup;
        
        ysup = 1.5*max((max(abs(ev_pop(2,:,:)))));
        yinf = -ysup;
        
        xlim = [xinf xsup];
        ylim = [yinf ysup];
        
        set(handles.xlim_inf_txt,'Visible','Off');
        set(handles.xlim_sup_txt,'Visible','Off');
        set(handles.ylim_inf_txt,'Visible','Off');
        set(handles.ylim_sup_txt,'Visible','Off');
        set(handles.x1lim_txt,'Visible','Off');
        set(handles.x2lim_txt,'Visible','Off');
        
        plot2AnimateES(fun,resultado,xlim,ylim,strvar)
    case '2D_scaled'
        set(handles.xlim_inf_txt,'Visible','Off');
        set(handles.xlim_sup_txt,'Visible','Off');
        set(handles.ylim_inf_txt,'Visible','Off');
        set(handles.ylim_sup_txt,'Visible','Off');
        set(handles.x1lim_txt,'Visible','Off');
        set(handles.x2lim_txt,'Visible','Off');
        plot2AnimateES_scaled(fun,resultado,strvar,handles.rowindex)
    case '3D'
        plot3AnimateES(fun,res,xlim,ylim,strvar)
    case 'ND1'
        set(handles.xlim_inf_txt,'Visible','Off');
        set(handles.xlim_sup_txt,'Visible','Off');
        set(handles.ylim_inf_txt,'Visible','Off');
        set(handles.ylim_sup_txt,'Visible','Off');
        set(handles.x1lim_txt,'Visible','Off');
        set(handles.x2lim_txt,'Visible','Off');
        plotNAnimate1(res,strvar)
end

hold off;


% --- Executes on key press with focus on var_txt and none of its controls.
function var_txt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to var_txt (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.calculate_button,'Enable','Off');
set(handles.tickimg,'Visible','Off');  


function xlim_inf_txt_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_inf_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_inf_txt as text
%        str2double(get(hObject,'String')) returns contents of xlim_inf_txt as a double


% --- Executes during object creation, after setting all properties.
function xlim_inf_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_inf_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlim_sup_txt_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_sup_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_sup_txt as text
%        str2double(get(hObject,'String')) returns contents of xlim_sup_txt as a double


% --- Executes during object creation, after setting all properties.
function xlim_sup_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_sup_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh_button.
function refresh_button_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);
resultado = handles.resultado;
ax = handles.ax1;
methodtitle = handles.methodtitle;
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));
yinf = str2num(get(handles.ylim_inf_txt,'String'));
ysup = str2num(get(handles.ylim_sup_txt,'String'));

handles.lim = [xinf xsup yinf ysup];

set(handles.funChange1,'Enable','Off')
set(handles.funChange2,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

print_res(fun,ax,handles);

set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')

if strcmp(handles.type,'3D')
    set(handles.funChange1,'Enable','Off');
    set(handles.funChange2,'Enable','On');
elseif strcmp(handles.type,'ND1')
    set(handles.funChange2,'Enable','Off');
    if length(handles.x0)>2
         set(handles.funChange1,'Enable','Off');
    else
        set(handles.funChange1,'Enable','On');
    end
    
else
    set(handles.funChange1,'Enable','On');
    set(handles.funChange2,'Enable','On');
end

    

% --- Executes on button press in figure_button.
function figure_button_Callback(hObject, eventdata, handles)
% hObject    handle to figure_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun = handles.fun;

f = figure(1);clf;
h=axes;
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));
yinf = str2num(get(handles.ylim_inf_txt,'String'));
ysup = str2num(get(handles.ylim_sup_txt,'String'));

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');

res = handles.res;
ax = h;
methodtitle = handles.methodtitle;

handles.lim = [xinf xsup yinf ysup];

set(handles.funChange1,'Enable','Off')
set(handles.funChange2,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

print_res(fun,ax,handles); 

set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')

if strcmp(handles.type,'3D')
    set(handles.funChange1,'Enable','Off');
    set(handles.funChange2,'Enable','On');
elseif strcmp(handles.type,'ND1')
    set(handles.funChange2,'Enable','Off');
    if length(handles.x0)>2
         set(handles.funChange1,'Enable','Off');
    else
        set(handles.funChange1,'Enable','On');
    end
    
else
    set(handles.funChange1,'Enable','On');
    set(handles.funChange2,'Enable','On');
end


% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

ax = handles.ax1;
handles.type = '2D_scaled';

if numel(eventdata.Indices)~=0
    handles.rowindex = eventdata.Indices(1);
    print_res(fun,ax,handles);
end
guidata(hObject,handles)

set(handles.funChange1,'Enable','On');
set(handles.funChange2,'Enable','On');
set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open('ES.pdf');




% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'x1','x2','f(x)'})
    


function alpha1_txt_Callback(hObject, eventdata, handles)
% hObject    handle to alpha1_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha1_txt as text
%        str2double(get(hObject,'String')) returns contents of alpha1_txt as a double


% --- Executes during object creation, after setting all properties.
function alpha1_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha1_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function alpha2_txt_Callback(hObject, eventdata, handles)
% hObject    handle to alpha2_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha2_txt as text
%        str2double(get(hObject,'String')) returns contents of alpha2_txt as a double


% --- Executes during object creation, after setting all properties.
function alpha2_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha2_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ylim_inf_txt_Callback(hObject, eventdata, handles)
% hObject    handle to ylim_inf_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim_inf_txt as text
%        str2double(get(hObject,'String')) returns contents of ylim_inf_txt as a double


% --- Executes during object creation, after setting all properties.
function ylim_inf_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim_inf_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ylim_sup_txt_Callback(hObject, eventdata, handles)
% hObject    handle to ylim_sup_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim_sup_txt as text
%        str2double(get(hObject,'String')) returns contents of ylim_sup_txt as a double


% --- Executes during object creation, after setting all properties.
function ylim_sup_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim_sup_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in funChange2.
function funChange2_Callback(hObject, eventdata, handles)
% hObject    handle to funChange2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);
resultado = handles.resultado;
ax = handles.ax1;
methodtitle = handles.methodtitle;
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));
yinf = str2num(get(handles.ylim_inf_txt,'String'));
ysup = str2num(get(handles.ylim_sup_txt,'String'));

handles.lim = [xinf xsup yinf ysup];

set(handles.funChange1,'Enable','Off')
set(handles.funChange2,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')


if strcmp(handles.type,'3D')
    handles.type = '2D';
elseif (strcmp(handles.type,'2D') || strcmp(handles.type,'2D_scaled'))
    handles.type = 'ND1';
end


print_res(fun,ax,handles); 

if strcmp(handles.type,'3D')
    set(handles.funChange1,'Enable','Off');
    set(handles.funChange2,'Enable','On');
elseif strcmp(handles.type,'ND1')
    set(handles.funChange2,'Enable','Off');
    if length(handles.x0)>2
         set(handles.funChange1,'Enable','Off');
    else
        set(handles.funChange1,'Enable','On');
    end
    
else
    set(handles.funChange1,'Enable','On');
    set(handles.funChange2,'Enable','On');
end
    
set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')
guidata(hObject,handles)



% --- Executes on key press with focus on x0_txt and none of its controls.
function x0_txt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to x0_txt (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.calculate_button,'Enable','Off');
set(handles.tickimg,'Visible','Off');  

% --------------------------------------------------------------------
function Deterministic_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Deterministic_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Sthocastic_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Sthocastic_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SA_Submenu_Callback(hObject, eventdata, handles)
% hObject    handle to SA_Submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla


% --------------------------------------------------------------------
function ES_Submenu_Callback(hObject, eventdata, handles)
% hObject    handle to ES_Submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function pop_size_Callback(hObject, eventdata, handles)
% hObject    handle to pop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pop_size as text
%        str2double(get(hObject,'String')) returns contents of pop_size as a double


% --- Executes during object creation, after setting all properties.
function pop_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_child_Callback(hObject, eventdata, handles)
% hObject    handle to num_child (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_child as text
%        str2double(get(hObject,'String')) returns contents of num_child as a double


% --- Executes during object creation, after setting all properties.
function num_child_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_child (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function execnum_txt_Callback(hObject, eventdata, handles)
% hObject    handle to execnum_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of execnum_txt as text
%        str2double(get(hObject,'String')) returns contents of execnum_txt as a double


% --- Executes during object creation, after setting all properties.
function execnum_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to execnum_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in funChange1.
function funChange1_Callback(hObject, eventdata, handles)
% hObject    handle to funChange1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun = handles.fun;

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);
resultado = handles.resultado;
ax = handles.ax1;
methodtitle = handles.methodtitle;
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));
yinf = str2num(get(handles.ylim_inf_txt,'String'));
ysup = str2num(get(handles.ylim_sup_txt,'String'));

handles.lim = [xinf xsup yinf ysup];

set(handles.funChange1,'Enable','Off')
set(handles.funChange2,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

if (strcmp(handles.type,'2D') || strcmp(handles.type,'2D_scaled'))
    handles.type = '3D';
elseif strcmp(handles.type,'ND1')
    handles.type = '2D';
end

print_res(fun,ax,handles); 

if strcmp(handles.type,'3D')
    set(handles.funChange1,'Enable','Off');
    set(handles.funChange2,'Enable','On');
elseif strcmp(handles.type,'ND1')
    set(handles.funChange2,'Enable','Off');
    if length(handles.x0)>2
         set(handles.funChange1,'Enable','Off');
    else
        set(handles.funChange1,'Enable','On');
    end
    
else
    set(handles.funChange1,'Enable','On');
    set(handles.funChange2,'Enable','On');
end
    
set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')
guidata(hObject,handles)



% --- Executes on button press in resize_button.
function resize_buttom_Callback(hObject, eventdata, handles)
% hObject    handle to resize_buttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function epsa_txt_Callback(hObject, eventdata, handles)
% hObject    handle to epsa_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsa_txt as text
%        str2double(get(hObject,'String')) returns contents of epsa_txt as a double


% --- Executes during object creation, after setting all properties.
function epsa_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsa_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsr_txt_Callback(hObject, eventdata, handles)
% hObject    handle to epsr_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsr_txt as text
%        str2double(get(hObject,'String')) returns contents of epsr_txt as a double


% --- Executes during object creation, after setting all properties.
function epsr_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsr_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pre_defined_functions.
function pre_defined_functions_Callback(hObject, eventdata, handles)
% hObject    handle to pre_defined_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pre_defined_functions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pre_defined_functions

disp(get(hObject,'Value'));

if get(hObject,'Value') == 1 %Ackley
    
    strfun = '-20*exp(-0.2*sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 20 + exp(1)'; %Ackley
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 2 %Exponential
    
    strfun = '-exp(-x(1)^2-2*x(2)^2-2)';
    set(handles.objfun_txt,'String',strfun);       

elseif get(hObject,'Value') == 3 %Rosembrock
    
    strfun = '(1-x(1))^2 + 2*(x(1)-x(2)^2)^2'; % Rosembrock 
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 4 %Sin Quadratic
    
    strfun = 'sin(x(1))^2 + sin(x(2))^2';
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 5 %Quadratic
    
    strfun = '10*x(1)^2+3*x(2)^2';% Quadratic 
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 6 % Quadratic 2
    
    strfun = '2.5*(x(1))^2+(x(2))^2+3*x(1)*x(2)-5.5*x(1)-3.5*x(2)'; % Quadratic 2
    set(handles.objfun_txt,'String',strfun);
    
end
    
handles.lim = [];
guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function pre_defined_functions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pre_defined_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end