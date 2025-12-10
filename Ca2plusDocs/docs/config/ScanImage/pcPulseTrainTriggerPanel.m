function varargout = pcPulseTrainTriggerPanel(varargin)

% global state
% PCPULSETRAINTRIGGERPANEL MATLAB code for pcPulseTrainTriggerPanel.fig
%      PCPULSETRAINTRIGGERPANEL, by itself, creates a new PCPULSETRAINTRIGGERPANEL or raises the existing
%      singleton*.
%
%      H = PCPULSETRAINTRIGGERPANEL returns the handle to a new PCPULSETRAINTRIGGERPANEL or the handle to
%      the existing singleton*.
%
%      PCPULSETRAINTRIGGERPANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCPULSETRAINTRIGGERPANEL.M with the given input arguments.
%
%      PCPULSETRAINTRIGGERPANEL('Property','Value',...) creates a new PCPULSETRAINTRIGGERPANEL or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcPulseTrainTriggerPanel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcPulseTrainTriggerPanel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcPulseTrainTriggerPanel

% Last Modified by GUIDE v2.5 21-Jun-2018 09:55:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcPulseTrainTriggerPanel_OpeningFcn, ...
                   'gui_OutputFcn',  @pcPulseTrainTriggerPanel_OutputFcn, ...
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

% --- Executes just before pcPulseTrainTriggerPanel is made visible.
function pcPulseTrainTriggerPanel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcPulseTrainTriggerPanel (see VARARGIN)

% Choose default command line output for pcPulseTrainTriggerPanel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

h = gcf;
assignin('base', 'PulseTrainHandle', h)
% movegui(h, 'southeast')
movegui(h, [-1 45])

initialize_gui(hObject, handles, false);

% UIWAIT makes pcPulseTrainTriggerPanel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcPulseTrainTriggerPanel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

%default to on:
set(handles.ephusTriggerButton, 'Value', 1)

%default params
handles.PulseTrain.ISI = 0;
handles.PulseTrain.PulseNo  = 1;
handles.PulseTrain.PulseWidthHi = 0.1;
handles.PulseTrain.stimDelay = 4;

handles.PulseTrain.PulseWidthLo = handles.PulseTrain.ISI-handles.PulseTrain.PulseWidthHi;
handles.PulseTrain.TotalTime = handles.PulseTrain.stimDelay+...
    handles.PulseTrain.PulseNo*(handles.PulseTrain.PulseWidthHi+...
    handles.PulseTrain.PulseWidthLo);

set(handles.ISItg, 'String', handles.PulseTrain.ISI);
set(handles.totalPulsesTg, 'String', handles.PulseTrain.PulseNo);

set(handles.PWHtg, 'String', handles.PulseTrain.PulseWidthHi);

set(handles.PWLtg, 'String', handles.PulseTrain.PulseWidthLo);
set(handles.TotalTimeTg, 'String', handles.PulseTrain.TotalTime);
set(handles.StimDelayTg, 'String', handles.PulseTrain.stimDelay);
% Update handles structure
guidata(handles.figure1, handles);

function ISI_Callback(hObject, eventdata, handles)
% hObject    handle to ISItg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ISItg as text
%        str2double(get(hObject,'String')) returns contents of ISItg as a double
ISI = str2double(get(hObject, 'String'));
if isnan(ISI)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

handles = guidata(hObject);

if handles.PulseTrain.PulseNo>1 && ISI==0
    set(handles.ISItg,'BackgroundColor',[1 0 0])
else
    set(handles.ISItg,'BackgroundColor',[0.3922 0.8314 0.0745])
end

% Save the new ISItg value
handles.PulseTrain.ISI = ISI;

handles.PulseTrain.PulseWidthLo = handles.PulseTrain.ISI-handles.PulseTrain.PulseWidthHi;
handles.PulseTrain.TotalTime = handles.PulseTrain.stimDelay+...
    handles.PulseTrain.PulseNo*(handles.PulseTrain.PulseWidthHi+...
    handles.PulseTrain.PulseWidthLo);

set(handles.PWLtg, 'String', handles.PulseTrain.PulseWidthLo);
set(handles.TotalTimeTg, 'String', handles.PulseTrain.TotalTime);

guidata(hObject,handles)


%[0.3922 0.8314 0.0745] green

function totalPulses_Callback(hObject, eventdata, handles)
% hObject    handle to totalPulsesTg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

PulseNo = str2double(get(hObject, 'String'));
if isnan(PulseNo)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

if PulseNo>1 && handles.PulseTrain.ISI==0
    set(handles.ISItg,'BackgroundColor',[1 0 0]) %red
else
    set(handles.ISItg,'BackgroundColor',[0.3922 0.8314 0.0745]) %green
end

% Save the new PulseNumber value
handles.PulseTrain.PulseNo = PulseNo;
if PulseNo==1
    set(handles.ISItg,'String',0)
    handles.PulseTrain.ISI = 0;
    set(handles.PWLtg, 'String',0);
    handles.PulseTrain.PulseWidthLo = 0;
else
    set(handles.PWLtg, 'String', handles.PulseTrain.PulseWidthLo);
end

handles.PulseTrain.TotalTime = handles.PulseTrain.stimDelay+...
    handles.PulseTrain.PulseNo*(handles.PulseTrain.PulseWidthHi+...
    handles.PulseTrain.PulseWidthLo);
set(handles.TotalTimeTg, 'String', handles.PulseTrain.TotalTime);

guidata(hObject,handles)


function PulseWidthHigh_Callback(hObject, eventdata, handles)
% hObject    handle to PWHtg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
set(handles.PWHtg, 'String', handles.PulseTrain.PulseWidthHi);
disp('Can Not Edit')


function PulseWidthLow_Callback(hObject, eventdata, handles)
% hObject    handle to PWLtg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
set(handles.PWLtg, 'String', handles.PulseTrain.PulseWidthLo);
disp('Can Not Edit')


function TotalTime_Callback(hObject, eventdata, handles)
% hObject    handle to TotalTimeTg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
set(handles.TotalTimeTg, 'String', handles.PulseTrain.TotalTime);
disp('Can Not Edit')
cl

% --- Executes on button press in ephusTriggerButton.
function ephusTriggerButton_Callback(hObject, eventdata, handles)
% hObject    handle to ephusTriggerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ephusTriggerButton
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Ephus Trigger Enabled');
else
	display('Ephus Trigger Disabled');
end



function stimDelay_Callback(hObject, eventdata, handles)
% hObject    handle to StimDelayTg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stimDelay = str2double(get(hObject, 'String'));
if isnan(stimDelay)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

handles = guidata(hObject);
handles.PulseTrain.stimDelay = stimDelay;
handles.PulseTrain.TotalTime = handles.PulseTrain.stimDelay+...
    handles.PulseTrain.PulseNo*(handles.PulseTrain.PulseWidthHi+...
    handles.PulseTrain.PulseWidthLo);

set(handles.StimDelayTg, 'String', handles.PulseTrain.stimDelay);
set(handles.TotalTimeTg, 'String', handles.PulseTrain.TotalTime);

guidata(hObject,handles)
