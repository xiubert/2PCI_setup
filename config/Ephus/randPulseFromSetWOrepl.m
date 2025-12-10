function randPulseFromSetWOrepl(varargin)
%This function chooses a random pulse from the current set and updates the
%pulse to that new random selection

%determine if want with (randn approach) or without replacement (randperm)
% randn approach:  round((length(pulselist)-1).*rand(1) + 1)

% randperm approach: must assign variable to workspace and select next from
%randperm list (CURRENT)

%you can view available variables to set in progmanagerglobal structure or
%by getting figure handle of program (getFigHandle(progmanager,
%stimulator)) then the guidata from that:  guidata(handle)

%ASSUMES SOUND OUTPUT IS ON CHANNEL 1

global progmanagerglobal

disp('Changing pulse to a randomly selected one from the pulse set... (without replacement)')

fighandleobj = progmanagerglobal.programs.stimulator.stimulator.variables.hObject;

[pulsedir, pulseSetArr, pulseArr, gainArr, pulseActive] = getLocalBatch(progmanager,fighandleobj,'pulseSetDir', 'pulseSetNameArray', 'pulseNameArray', 'extraGainArray', 'stimOnArray');

%finds active pulse; if simply query 'pulseName' etc. it grabs the currently
%shown pulse in the gui
activeChannel = find(pulseActive);
pulseset = pulseSetArr{logical(pulseActive)};
pulseName = pulseArr{logical(pulseActive)};
extraGain = gainArr(logical(pulseActive));

pulselist = cellstr(ls(fullfile(pulsedir,pulseset,'*.signal')));
pulselist = strrep(pulselist,'.signal','');

ise = evalin( 'base', 'exist(''randPulseSetLoc'',''var'') == 1' );
if ise
    randPulseSetLoc = evalin('base','randPulseSetLoc');
    
    %ensure current stimulator pulse set is the same, if not generate new
    %set
    if ~isequal(pulselist,randPulseSetLoc.pulseList)
        disp('Current stimulator pulse list different from existing set.  Generating new random set...')
        randPulseSetLoc.pulseList = pulselist;
        randPulseSetLoc.order = randperm(length(pulselist));
        %remove current pulse from the upcoming random set until going through
        %the whole set
        curPulseLoc = strmatch(pulseName,pulselist,'exact');
        randPulseSetLoc.order = randPulseSetLoc.order(randPulseSetLoc.order~=curPulseLoc);
        
        randPulseSetLoc.pos = 1;
        selectedpulse = pulselist{randPulseSetLoc.order(randPulseSetLoc.pos)}; %select random pulse from list of current pulse set
        
    else
        randPulseSetLoc.pos = randPulseSetLoc.pos+1;
        
        if randPulseSetLoc.pos<=length(randPulseSetLoc.order)
            selectedpulse = pulselist{randPulseSetLoc.order(randPulseSetLoc.pos)};
            
        else
            disp('Last pulse in random set, generating new random set order...')
            randPulseSetLoc.order = randperm(length(randPulseSetLoc.pulseList));
            randPulseSetLoc.pos = 1;
            selectedpulse = pulselist{randPulseSetLoc.order(randPulseSetLoc.pos)}; %select random pulse from list of current pulse set
        end        
    end
    
else
    disp('Generating random pulse set...')
    randPulseSetLoc.pulseList = pulselist;
    randPulseSetLoc.order = randperm(length(pulselist));
    
    %remove current pulse from the upcoming random set until going through
    %the whole set
    curPulseLoc = strmatch(pulseName,pulselist,'exact');
    randPulseSetLoc.order = randPulseSetLoc.order(randPulseSetLoc.order~=curPulseLoc);
    
    randPulseSetLoc.pos = 1;
    selectedpulse = pulselist{randPulseSetLoc.order(randPulseSetLoc.pos)}; %select random pulse from list of current pulse set
end

fprintf(['Upcoming Pulse Name:' '\n' selectedpulse '\n'])
disp(['Upcoming location in random set: ' num2str(randPulseSetLoc.pos) ' of ' num2str(length(randPulseSetLoc.order))])

assignin('base','randPulseSetLoc',randPulseSetLoc)

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

% activeChannel should be a scalar. If multiple channels have 'Stim On'
% checked, this will cause an error. Must isolate to 'Sound output'.
% Sound output should always be the first channel in the startup config: ephus_init_matlab2013b_32bit_250kHz_Camera_20250903.m
stim_selectChannel(fighandleobj,1) %if don't do this and not on correct channel, will get error for setLocal
% setLocal(progmanager,stimulator,'pulseName',selectedpulse); %if calling pulseName_Callback should only need to change this variable
setLocalBatch(progmanager,stimulator,'pulseSet',pulseset,'pulseName',selectedpulse,'extraGain',1)

%must initiate pulseName_Callback (function callback that occurs when
%new pulse is selected) to ensure settings are updated and correct new
%pulse is loaded.
fcnob = getFunctionHandle(progmanager, stimulator);
feval(fcnob,'pulseName_Callback', fighandleobj, [], fighandleobj)

%vestigial
%ENSURE GAIN IS SET TO 1
% if extraGain ~= 1
%     disp('WARNING:  Gain was not set to 1. It likely should be. Doing so now automatically.')
%     setGain = 1;
%     setLocal(progmanager,stimulator,'extraGain',setGain);
%     feval(fcnob,'extraGain_Callback', fighandleobj, [], fighandleobj)
% end
if extraGain ~= 1
    disp('WARNING:  Gain was not set to 1. It likely should be. Doing so now automatically.')
    feval(fcnob,'extraGain_Callback', fighandleobj, [], fighandleobj)
end


end