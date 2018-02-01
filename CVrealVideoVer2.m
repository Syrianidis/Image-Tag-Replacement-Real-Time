function CVrealVideoVer2()

% Define frame rate
NumberFrameDisplayPerSecond=10;
imWrp1=imread('tag4.jpg');
imRep=imread('Lenna.jpg');

imWrp1=imresize(imWrp1,.5);
imRep=imresize(imRep,.25);

% Open figure
hFigure=figure(1);

% Set-up webcam video input
try
   % For windows
   vid = videoinput('winvideo', 1);
catch
   try
      % For macs.
      vid = videoinput('macvideo', 1);
   catch
      errordlg('No webcam available');
   end
end

% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',1);
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
% Get a grayscale image
set(vid,'ReturnedColorSpace','RGB');
triggerconfig(vid, 'Manual');

% set up timer object
TimerData=timer('TimerFcn', {@FrameRateDisplayTest,vid,imWrp1,imRep},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');

% Start video and timer object
start(vid);
start(TimerData);

% We go on until the figure is closed
uiwait(hFigure);

% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
clear functions;

% This function is called by the timer to display one frame of the figure

function FrameRateDisplayTest(obj, event,vid, imWrp1,imRep)
persistent IM;
% persistent handlesRaw;
% persistent handlesPlot;
trigger(vid);
IM=getdata(vid,1,'uint8');

% if isempty(handlesRaw)
   % if first execution, we create the figure objects
   subplot(1,2,1);
%    handlesRaw=imshow(IM);
   imshow(IM);
   title('Real Time Image');

   % Plot first value
%    Values=mean(IM(:));
   subplot(1,2,2);
%    handlesPlot=BDDoGThres(IM,.4,.9,1/10);
   imImpose(imresize(IM,.5),imWrp1,imRep,'SURF');
   title('Imposing Images on Tag')
% else
%    % We only update what is needed
%    set(handlesRaw,'CData',IM);
%    Value=mean(IM(:));
%    OldValues=get(handlesPlot,'YData');
%    set(handlesPlot,'YData',[OldValues Value]);
% end