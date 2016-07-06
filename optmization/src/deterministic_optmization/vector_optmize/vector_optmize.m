function varargout = vector_optmize(varargin)
% vector_optmize M-file for vector_optmize.fig
%      vector_optmize, by itself, creates a new vector_optmize or raises the existing
%      singleton*.
%
%      H = vector_optmize returns the handle to a new vector_optmize or the handle to
%      the existing singleton*.
%
%      vector_optmize('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in vector_optmize.M with the given input arguments.
%
%      vector_optmize('Property','Value',...) creates a new vector_optmize or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the VECTOR_OPTMIZE before vector_optmize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vector_optmize_OpeningFcn via varargin.
%
%      *See VECTOR_OPTMIZE Options on GUIDE's Tools menu.  Choose "VECTOR_OPTMIZE allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vector_optmize

% Last Modified by GUIDE v2.5 10-Dec-2015 01:59:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vector_optmize_OpeningFcn, ...
                   'gui_OutputFcn',  @vector_optmize_OutputFcn, ...
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


% --- Executes just before vector_optmize is made visible.
function vector_optmize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vector_optmize (see VARARGIN)

% Choose default command line output for vector_optmize
handles.output = hObject;

set(handles.epsg_txt,'Enable','On');
set(handles.epsa_txt,'Enable','On');
set(handles.epsr_txt,'Enable','On');
set(handles.x0_txt,'Enable','On');
set(handles.method_conj_grad,'Enable','Off');
set(handles.method_quasi_newton,'Enable','Off');
set(handles.symb_num,'Enable','Off');
set(handles.hg_txt,'Enable','On');
set(handles.HG_TEXT,'Enable','Off');
set(handles.funChange,'Enable','Off');
set(handles.funChange,'String','>')

handles.type = '3D';
handles.lim = [];

set(handles.maxiter_txt,'Enable','On');  
set(handles.calculate_button,'Enable','Off'); 

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
set(handles.epsa_txt,'String','1e-8');
set(handles.epsg_txt,'String','1e-6');
set(handles.epsr_txt,'String','1e-4');
set(handles.var_txt,'String','x');
set(handles.maxiter_txt,'String','1000');
set(handles.hg_txt,'String','1e-10');
set(handles.HG_TEXT,'String','1e-6'); 

% ------- Test functions --------------------------------------------------
% set(handles.objfun_txt,'String','sin(x(1))^2+sin(x(2))^2')
% set(handles.objfun_txt,'String','2.5*(x(1))^2+(x(2))^2+3*x(1)*x(2)-5.5*x(1)-3.5*x(2)')
set(handles.objfun_txt,'String','-exp(-x(1)^2-2*x(2)^2-2)')
% set(handles.objfun_txt,'String','(1-x(1))^2 + 2*(x(1)-x(2)^2)^2'); % Rosembrock
%--------------------------------------------------------------------------

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
function varargout = vector_optmize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu2.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
contents = get(hObject,'String');

if strcmp(contents{get(hObject,'Value')},'Steepest Descent')
    
    set(handles.method_conj_grad,'Enable','Off');
    set(handles.method_quasi_newton,'Enable','Off');
    set(handles.symb_num,'Enable','Off');
    set(handles.hg_txt,'Enable','On');
    set(handles.HG_TEXT,'Enable','Off');
    
elseif strcmp(contents{get(hObject,'Value')},'Conjugate Gradient')
    
    set(handles.method_conj_grad,'Enable','On');
    set(handles.method_quasi_newton,'Enable','Off');
    set(handles.symb_num,'Enable','Off');
    set(handles.hg_txt,'Enable','On');
    set(handles.HG_TEXT,'Enable','Off');
    
elseif strcmp(contents{get(hObject,'Value')},'Newton')
    set(handles.symb_num,'Enable','On');
    set(handles.method_conj_grad,'Enable','Off');
    set(handles.method_quasi_newton,'Enable','Off');
    list_options =  get(handles.symb_num,'String');
    choice = list_options{get(handles.symb_num,'Value')};
    if strcmp(choice,'Analytic')
        set(handles.hg_txt,'Enable','Off');
        set(handles.HG_TEXT,'Enable','Off');
    end
        
              
elseif strcmp(contents{get(hObject,'Value')},'Newton Modified')
    set(handles.symb_num,'Enable','On');
    set(handles.method_conj_grad,'Enable','Off');
    set(handles.method_quasi_newton,'Enable','Off');
        
elseif strcmp(contents{get(hObject,'Value')},'Quasi-Newton')
    set(handles.method_conj_grad,'Enable','Off');
    set(handles.method_quasi_newton,'Enable','On');
    set(handles.symb_num,'Enable','Off');
    set(handles.hg_txt,'Enable','On');
    set(handles.HG_TEXT,'Enable','Off');
end

handles.lim = [];
guidata(hObject, handles);    

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
strfun_complete = strcat('@(',strvar,')',strfun);
fun = str2func(strfun_complete);
handles.fun = fun;

epsg = str2double(get(handles.epsg_txt,'String'));
epsa = str2double(get(handles.epsa_txt,'String'));
epsr = str2double(get(handles.epsr_txt,'String'));
itMax = str2double(get(handles.maxiter_txt,'String'));
x0 = str2num(get(handles.x0_txt,'String'));
hg = str2double(get(handles.hg_txt,'String'));
hG = str2double(get(handles.HG_TEXT,'String'));

dados = {};
for i=1:length(x0)
    dados{i} = strcat('x',num2str(i));
end
dados{i+1} = 'f(x)';

set(handles.uitable2,'ColumnName',dados)

contents = get(handles.method,'String');

if strcmp(contents{get(handles.method,'Value')},'Steepest Descent')
    res =gradient_descent(fun,x0,epsg,epsa,epsr,itMax,hg);
    
elseif strcmp(contents{get(handles.method,'Value')},'Conjugate Gradient')
    listMethods = get(handles.method_conj_grad,'String');
    method = listMethods{get(handles.method_conj_grad,'Value')};
    res=conjugate_gradient(fun,x0,epsg,epsa,epsr,itMax,method,hg);

elseif strcmp(contents{get(handles.method,'Value')},'Newton')
    list_options =  get(handles.symb_num,'String');
    choice = list_options{get(handles.symb_num,'Value')};
    if strcmp(choice,'Analytic')
        res = newton_symb(fun,x0,epsg,epsa,epsr,itMax);
    elseif strcmp(choice,'Numeric')
        res = newton_numeric(fun,x0,epsg,epsa,epsr,itMax,hg,hG);
    end
    
      
elseif strcmp(contents{get(handles.method,'Value')},'Newton Modified')
    list_options =  get(handles.symb_num,'String');
    method = list_options{get(handles.symb_num,'Value')};            
    res = newton_modified(fun,x0,epsg,epsa,epsr,itMax,method,hg,hG);
    
elseif strcmp(contents{get(handles.method,'Value')},'Quasi-Newton')
    listMethods = get(handles.method_quasi_newton,'String');
    method = listMethods{get(handles.method_quasi_newton,'Value')};
    res = quasi_newton(fun,x0,epsg,epsa,epsr,itMax,method,hg);    
end
methodtitle = '';
resTable = [res(:,1:length(x0)) res(:,end)];
resstr = convert2str(resTable);
set(handles.uitable2,'Data', resstr);

ax = handles.ax1;

set(handles.funChange,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

minimum = res(end,end);
minstr = sprintf('%.4f',minimum);
niter = size(res,1)-1;
set(handles.min_txt,'String',num2str(minstr));
set(handles.niter_txt,'String',num2str(niter));

print_res(res,fun,ax,methodtitle,strvar,strfun_complete,handles);

set(handles.funChange,'Enable','On')
set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')

set(handles.xlim_inf_txt,'Enable','On');
set(handles.ylim_inf_txt,'Enable','On');
set(handles.xlim_sup_txt,'Enable','On');
set(handles.ylim_sup_txt,'Enable','On'); 
set(handles.funChange,'Enable','On')


% add some additional data as a new field called numberOfErrors
handles.res = res;
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


function epsg_txt_Callback(hObject, eventdata, handles)
% hObject    handle to epsg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsg_txt as text
%        str2double(get(hObject,'String')) returns contents of epsg_txt as a double


% --- Executes during object creation, after setting all properties.
function epsg_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gamma_txt_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma_txt as text
%        str2double(get(hObject,'String')) returns contents of gamma_txt as a double


% --- Executes during object creation, after setting all properties.
function gamma_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_txt (see GCBO)
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


function maxiter_txt_Callback(hObject, eventdata, handles)
% hObject    handle to maxiter_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxiter_txt as text
%        str2double(get(hObject,'String')) returns contents of maxiter_txt as a double


% --- Executes during object creation, after setting all properties.
function maxiter_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxiter_txt (see GCBO)
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
    
function []=print_res(res,fun,ax,methodtitle,strvar,strfun,handles)
axes(ax);

n = length(handles.x0); 

set(handles.xlim_inf_txt,'Visible','On');
set(handles.xlim_sup_txt,'Visible','On');
set(handles.ylim_inf_txt,'Visible','On');
set(handles.ylim_sup_txt,'Visible','On');
set(handles.x1lim_txt,'Visible','On');
set(handles.x2lim_txt,'Visible','On');

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

switch handles.type
    case '2D'
        plot2Animate(fun,res,xlim,ylim,strvar)
    case '3D'
        plot3Animate(fun,res,xlim,ylim,strvar)
    case 'ND1'
        plotNAnimate1(res,strvar)
    case 'ND2'
        plotNAnimate2(res,n,strvar)
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
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));
yinf = str2num(get(handles.ylim_inf_txt,'String'));
ysup = str2num(get(handles.ylim_sup_txt,'String'));

