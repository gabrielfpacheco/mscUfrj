function varargout = sa_optmize(varargin)
% sa_optmize M-file for sa_optmize.fig
%      sa_optmize, by itself, creates a new sa_optmize or raises the existing
%      singleton*.
%
%      H = sa_optmize returns the handle to a new sa_optmize or the handle to
%      the existing singleton*.
%
%      sa_optmize('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in sa_optmize.M with the given input arguments.
%
%      sa_optmize('Property','Value',...) creates a new sa_optmize or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the SA_OPTMIZE before sa_optmize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sa_optmize_OpeningFcn via varargin.
%
%      *See SA_OPTMIZE Options on GUIDE's Tools menu.  Choose "SA_OPTMIZE allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sa_optmize

% Last Modified by GUIDE v2.5 07-Jan-2016 00:42:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sa_optmize_OpeningFcn, ...
                   'gui_OutputFcn',  @sa_optmize_OutputFcn, ...
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

% --- Executes just before sa_optmize is made visible.
function sa_optmize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sa_optmize (see VARARGIN)

% Choose default command line output for sa_optmize
handles.output = hObject;

%% Enable/Disable Fields

% Parameters Panel
setParametersOn(handles);

% Objective Function Panel

tickimg = imshow('green-tick-gray.png','Parent',handles.tickax);
colormap('bone');
freezeColors(handles.tickax);
colormap('winter')
set(tickimg,'Visible','Off');  
set(handles.calculate_button,'Enable','Off'); 

% Xlim and Ylim Panel
setXlimYlimOff(handles);

% Refresh Panel
setRefreshButtonsOff(handles);

% Default Values
setDefaultFields(handles);

% Smile Axes
showSmile(handles)         

% Handles
handles.type = '3D';
handles.lim = [];
handles.x0 = str2num(get(handles.x0_txt,'String'));
handles.tickimg = tickimg;

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = sa_optmize_OutputFcn(hObject, eventdata, handles) 
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
    errordlg({'Input must be a function and x0 must have the same dimension!' 'Ex.: x^2+2*x+5 / x0=[1 2]'},'Error');
    set(handles.calculate_button,'Enable','Off'); 
    set(handles.tickimg,'Visible','Off');  
end

% --- Executes on button press in calculate_button.
function calculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set Off Refresh Buttons
setRefreshButtonsOff(handles);

% Get Variables From Objective Function Panel
[fun,strfun_complete,x0,dim] = getObjectiveFunctionVars(handles);

% Get Variables From Parameters Panel
[N,K,T0,eps,success_rate,type] = getParametersVars(handles);

%% Simmulated Annealing
[res,fres,Jmin,Xmin] = SA(fun,x0,N,K,T0,eps,type,success_rate);
handles.res = res;
handles.K = K;
handles.fres = fres;
handles.fun = fun;

% Create Headers and Fill Tables
createTableHeaders(handles,dim);
fillTable(handles,res,fres,Xmin,Jmin);

% Plot Results Axis 2

% Set Type Of Plot (2 variables or more than 2)
if dim<3
    handles.type = '3D';
    set(handles.funChange,'String','>')
else
    handles.type = 'ND1';
    set(handles.funChange,'String','>')
end
ax = handles.ax2;
print_res(strfun_complete,handles,ax);

% Set On Refresh Buttons and XlimYlim Fields
setRefreshButtonsOn(handles);
setXlimYlimOn(handles);

% Save the change you made to the structure
guidata(hObject,handles)

function objfun_txt_Callback(hObject, eventdata, handles)

function objfun_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objfun_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

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
else
    handles.type = '3D';
end

guidata(hObject,handles)

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

function eps_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function var_txt_Callback(hObject, eventdata, handles)

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
set(handles.tickimg,'Visible','Off');  
setRefreshButtonsOff(handles);


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
            if j==4 %counter
                resstr{i,j}= sprintf('%d',res(i,j));    
            else
                resstr{i,j}= sprintf('%.4f',res(i,j));
            end
        end
        
    end
    
function []=print_res(fun,handles,ax)

axes(ax);

setXlimYlimVisible(handles);

n = length(handles.x0);
res = handles.res;

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
    
    setXlimYlimInvisible(handles);
end

colormap(ax,'winter')

strvar = get(handles.var_txt,'String');

pres = res(:,1:(end-2));

switch handles.type
    case '2D'
        plot2Animate(fun,res,xlim,ylim,strvar);
    case '3D'
        plot3Animate_SA(fun,pres,xlim,ylim,strvar,ax);
    case 'ND1'
        showSmile(handles);
    case 'ND2'
        showSmile(handles);
end

hold off;

function []=print_temp(handles)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');

K = handles.K;
res = handles.res;
fres = handles.fres;

%colormap(ax1,'winter')

SA_plot1(K,fres,res(:,end));

hold off;

function []=print_probability(handles)

f = figure(2);clf;
ax1 = axes;

K = handles.K;
res = handles.res;
fres = handles.fres;

%a=0.05;
b=10;               %nro de temperaturas para plotar
c=1;                %inicializacao do contador
d = floor(K/b);     %intervalos entre as temperaturas
e = 10;             %nro de intervalos

 for i=1:K
    if mod(i-1,d)==0
        if i==1
            Jc = fres(1:(res(i,end)-1)); 
        else          
            Jc = fres(res(i-1,end):(res(i,end)-1)); 
        end
        
        minJc = min(Jc);
        maxJc = max(Jc);
        a = (maxJc-minJc)/e;
        
        edg = (minJc-a):a:(maxJc+a); 
        subplot(b/2,2,c);
        H2 = histc(Jc,edg)/length(Jc); 
        bar(edg,H2,'r-','histc');
        strtitle = strcat('T(',num2str(i),')=',num2str(res(i,end-1)));
        title(strtitle);
        xlabel('f(x)');
        ylabel('p(f(x))');
        %title(num2str(c))
        c=c+1;
        if c==(b+1)
            break
        end
    end
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
[xinf,xsup,yinf,ysup] = getXYlimits(handles);         

fun = handles.fun;

setRefreshButtonsOff(handles);

handles.lim = [xinf xsup yinf ysup];

ax = handles.ax2;
print_res(fun,handles,ax);

setRefreshButtonsOn(handles);

% --- Executes on button press in figure_button.
function figure_button_Callback(hObject, eventdata, handles)
% hObject    handle to figure_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun = handles.fun;

f = figure(1);
clf;
ax = axes;

[xinf,xsup,yinf,ysup] = getXYlimits(handles);

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');

res = handles.res;

handles.lim = [xinf xsup yinf ysup];

print_res(fun,handles,ax);  


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open('SA.pdf');


function ylim_inf_txt_Callback(hObject, eventdata, handles)

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

% --- Executes on button press in funChange.
function funChange_Callback(hObject, eventdata, handles)
% hObject    handle to funChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun = handles.fun;

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);

