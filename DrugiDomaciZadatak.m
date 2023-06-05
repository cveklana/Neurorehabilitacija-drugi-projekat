function varargout = DrugiDomaciZadatak(varargin)
% DRUGIDOMACIZADATAK MATLAB code for DrugiDomaciZadatak.fig
%      DRUGIDOMACIZADATAK, by itself, creates a new DRUGIDOMACIZADATAK or raises the existing
%      singleton*.
%
%      H = DRUGIDOMACIZADATAK returns the handle to a new DRUGIDOMACIZADATAK or the handle to
%      the existing singleton*.
%
%      DRUGIDOMACIZADATAK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRUGIDOMACIZADATAK.M with the given input arguments.
%
%      DRUGIDOMACIZADATAK('Property','Value',...) creates a new DRUGIDOMACIZADATAK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DrugiDomaciZadatak_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DrugiDomaciZadatak_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DrugiDomaciZadatak

% Last Modified by GUIDE v2.5 05-Apr-2023 21:23:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DrugiDomaciZadatak_OpeningFcn, ...
                   'gui_OutputFcn',  @DrugiDomaciZadatak_OutputFcn, ...
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


% --- Executes just before DrugiDomaciZadatak is made visible.
function DrugiDomaciZadatak_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DrugiDomaciZadatak (see VARARGIN)



%U OpeningFcn podešavamo trajanje prikaza i kanal sa kojeg se
%prikaz vrši za slučaj da korisnik po pokretanju aplikacije odmah
%pritisne START


kanali=strings(1,24);
for i=1:24
    tmp = strcat('Kanal',{' '},num2str(i));
    kanali(i)=tmp;
end
set(handles.kanali111,'String',kanali)
handles.kanali=kanali;
% Choose default command line output for DrugiDomaciZadatak
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DrugiDomaciZadatak wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DrugiDomaciZadatak_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton_start (see GCBO)
global uslov
global kanal
Vref = 4.5;
gain = 24;
global port


%preuzimanje vremena trajanja sa polja edit_T
vreme_t= get(handles.edit_T, 'String');
vreme_trajanja = str2double(vreme_t);
if isnan(vreme_t)
    msgbox('Polje za unos je prazno')
    return
end

tmp = instrfind;
if(size(tmp, 1) > 0)
    fclose(tmp);
    delete(tmp);
end

port = serial('COM5');

%otvaranje PORT2
set(port, 'BaudRate', 921600, 'DataBits', 8, 'StopBits', 1, 'FlowControl','Hardware');
port.InputBufferSize=5000;
fopen(port)
disp('connected');

%slanje komandi Normal i on
%flushinput(port)
fwrite(port, ['>SC;' 255 255 255 '<']);
char(fread(port,4))
fwrite(port, '>NORMAL<');
char(fread(port,4))
fwrite(port, '>ON<');
char(fread(port,4))



%frekv odabiranja
Fs=160;
t=0:1/160:vreme_trajanja-1/160;
%x_iscrt=zeros(1,800);


%Preuzimanje vrednosti sa radiobuttona za kanale

%{
CH(1)=get(handles.radiobutton1,'Value');
CH(2)=get(handles.radiobutton2,'Value');
CH(3)=get(handles.radiobutton3,'Value');
CH(4)=get(handles.radiobutton4,'Value');
CH(5)=get(handles.radiobutton5,'Value');
CH(6)=get(handles.radiobutton6,'Value');
CH(7)=get(handles.radiobutton7,'Value');
CH(8)=get(handles.radiobutton8,'Value');
CH(9)=get(handles.radiobutton9,'Value');
CH(10)=get(handles.radiobutton10,'Value');
CH(11)=get(handles.radiobutton11,'Value');
CH(12)=get(handles.radiobutton12,'Value');
CH(13)=get(handles.radiobutton13,'Value');
CH(14)=get(handles.radiobutton14,'Value');
CH(15)=get(handles.radiobutton15,'Value');
CH(16)=get(handles.radiobutton16,'Value');
CH(17)=get(handles.radiobutton17,'Value');
CH(18)=get(handles.radiobutton18,'Value');
CH(19)=get(handles.radiobutton19,'Value');
CH(20)=get(handles.radiobutton20,'Value');
CH(21)=get(handles.radiobutton21,'Value');
CH(22)=get(handles.radiobutton22,'Value');
CH(23)=get(handles.radiobutton23,'Value');
CH(24)=get(handles.radiobutton24,'Value');

%}

