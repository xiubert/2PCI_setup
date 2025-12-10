function testusrfcn(varargin)
%determine if want with (randn approach) or without replacement (randperm)   
% randn approach:  round((length(pulselist)-1).*rand(1) + 1)
% randperm approach: must assign variable to workspace and select next from
%randperm list

%you can view available variables to set in progmanagerglobal structure or
%by getting figure handle of program (getFigHandle(progmanager,
%stimulator)) then the guidata from that:  guidata(handle)

%ASSUMES SOUND OUTPUT IS ON CHANNEL 1

global progmanagerglobal

disp('Randomly selecting a pulse from the pulse set')

if ispc
    slash = '\';
else
    slash = '/';
end
    
    disp('Changing pulse to random choice within pulse set')
%     pulsedir = getLocal(progmanager,stimulator,'pulseSetDir');
%     pulseset = getLocal(progmanager,stimulator,'pulseSetName');
%     curpulse = getLocal(progmanager,stimulator,'pulseName');

fighandleobj = progmanagerglobal.programs.stimulator.stimulator.variables.hObject;
    
    [pulsedir, pulseset, curpulse, pulsenamearray, pulseparams] = getLocalBatch(progmanager,fighandleobj,'pulseSetDir', 'pulseSetName', 'pulseName', 'pulseNameArray','pulseParameters');
    

    
    
    pulselist = cellstr(ls([pulsedir slash pulseset slash '*.signal']));
    pulselist = strrep(pulselist,'.signal','');
    selectedpulse = pulselist{round((length(pulselist)-1).*rand(1) + 1)};
    
    load([pulsedir slash pulseset slash selectedpulse '.signal'],'-mat')
    pulselen = get(signal,'length'); %in seconds
    pulsesamplerate = get(signal,'sampleRate'); %in Hz
    
    pulseparams{1}.signal = getdata(signal,pulselen); %assumes sound output on channel 1
    pulseparams{1}.length = pulselen;
    pulseparams{1}.sampleRate = pulsesamplerate;
    pulseparams{1}.name = selectedpulse;
    pulsenamearray{1} = selectedpulse;
    
        setLocal(progmanager,stimulator,'pulseName',selectedpulse);
%     setLocalBatch(progmanager,fighandleobj, 'pulseName',selectedpulse,'pulseParameters',pulseparams,'pulseNameArray',pulsenamearray);

    %must initiate pulseName_Callback (function callback that occurs when
    %new pulse is selected) to ensure settings are updated and correct new
    %pulse is loaded.
    fcnob = getFunctionHandle(progmanager, stimulator);
    feval(fcnob,'pulseName_Callback', fighandleobj, [], fighandleobj)
    
    
    
    %for testing
%     setLocal(progmanager,stimulator,'extraGain',round((1000-1).*rand(1) + 1));
    %must also change:
    %progmanagerglobal.programs.stimulator.stimulator.variables.extraGainArray(1)
    %assuming sound output is on channel 1
end