[xinf,xsup,yinf,ysup] = getXYlimits(handles);

handles.lim = [xinf xsup yinf ysup];

setRefreshButtonsOff(handles);

if strcmp(get(hObject,'String'),'>')
    set(hObject,'String','<')
    if length(handles.x0)>2
        handles.type = 'ND2';
    else
        handles.type = '2D';
    end
else
    set(hObject,'String','>')
    if length(handles.x0)>2
        handles.type = 'ND1';
    else
        handles.type = '3D';
    end
end

ax = handles.ax2;
print_res(fun,handles,ax); 

setRefreshButtonsOn(handles);
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

function N_text_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function N_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function K_txt_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function K_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function T0_txt_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function T0_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T0_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function type_popup_Callback(hObject, eventdata, handles)

function type_popup_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pre_defined_functions_popup_Callback(hObject, eventdata, handles)

disp(get(hObject,'Value'));

if get(hObject,'Value') == 1 %Quadratic
    
    strfun = '10*x(1)^2+3*x(2)^2';
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 2 %Sin Quadratic
    
    strfun = 'sin(x(1))^2 + sin(x(2))^2';
    set(handles.objfun_txt,'String',strfun);       
  
elseif get(hObject,'Value') == 3 %Exponential
    
    strfun = '-exp(-x(1)^2-2*x(2)^2-2)';
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 4 %Rosenbrock
    
    strfun = '(1-x(1))^2 + 2*(x(1)-x(2)^2)^2'; % Rosembrock
    set(handles.objfun_txt,'String',strfun);
    
elseif get(hObject,'Value') == 5 %Ackley
    
    strfun = '-20*exp(-0.2*sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 20 + exp(1)'; %Ackley
    set(handles.objfun_txt,'String',strfun);
    
end
    
handles.lim = [];
guidata(hObject, handles); 


function pre_defined_functions_popup_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function N_txt_Callback(hObject, eventdata, handles)

function N_txt_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function success_rate_txt_Callback(hObject, eventdata, handles)

function success_rate_txt_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function button_T_Callback(hObject, eventdata, handles)

print_temp(handles);


function button_P_Callback(hObject, eventdata, handles)

print_probability(handles)


function [fun,strfun_complete,x0,dim]=getObjectiveFunctionVars(handles)

    strfun = get(handles.objfun_txt,'String');
    strvar = get(handles.var_txt,'String');
    strfun_complete = str2func(strcat('@(',strvar,')',strfun));
    fun = strfun_complete;
    x0 = str2num(get(handles.x0_txt,'String'));
    dim = length(x0);

function [N,K,T0,eps,success_rate,type] = getParametersVars(handles)

    N = str2double(get(handles.N_txt,'String'));
    K = str2double(get(handles.K_txt,'String'));
    T0 = str2double(get(handles.T0_txt,'String'));
    eps = str2double(get(handles.eps_txt,'String'));
    success_rate = str2double(get(handles.success_rate_txt,'String'));
    contents = get(handles.type_popup,'String');
    type = contents{get(handles.type_popup,'Value')};