%generisanje vektora za prikazivanje
vektor_prikaza = zeros(1,800);
klase_prikaz = zeros(1,800);


%for i = 1:24
 %   if CH(i) == 1
  %      kanal = CH(i);
   % end
%end
kanal = get(handles.kanali111, 'Value');

pause(1)
%kreiranje prostora za kanal
%kanal = [];
uslov=1;
while(uslov)
    broj_bajtova = port.BytesAvailable
    if broj_bajtova>0
        podaci = fread(port, broj_bajtova);     
       % pronaci pocetke
       
        ind_start = find(podaci == 62);
        ind_end = find(podaci == 60);
        pravi_poceci = [];
        pravi_krajevi = [];

       % 2 filtriranje - da li su ti actually poceci

          for i = 1:length(ind_end)
            for j = 1:length(ind_start)
                %proveravam da li je 83 bajta izmedju
                duzina = ind_end(i) - ind_start(j);
                if duzina == 82
                    %natrpavam u prave pocetke, vidim da ih ima 59
                    pravi_poceci = [pravi_poceci ind_start(j)];
                    pravi_krajevi = [pravi_krajevi ind_end(i)];
                end
            end
        end


       % 3 CH1 , sad ovde pomocu petlje iz paketa izvuci prvi kanal
       
       for i= 1:length(pravi_poceci)
                prvi_bajt = podaci(i+(kanal-1)*3+1); %i + (CHnum - 1)*3 +, detekcija bajta
                drugi_bajt = podaci(i+1+(kanal-1)*3+2);
                treci_bajt = podaci(i+2+(kanal-1)*3+3);
                vrednost_kanala = prvi_bajt*2^16 + drugi_bajt*2^8 + treci_bajt;
                if vrednost_kanala > ( 2^23-1)
                    vrednost_kanala = vrednost_kanala - 2^24; %n = 24
                end
                scaleFactor = (Vref / (2^23 - 1)) / gain;
                to_uV = 1e+6;
                vrednost_kanala = vrednost_kanala * scaleFactor * to_uV;
                vrednosti_klase= podaci(pravi_poceci(i)+74)*2^8+podaci(pravi_poceci(i)+75);

       

            for j=2:800 %pri prebacivanju vrednosti kanala potrebno je pauza da postoji           
                 vektor_prikaza(j-1)=vektor_prikaza(j);
                 klase_prikaz(j-1)=klase_prikaz(j);
                 
                 novi_kanal=get(handles.kanali111, 'Value'); 
                 if novi_kanal~=kanal
                     vektor_prikaza=zeros(1,length(t));
                     klase_prikaz=zeros(1,length(t));
                 end
                 kanal=novi_kanal;
            end

       % 4 upaciti u vektor za prikaz ovo
        vektor_prikaza(length(t)) = vrednost_kanala;
        klase_prikaz(length(t)) = vrednosti_klase;
       end 


%prikaz signala
        axes(handles.axes1)
        plot(t,vektor_prikaza)  
        ylim([-300 300])
        title(sprintf('EEG'))
        xlabel(sprintf('Vreme[s]'))
        ylabel(sprintf('Signal[uV]'))
        drawnow

        axes(handles.axes2)
        plot(t, klase_prikaz) 
        ylim([0 3])
        xlabel(sprintf('Vreme[s]'))
        ylabel(sprintf('Klasa'))


        drawnow
              
    
    end
  
end

% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_STOP.
function pushbutton_STOP_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_STOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global uslov
global port
uslov = 0;
fwrite(port,'>OFF<');
fclose(port);
clear port
disp('disconnected')
handles.output = hObject;
guidata(hObject, handles);



function edit_T_Callback(hObject, eventdata, handles)
% hObject    handle to edit_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_T as text
%        str2double(get(hObject,'String')) returns contents of edit_T as a double


% --- Executes during object creation, after setting all properties.
function edit_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in kanali111.
function kanali111_Callback(hObject, eventdata, handles)
% hObject    handle to kanali111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kanali111 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kanali111


% --- Executes during object creation, after setting all properties.
function kanali111_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kanali111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
