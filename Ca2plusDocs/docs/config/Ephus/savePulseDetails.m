function savePulseDetails(varargin)
%ASSUMES SAVING ACTIVE CHANNEL (DOES NOT WORK WITH MULTIPLE ACTIVE CHANNELS)

global progmanagerglobal

disp('Saving Pulse Details to xsg save location...')

stimfighandleobj = progmanagerglobal.programs.stimulator.stimulator.variables.hObject;
xsgfighandleobj = progmanagerglobal.programs.xsg.xsg.variables.hObject;

[pulsedir, pulsesetArr, pulseArr, pulseActive, gainArr] = getLocalBatch(progmanager,stimfighandleobj,'pulseSetDir', 'pulseSetNameArray', 'pulseNameArray', 'stimOnArray', 'extraGainArray');
[savDir, initials, experimentNo, setID, acquisitionNo] = getLocalBatch(progmanager,xsgfighandleobj,'directory','initials','experimentNumber','setID','acquisitionNumber');

%finds active pulse; if simply query 'pulseName' etc. it grabs the currently
%shown pulse in the gui
pulseset = pulsesetArr{logical(pulseActive)};
pulsename = pulseArr{logical(pulseActive)};
gain = gainArr(logical(pulseActive));

%this looks for the most recent tif file in the xsg save directory and
%saves mat file containing pulse files using filename appended w/ tif file
%name
S = dir(fullfile(savDir,[initials experimentNo]));

if any(~cellfun(@isempty, strfind({S.name},'.tif')))
    S = S(~cellfun(@isempty, strfind({S.name},'.tif')));
    [~,sortS] = sort({S.date});
    
    pulseFileName = strrep(S(sortS(end)).name,'.tif','_Pulses.mat');
    paramsFileName = strrep(S(sortS(end)).name,'.tif','_PulseParams.mat');    
else
    %file saving not tied to scanimage in this case
    fName = [initials experimentNo setID acquisitionNo];
    pulseFileName = [fName '_Pulses.mat'];
    paramsFileName = [fName '_PulseParams.mat'];
    
    if exist(pulseFileName, 'file') == 2
        fNo = sum(~cellfun(@isempty, ...
            cellstr(ls([savDir initials experimentNo filesep fName '_Pulses*']))));
        pulseFileName = strrep(pulseFileName,'.mat',['_' num2str(fNo) '.mat']);
        paramsFileName = strrep(paramsFileName,'.mat',['_' num2str(fNo) '.mat']);
    end
    disp('WARNING: no .tif files found in this directory...')
    disp(['Is Scanimage set to save to: ' savDir initials experimentNo filesep '?'])
end

if exist(fullfile(savDir,[initials experimentNo],pulseFileName), 'file') == 2
    load(fullfile(savDir,[initials experimentNo],pulseFileName))
    npulse = length(pulse);
    pulse(npulse+1).pulsedir = pulsedir;
    pulse(npulse+1).pulseset = pulseset;
    pulse(npulse+1).pulsename = pulsename;
    pulse(npulse+1).gain = gain;
    pulse(npulse+1).traceAcquiredTime = clock;
    pulse(npulse+1).path = fullfile(pulsedir,pulseset,[pulsename '.signal']);
    pulse(npulse+1).curXSG = fullfile(savDir,[initials experimentNo],[initials experimentNo setID acquisitionNo '.xsg']);
else
    pulse.pulsedir = pulsedir;
    pulse.pulseset = pulseset;
    pulse.pulsename = pulsename;
    pulse.gain = gain;
    pulse.traceAcquiredTime = clock;
    pulse.path = fullfile(pulsedir,pulseset,[pulsename '.signal']);
    pulse.curXSG = fullfile(savDir,[initials experimentNo],[initials experimentNo setID acquisitionNo '.xsg']);
end

if exist(fullfile(savDir,[initials experimentNo],paramsFileName), 'file') == 2
    params = load(fullfile(savDir,[initials experimentNo],paramsFileName));
    save(fullfile(savDir,[initials experimentNo],pulseFileName),'params','pulse');
else
    save(fullfile(savDir,[initials experimentNo],paramsFileName),'pulse')
end

end