function [] = createTableHeaders(handles,dim)

    % First Table
    dados = cell(dim+2);
    for i=1:dim
        dados{i} = strcat('x',num2str(i));
    end
    dados{dim+1} = 'f(x)';
    dados{dim+2} = 'T';
    set(handles.uitable2,'ColumnName',dados)

    % Second Table
    dados2 = cell(dim+2);
    for i=1:dim
        dados2{i} = strcat('x',num2str(i),'_min');
    end
    dados2{dim+1} = 'f(x)_min';
    dados2{dim+2} = 'iterations';
    set(handles.uitable4,'ColumnName',dados2)

function [] = fillTable(handles,res,fres,Xmin,Jmin)   
    
    % First Table Fill
    resstr = convert2str(res(:,1:(end-1)));
    set(handles.uitable2,'Data', resstr);

    % Second Table Fill
    niter = size(fres,1)-1;
    resstr2 = convert2str([Xmin,Jmin,niter]);
    set(handles.uitable4,'Data', resstr2);

function [] = setParametersOff(handles)
    
    set(handles.N_txt,'Enable','Off');
    set(handles.K_txt,'Enable','Off');
    set(handles.T0_txt,'Enable','Off');
    set(handles.eps_txt,'Enable','Off');
    set(handles.success_rate_txt,'Enable','Off');
    set(handles.type_popup,'Enable','Off');

function [] = setParametersOn(handles)
    
    set(handles.N_txt,'Enable','On');
    set(handles.K_txt,'Enable','On');
    set(handles.T0_txt,'Enable','On');
    set(handles.eps_txt,'Enable','On');
    set(handles.success_rate_txt,'Enable','On');
    set(handles.type_popup,'Enable','On');
    
function [] = setRefreshButtonsOff(handles)
    
    set(handles.funChange,'Enable','Off')
    set(handles.refresh_button,'Enable','Off')
    set(handles.figure_button,'Enable','Off')
    set(handles.calculate_button,'Enable','Off')
    set(handles.button_T,'Enable','Off'); 
    set(handles.button_P,'Enable','Off'); 

function [] = setRefreshButtonsOn(handles)    
    
    set(handles.funChange,'Enable','On')
    set(handles.refresh_button,'Enable','On')
    set(handles.figure_button,'Enable','On')
    set(handles.button_T,'Enable','On'); 
    set(handles.calculate_button,'Enable','On')
    set(handles.button_P,'Enable','On'); 

function [] = setXlimYlimOn(handles)    
    
    set(handles.xlim_inf_txt,'Enable','On');
    set(handles.ylim_inf_txt,'Enable','On');
    set(handles.xlim_sup_txt,'Enable','On');
    set(handles.ylim_sup_txt,'Enable','On'); 
    
function [] = setXlimYlimOff(handles)        
    
    set(handles.xlim_inf_txt,'Enable','Off');
    set(handles.ylim_inf_txt,'Enable','Off');
    set(handles.xlim_sup_txt,'Enable','Off');
    set(handles.ylim_sup_txt,'Enable','Off');     
    
function [] = setDefaultFields(handles)         
    
    set(handles.N_txt,'String','500');
    set(handles.K_txt,'String','100');
    set(handles.T0_txt,'String','5');
    set(handles.eps_txt,'String','0.1');
    set(handles.success_rate_txt,'String','0.5');
    set(handles.var_txt,'String','x');
    
    % ------- Test functions --------------------------------------------------
    strfun = '10*(x(1))^2+3*(x(2))^2';
    % strfun = 'sin(x(1))^2+sin(x(2))^2';
    % strfun = '-exp(-x(1)^2-2*x(2)^2-2)';
    % strfun = '(1-x(1))^2 + 2*(x(1)-x(2)^2)^2'; % Rosembrock
    % strfun = '-20*exp(-0.2*sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 20 + exp(1)'; %Ackley
    %--------------------------------------------------------------------------

    set(handles.objfun_txt,'String',strfun)
    set(handles.x0_txt,'String','[2 1]')
    
function [] = showSmile(handles)             
    axes(handles.ax2);
    cla;
    smile;
    xlim([-10 10]);
    ylim([-10 10]);
    zlim([-10 12]);
    hold off;

function [] = setXlimYlimVisible(handles)      
    
    set(handles.xlim_inf_txt,'Visible','On');
    set(handles.xlim_sup_txt,'Visible','On');
    set(handles.ylim_inf_txt,'Visible','On');
    set(handles.ylim_sup_txt,'Visible','On');
    set(handles.x1lim_txt,'Visible','On');
    set(handles.x2lim_txt,'Visible','On');
    
 function [] = setXlimYlimInvisible(handles)      
    
    set(handles.xlim_inf_txt,'Visible','Off');
    set(handles.xlim_sup_txt,'Visible','Off');
    set(handles.ylim_inf_txt,'Visible','Off');
    set(handles.ylim_sup_txt,'Visible','Off');
    set(handles.x1lim_txt,'Visible','Off');
    set(handles.x2lim_txt,'Visible','Off');
    
function [xinf,xsup,yinf,ysup] = getXYlimits(handles)          
    xinf = str2double(get(handles.xlim_inf_txt,'String'));
    xsup = str2double(get(handles.xlim_sup_txt,'String'));
    yinf = str2double(get(handles.ylim_inf_txt,'String'));
    ysup = str2double(get(handles.ylim_sup_txt,'String'));