fun = handles.fun;

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');
funforplot = str2func(strforplot);

res = handles.res;
ax = handles.ax1;
methodtitle = handles.methodtitle;

set(handles.funChange,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

handles.lim = [xinf xsup yinf ysup];

print_res(res,fun,ax,methodtitle,strvar,strfun_complete,handles);

set(handles.funChange,'Enable','On')
set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')
    

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
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');
funforplot = str2func(strforplot);

res = handles.res;
ax = h;
methodtitle = handles.methodtitle;

handles.lim = [xinf xsup yinf ysup];

print_res(res,fun,ax,methodtitle,strvar,strfun_complete,handles);  


% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');
funforplot = str2func(strforplot);

res = handles.res;
ax = handles.ax1;
methodtitle = handles.methodtitle;

if numel(eventdata.Indices)~=0
    rowindex = eventdata.Indices(1);
    print1plot(res,funforplot,ax,methodtitle,strvar,strfun_complete,res(1,1),res(1,2),rowindex)
end

function []=print1plot(res,fun,ax,methodtitle,var,strfun,xinf,xsup,index)
axes(ax);
x=[(xinf-0.01):0.01:(xsup+0.01)];         %to plot
plot(x,feval(fun,x),'LineWidth',2); %to plot
grid on;
hold
xlim([xinf xsup]);                        %to plot

varstr = var;
xlabel(var);                        %to plot

fstr = strcat('f(',varstr,')');
ylabel(fstr);                     %to plot

titlestr = strcat(methodtitle,strfun);
title(titlestr);

if size(res,1)==index
    scatter(res(index,1),res(index,3),80,'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'LineWidth',1.5);               %to plot
    scatter(res(index,2),res(index,4),80,'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',... 
        'LineWidth',1.5);               %to plot
    
else
    scatter(res(index,1),res(index,3),80,'MarkerEdgeColor','k',...
        'MarkerFaceColor','y',...
        'LineWidth',1.5);               %to plot
    scatter(res(index,2),res(index,4),80,'MarkerEdgeColor','k',...
        'MarkerFaceColor','y',... 
        'LineWidth',1.5);               %to plot
end

scatter(res(1,1),res(1,3),80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',...
    'LineWidth',1.5);               %to plot
scatter(res(1,2),res(1,4),80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',... 
    'LineWidth',1.5);               %to plot

hold off;


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(handles.method,'String');
if strcmp(contents{get(handles.method,'Value')},'Steepest Descent')
    open('gradient_descent.pdf');
elseif strcmp(contents{get(handles.method,'Value')},'Conjugate Gradient')
    open('conjugate_gradient.pdf');
elseif strcmp(contents{get(handles.method,'Value')},'Newton')
    open('newton.pdf');
elseif strcmp(contents{get(handles.method,'Value')},'Newton Modified')
    open('newton_modified.pdf');
elseif strcmp(contents{get(handles.method,'Value')},'Quasi-Newton')
    open('quasi_newton.pdf');

end


% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'x1','x2','f(x)'})
    
