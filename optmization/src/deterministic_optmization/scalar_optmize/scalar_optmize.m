function varargout = scalar_optmize(varargin)
% scalar_optmize M-file for scalar_optmize.fig
%      scalar_optmize, by itself, creates a new scalar_optmize or raises the existing
%      singleton*.
%
%      H = scalar_optmize returns the handle to a new scalar_optmize or the handle to
%      the existing singleton*.
%
%      scalar_optmize('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in scalar_optmize.M with the given input arguments.
%
%      scalar_optmize('Property','Value',...) creates a new scalar_optmize or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the SCALAR_OPTMIZE before scalar_optmize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scalar_optmize_OpeningFcn via varargin.
%
%      *See SCALAR_OPTMIZE Options on GUIDE's Tools menu.  Choose "SCALAR_OPTMIZE allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scalar_optmize

% Last Modified by GUIDE v2.5 10-Dec-2015 02:33:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scalar_optmize_OpeningFcn, ...
                   'gui_OutputFcn',  @scalar_optmize_OutputFcn, ...
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


% --- Executes just before scalar_optmize is made visible.
function scalar_optmize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scalar_optmize (see VARARGIN)

% Choose default command line output for scalar_optmize
handles.output = hObject;

%axes(handles.axes3)
%matlabImage = imread('green-tick.png');
%imshow(matlabImage)
%axis off
%axis image

set(handles.step_txt,'Enable','Off');
set(handles.x0_txt,'Enable','Off');
set(handles.gamma_txt,'Enable','Off');  

set(handles.iter_txt,'Enable','Off');  


set(handles.calculate_button,'Enable','Off'); 

tickimg = imshow('green-tick-gray.png','Parent',handles.tickax);
set(tickimg,'Visible','Off');  
handles.tickimg = tickimg;

set(handles.refresh_button,'Enable','Off'); 
set(handles.figure_button,'Enable','Off'); 

set(handles.xlim_inf_txt,'Enable','Off'); 
set(handles.xlim_sup_txt,'Enable','Off'); 

%Deafult
set(handles.step_txt,'String','0.1');
set(handles.x0_txt,'String','0');
set(handles.gamma_txt,'String','1.5');
set(handles.a_txt,'String','-0.1');
set(handles.b_txt,'String','0.1');
set(handles.tol_txt,'String','0.001');
set(handles.iter_txt,'String','10');
set(handles.var_txt,'String','x');
set(handles.maxiter_txt,'String','100');
set(handles.objfun_txt,'String','10*x^3+x^4')

set(handles.uitable2,'Data',repmat(0,20,4));

axes(handles.ax1);
%plot(0,0); %to plot
%xlabel('x');                        %to plot
%ylabel('f(x)');                     %to plot
%title('Initialization');

x=[-0.1:0.01:0.1];
y=x.^2;
plot(x,y,'LineWidth',2);
xlabel('x');                        %to plot
ylabel('f(x)');                     %to plot
title('Initialization');
grid
xlim([-0.15 0.15])
ylim([-0.005 0.03])
hold
scatter(-0.05,0.02,80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',...
    'LineWidth',1.5);               %to plot

scatter(0.05,0.02,80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',...
    'LineWidth',1.5);
% Update handles structure
hold off;

%I = imread('green-tick.png');

guidata(hObject, handles);

 
% UIWAIT makes scalar_optmize wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scalar_optmize_OutputFcn(hObject, eventdata, handles) 
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
if strcmp(contents{get(hObject,'Value')},'Golden Section')
    set(handles.iter_txt,'Enable','Off');
    set(handles.tol_txt,'Enable','On');  
    set(handles.maxiter_txt,'Enable','On');  
elseif strcmp(contents{get(hObject,'Value')},'Fibonacci')
    set(handles.iter_txt,'Enable','On');
    set(handles.tol_txt,'Enable','Off');    
    set(handles.maxiter_txt,'Enable','Off');    
elseif strcmp(contents{get(hObject,'Value')},'Brent')
    set(handles.iter_txt,'Enable','Off');
    set(handles.tol_txt,'Enable','On'); 
    set(handles.maxiter_txt,'Enable','On');      
end
    

% --- Executes on button press in validate.
function validate_Callback(hObject, eventdata, handles)
% hObject    handle to validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strfun = get(handles.objfun_txt,'String');
strvar = get(handles.var_txt,'String');
str = strcat('func = @(',strvar,')',strfun);

try
    eval(str);
    feval(func,0);
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
strforplot = strrep(strfun_complete,'^','.^');
strforplot = strrep(strforplot,'*','.*');
strforplot = strrep(strforplot,'/','./');
funforplot = str2func(strforplot);

if get(handles.autoframing_checkbox,'Value')
    delta = str2double(get(handles.step_txt,'String'));
    gamma = str2double(get(handles.gamma_txt,'String'));
    x0 = str2double(get(handles.x0_txt,'String'));
    [a,b]=framing(fun,x0,delta,gamma);
else
    a = str2double(get(handles.a_txt,'String'));
    b = str2double(get(handles.b_txt,'String'));
end

contents = get(handles.method,'String');
if strcmp(contents{get(handles.method,'Value')},'Golden Section')

    tol = str2double(get(handles.tol_txt,'String'));
    itMax = str2double(get(handles.maxiter_txt,'String'));
    [I,res]=golden_section(fun,a,b,tol,itMax);
    
    resstr = convert2str(res);    
    
    % colnames = {'X-Data', 'Y-Data', 'Z-Data'};
    set(handles.uitable2,'Data', resstr);
    
    ax = handles.ax1;
    methodtitle = 'Golden Section''s Method:';
    print_res(res,funforplot,ax,methodtitle,strvar,strfun_complete,res(1,1),res(1,2))  
    
elseif strcmp(contents{get(handles.method,'Value')},'Fibonacci')

    n = str2double(get(handles.iter_txt,'String'));
    [I,res]=fibonacci(fun,a,b,n);

    resstr = convert2str(res);    
    %colnames = {'X-Data', 'Y-Data', 'Z-Data'};
    %t = uitable(f, 'Data', data, 'ColumnName', colnames, ...
              %     'Position', [20 20 260 100]);
    set(handles.uitable2,'Data', resstr);
    
    ax = handles.ax1;
    methodtitle = 'Fibonacci''s Method:';
    print_res(res,funforplot,ax,methodtitle,strvar,strfun_complete,res(1,1),res(1,2))
   
    
elseif strcmp(contents{get(handles.method,'Value')},'Brent')

    tol = str2double(get(handles.tol_txt,'String'));
    itMax = str2double(get(handles.maxiter_txt,'String'));
    
    [I,res,exp,xmin]=brent(fun,a,b,tol,itMax);
    
 %   catch
 %       return;
 %   end
    
    resstr = convert2str(res);    
    
    % colnames = {'X-Data', 'Y-Data', 'Z-Data'};
    set(handles.uitable2,'Data', resstr);
    
    ax = handles.ax1;
    methodtitle = 'Brent''s Method: ';
    print_res(res,funforplot,ax,methodtitle,strvar,strfun_complete,res(1,1),res(1,2));    

    if exp==1
        msg = strcat('O minimizador do intervalo e: xmin = ',num2str(xmin));
       % msg = strcat('O intervalo escolhido nao e enquadrante!',msg);
        errordlg({'O intervalo escolhido nao e enquadrante!' msg},'Error');
    end   
    
end

set(handles.refresh_button,'Enable','On');
set(handles.figure_button,'Enable','On'); 

set(handles.xlim_inf_txt,'Enable','On');
set(handles.xlim_inf_txt,'String',num2str(res(1,1)));
set(handles.xlim_sup_txt,'Enable','On'); 
set(handles.xlim_sup_txt,'String',num2str(res(1,2)));


minimum = (res(end,1)+res(end,2))/2;
minstr = sprintf('%.4f',minimum);
niter = size(res,1)-1;
set(handles.min_txt,'String',num2str(minstr));
set(handles.niter_txt,'String',num2str(niter));


% add some additional data as a new field called numberOfErrors
handles.res = res;
handles.fun = fun;
handles.funforplot = funforplot;
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



function a_txt_Callback(hObject, eventdata, handles)
% hObject    handle to a_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_txt as text
%        str2double(get(hObject,'String')) returns contents of a_txt as a double


% --- Executes during object creation, after setting all properties.
function a_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoframing_checkbox.
function autoframing_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to autoframing_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoframing_checkbox

if get(hObject,'Value')
    set(handles.b_txt,'Enable','Off');
    set(handles.a_txt,'Enable','Off');
    set(handles.step_txt,'Enable','On');
    set(handles.x0_txt,'Enable','On');
    set(handles.gamma_txt,'Enable','On');    
else
    set(handles.b_txt,'Enable','On');
    set(handles.a_txt,'Enable','On'); 
    set(handles.step_txt,'Enable','Off');
    set(handles.x0_txt,'Enable','Off');
    set(handles.gamma_txt,'Enable','Off');      
end

function x0_txt_Callback(hObject, eventdata, handles)
% hObject    handle to x0_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0_txt as text
%        str2double(get(hObject,'String')) returns contents of x0_txt as a double


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
    
function []=print_res(res,fun,ax,methodtitle,var,strfun,xinf,xsup)
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

for j=2:1:(size(res,1)-1)
    
    scatter(res(1,1),res(1,3),80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',...
    'LineWidth',1.5);               %to plot

    scatter(res(1,2),res(1,4),80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',... 
    'LineWidth',1.5); 
    
    scatter(res(j,1),res(j,3),80,'MarkerEdgeColor','k',...
        'MarkerFaceColor','y',...
        'LineWidth',1.5);               %to plot
    scatter(res(j,2),res(j,4),80,'MarkerEdgeColor','k',...
        'MarkerFaceColor','y',... 
        'LineWidth',1.5);               %to plot
    
    pause(0.15);
end

scatter(res(end,1),res(end,3),80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'LineWidth',1.5);
scatter(res(end,2),res(end,4),80,'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'LineWidth',1.5);
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

print_res(res,funforplot,ax,methodtitle,strvar,strfun_complete,xinf,xsup)


% --- Executes on button press in figure_button.
function figure_button_Callback(hObject, eventdata, handles)
% hObject    handle to figure_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = figure(1);
h=axes;
xinf = str2num(get(handles.xlim_inf_txt,'String'));
xsup = str2num(get(handles.xlim_sup_txt,'String'));

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

print_res(res,funforplot,ax,methodtitle,strvar,strfun_complete,xinf,xsup)


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

%scatter(res(end,1),res(end,3),80,'MarkerEdgeColor','k',...
%    'MarkerFaceColor','g',...
%    'LineWidth',1.5);
%scatter(res(end,2),res(end,4),80,'MarkerEdgeColor','k',...
%    'MarkerFaceColor','g',...
%    'LineWidth',1.5);
hold off;


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%f = figure;
%h=axes;
%cleanfigure()

contents = get(handles.method,'String');
if strcmp(contents{get(handles.method,'Value')},'Golden Section')
%    helpimg = imshow('gold_section.png','Parent',h,'Border','tight');
    open('gold_section.pdf');
elseif strcmp(contents{get(handles.method,'Value')},'Fibonacci')
%    helpimg = imshow('fibonacci2.png','Parent',h,'Border','tight');
    open('fibonacci.pdf');
elseif strcmp(contents{get(handles.method,'Value')},'Brent')
%    helpimg = imshow('brent2.png','Parent',h,'Border','tight');
    open('brentFlow.pdf');
end
% set(gcf,'units','normalized','outerposition',[0 0 1 1])


% --- Executes on button press in help_framing_button.
function help_framing_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_framing_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('framing.pdf');
