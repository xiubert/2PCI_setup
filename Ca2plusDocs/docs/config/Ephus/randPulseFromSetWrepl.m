function randPulseFromSetWrepl(varargin)
%This function chooses a random pulse from the current set and updates the
%pulse to that new random selection

%determine if want with (randn approach) or without replacement (randperm)
% randn approach:  round((length(pulselist)-1).*rand(1) + 1) (CURRENT)

% randperm approach: must assign variable to workspace and select next from
%randperm list

%you can view available variables to set in progmanagerglobal structure or
%by getting figure handle of program (getFigHandle(progmanager,
%stimulator)) then the guidata from that:  guidata(handle)

%ASSUMES SOUND OUTPUT IS ON CHANNEL 1

global progmanagerglobal

disp('Changing pulse to a randomly selected one from the pulse set... (with replacement)')

%     pulsedir = getLocal(progmanager,stimulator,'pulseSetDir'); %if
%     deciding to get each individually
%     pulseset = getLocal(progmanager,stimulator,'pulseSetName');
%     curpulse = getLocal(progmanager,stimulator,'pulseName');

fighandleobj = progmanagerglobal.programs.stimulator.stimulator.variables.hObject;


[pulsedir, pulseSetArr, gainArr, pulseActive] = getLocalBatch(progmanager,fighandleobj,'pulseSetDir', 'pulseSetNameArray', 'extraGainArray', 'stimOnArray');

%finds active pulse; if simply query 'pulseName' etc. it grabs the currently
%shown pulse in the gui
activeChannel = find(pulseActive);
pulseset = pulseSetArr{logical(pulseActive)};
extraGain = gainArr(logical(pulseActive));

pulselist = cellstr(ls(fullfile(pulsedir,pulseset,'*.signal')));
pulselist = strrep(pulselist,'.signal','');

selectedpulse = pulselist{round((length(pulselist)-1).*rand(1) + 1)}; %select random pulse from list of current pulse set

%______________________________________________
%This should all happen behind the scenes when pulseName_Callback is
%called:

%     load([pulsedir filesep pulseset filesep selectedpulse '.signal'],'-mat')
%     pulselen = get(signal,'length'); %in seconds
%     pulsesamplerate = get(signal,'sampleRate'); %in Hz
%
%     pulseparams{1}.signal = getdata(signal,pulselen); %assumes sound output on channel 1
%     pulseparams{1}.length = pulselen;
%     pulseparams{1}.sampleRate = pulsesamplerate;
%     pulseparams{1}.name = selectedpulse;
%     pulsenamearray{1} = selectedpulse;
%     setLocalBatch(progmanager,fighandleobj, 'pulseName',selectedpulse,'pulseParameters',pulseparams,'pulseNameArray',pulsenamearray);
%______________________________________________

stim_selectChannel(fighandleobj,activeChannel) %if don't do this and not on correct channel, will get error for setLocal
setLocalBatch(progmanager,stimulator,'pulseSet',pulseset,'pulseName',selectedpulse,'extraGain',1)
% setLocal(progmanager,stimulator,'pulseName',selectedpulse); %if calling pulseName_Callback should only need to change this variable
fprintf(['Upcoming random pulse is:' '\n' selectedpulse '\n'])

%must initiate pulseName_Callback (function callback that occurs when
%new pulse is selected) to ensure settings are updated and correct new
%pulse is loaded.
fcnob = getFunctionHandle(progmanager, stimulator);
feval(fcnob,'pulseName_Callback', fighandleobj, [], fighandleobj)

%ENSURE GAIN IS SET TO 1
if extraGain ~= 1
    disp('WARNING:  Gain was not set to 1. It likely should be. Doing so now automatically.')
%     setGain = 1;
%     setLocal(progmanager,stimulator,'extraGain',setGain);
    feval(fcnob,'extraGain_Callback', fighandleobj, [], fighandleobj)
end

%for testing / for setting gain | would also need to call
%extraGain_Callback
%Tip invoke guide and have a look in stimulator.fig for callbacks
%associated with the gui

%     setLocal(progmanager,stimulator,'extraGain',round((1000-1).*rand(1) + 1));
%must also change:
%progmanagerglobal.programs.stimulator.stimulator.variables.extraGainArray(1)
%assuming sound output is on channel 1
end