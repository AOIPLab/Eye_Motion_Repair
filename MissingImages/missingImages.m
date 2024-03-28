function varargout = missingImages(varargin)
% MISSINGIMAGES MATLAB code for missingImages.fig
%      MISSINGIMAGES, by itself, creates a new MISSINGIMAGES or raises the existing
%      singleton*.
%
%      H = MISSINGIMAGES returns the handle to a new MISSINGIMAGES or the handle to
%      the existing singleton*.
%
%      MISSINGIMAGES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MISSINGIMAGES.M with the given input arguments.
%
%      MISSINGIMAGES('Property','Value',...) creates a new MISSINGIMAGES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before missingImages_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to missingImages_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help missingImages

% Last Modified by GUIDE v2.5 08-Sep-2016 19:47:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @missingImages_OpeningFcn, ...
                   'gui_OutputFcn',  @missingImages_OutputFcn, ...
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


% --- Executes just before missingImages is made visible.
function missingImages_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to missingImages (see VARARGIN)

% Choose default command line output for missingImages
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes missingImages wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = missingImages_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_videos.
function browse_videos_Callback(hObject, eventdata, handles)
% hObject    handle to browse_videos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.tifspath,'string')) && isdir(get(handles.tifspath,'string'))
    set(handles.videopath,'string',uigetdir(get(handles.tifspath,'string'),'Select video directory'));
else
    set(handles.videopath,'string',uigetdir('.','Select video directory'));
end
guidata(hObject, handles);
if isdir(get(handles.tifspath,'string'))
    set(handles.wait_notification,'string','Wait...');
    findMissingImages(hObject, handles, get(handles.videopath,'string'), get(handles.tifspath,'string'));
end

% --- Executes on button press in browse_tifs.
function browse_tifs_Callback(hObject, eventdata, handles)
% hObject    handle to browse_tifs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.videopath,'string')) && isdir(get(handles.videopath,'string'))
    set(handles.tifspath,'string',uigetdir(get(handles.videopath,'string'),'Select tifs directory'));
else
    set(handles.tifspath,'string',uigetdir('.','Select tifs directory'));
end
guidata(hObject, handles);
if isdir(get(handles.videopath,'string'))
    set(handles.wait_notification,'string','Wait...');
    findMissingImages(hObject, handles, get(handles.videopath,'string'), get(handles.tifspath,'string'));
end

function findMissingImages(hObject, handles, vidpath, tifpath)
% Get video files and tif files
vidfiles = dir(fullfile(vidpath,'*.avi'));
tiffiles = dir(fullfile(tifpath,'*.tif'));

% Extract video numbers
vidnums = cell(numel(vidfiles),1);
for i=1:numel(vidfiles)
    if isempty(strfind(vidfiles(i).name,'confocal'))
        continue;
    end
    nameparts = strsplit(vidfiles(i).name,'.');
    nameparts = strsplit(nameparts{1},'_');
    vidnums{i} = nameparts{find(strcmp(nameparts,'confocal'))+1};
end
vidnums(cellfun(@isempty, vidnums)) = [];

% Extract video numbers from tifs
tifnums = cell(numel(tiffiles),1);
for i=1:numel(tiffiles)
    if isempty(strfind(tiffiles(i).name,'confocal'))
        continue;
    end
    nameparts = strsplit(tiffiles(i).name,'.');
    nameparts = strsplit(nameparts{1},'_');
    tifnums{i} = nameparts{find(strcmp(nameparts,'confocal'))+1};
end
tifnums(cellfun(@isempty, tifnums)) = [];
tifnums = unique(tifnums);

missingImages = cell(numel(vidnums),1);
for i=1:numel(vidnums)
    if ~any(strcmp(vidnums{i},tifnums))
        missingImages{i} = vidnums{i};
    end
end
missingImages(cellfun(@isempty, missingImages)) = [];
if ~isempty(missingImages)
    set(handles.missing_list,'enable','on');
    set(handles.missing_list,'string',missingImages);
    set(handles.wait_notification,'string','Videos without a corresponding image');
else
    set(handles.wait_notification,'string','No missing images');
end

% --- Executes on selection change in missing_list.
function missing_list_Callback(hObject, eventdata, handles)
% hObject    handle to missing_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns missing_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from missing_list


% --- Executes during object creation, after setting all properties.
function missing_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to missing_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end