% --- Executes on selection change in method_conj_grad.
function method_conj_grad_Callback(hObject, eventdata, handles)
% hObject    handle to method_conj_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_conj_grad contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_conj_grad


% --- Executes during object creation, after setting all properties.
function method_conj_grad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_conj_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in method_quasi_newton.
function method_quasi_newton_Callback(hObject, eventdata, handles)
% hObject    handle to method_quasi_newton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_quasi_newton contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_quasi_newton


% --- Executes during object creation, after setting all properties.
function method_quasi_newton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_quasi_newton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in symb_num.
function symb_num_Callback(hObject, eventdata, handles)
% hObject    handle to symb_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns symb_num contents as cell array
%        contents{get(hObject,'Value')} returns selected item from symb_num
list =  get(hObject,'String');
escolha = list{get(handles.symb_num,'Value')};

if strcmp(escolha,'Analytic')
    set(handles.hg_txt,'Enable','Off');
    set(handles.HG_TEXT,'Enable','Off');
elseif strcmp(escolha,'Numeric')
    set(handles.hg_txt,'Enable','On');
    set(handles.HG_TEXT,'Enable','On');
end


% --- Executes during object creation, after setting all properties.
function symb_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symb_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hg_txt_Callback(hObject, eventdata, handles)
% hObject    handle to hg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hg_txt as text
%        str2double(get(hObject,'String')) returns contents of hg_txt as a double


% --- Executes during object creation, after setting all properties.
function hg_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in funChange.
function funChange_Callback(hObject, eventdata, handles)
% hObject    handle to funChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fun = handles.fun;

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
strfun_complete = strcat('@(',strvar,')',strfun);
res = handles.res;
ax = handles.ax1;
methodtitle = handles.methodtitle;
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));
yinf = str2num(get(handles.ylim_inf_txt,'String'));
ysup = str2num(get(handles.ylim_sup_txt,'String'));

handles.lim = [xinf xsup yinf ysup];

set(handles.funChange,'Enable','Off')
set(handles.refresh_button,'Enable','Off')
set(handles.figure_button,'Enable','Off')

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

print_res(res,fun,ax,methodtitle,strvar,strfun_complete,handles); 
set(handles.funChange,'Enable','On')
set(handles.refresh_button,'Enable','On')
set(handles.figure_button,'Enable','On')
guidata(hObject,handles)



function HG_TEXT_Callback(hObject, eventdata, handles)
% hObject    handle to HG_TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HG_TEXT as text
%        str2double(get(hObject,'String')) returns contents of HG_TEXT as a double


% --- Executes during object creation, after setting all properties.
function HG_TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HG_TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
