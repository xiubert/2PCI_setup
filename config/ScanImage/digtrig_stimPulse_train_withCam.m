function digtrig_stimPulse_train(source,event,varargin)

if strcmp(source.hSI.acqState,'grab') && source.hSI.hStackManager.framesPerSlice ~= source.hSI.hScan2D.logFramesPerFile
    disp('######################################################################################')
    disp('###################################### LOOK HERE #####################################')
    disp('######################################################################################')

    error('Lower frames per tif file than total frames, will end up with multiple tifs for same acquisition')
end

%CAMERA IS TRIGGERED 2 SECONDS BEFORE STIM IS TRIGGERED:
% camNiTrigDelay = stimDelay - 2;

% TESTING:
% function digtrig_stimPulse_train(varargin)
% function digtrig_stimPulse_train(eventName, eventData, stimDelay)
% assignin('base','argsIn',varargin)

% disp(source.hSI.extTrigEnable)
% disp(source.hSI.hScan2D.frameCounter)
% disp(source.hSI.frameCounterForDisplay)

% disp(event.EventName)
% disp(source.hSI)
% disp(source.hSI.hScan2D.logFilePath)
% disp(source.hSI.hScan2D.logFileStem)
% disp(source.hSI.hStackManager.framesPerSlice)
% disp(source.hSI.hRoiManager.scanFrameRate)
% disp(source.hSI.hStackManager.framesPerSlice)
% disp(source.hSI.hScan2D.logFramesPerFile)

% Basically this function calls a counter task on a selected NI DAQ board
% and counter output (CO) channel (in other words: a channel that supports CO)
% that results in +5V pulses at some defined initial delay and defined
% Hi and Lo pulse width time. These pulses are used to then trigger other
% events with some frequency defined by the pulse Hi and Lo time.

% For the sound stim trigger to ephus, channel 1 on Dev1 corresponds
% to PFI13 on BNC-2090A.  PFI13 is wire connected to USER2, which is BNC
% connected to PFI0 on Dev2 (USB-6229). PFI0 is set as a triggerDestination
% in Ephus startup settings. When PFI0 is selected under stimulator and set
% to external, Ephus will listen to PFI0 for a trigger/voltage pulse.
% The counter task (createCOPulseChanTime) sends a digital voltage pulse to
% PFI13 at some delay with some pulse width. Feel free to look at USER2
% output on an o-scope.

%%%%%%%%%%%%%%%%%%%%%%%%%   EDIT IF NEEDED   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%NI DAQs and Respective Channels for CO tasks
NIdevNameStim = 'Dev1'; % BNC-2090A NI DAQ:  sound stim timer runs on PCI DAQ
NIdevNameCam = 'Dev2'; %USB-6229 NI DAQ: pupil cam timer runs on USB DAQ
NIchanStim = 1; %PFI13 / ctr1 / counter1
NIchanCam = 1;

%Pupillometry camera settings
pupilFR = 10; %frame rate for pupillometry
% expSet = 40;
% pixelClockMHz = 31;
% scaledCamGain = 58; %Gain Scale: max is 100, corresponding to 1300 factor or (13x)
% gainBoost = 1; %camera gain boost
% camCaptureDelay = 0; %Set whether want delay before capture starts when capture called (in usec)

%set pulse hi and lo time for 10 Hz pupil image acquisition
%if registerSignalEvent runs on edge switch, could just set both of
%these to 0.1s | otherwise would want pulse hi time less than 0.1
%ISI, pulse Hi every 100 ms, so pulsehi = 50ms, pulse lo 50 ms
camPulseHiTime = (1/pupilFR)/2; %s
camPulseLoTime = (1/pupilFR)/2; %s

%%%%%%%%%%%%%%%%%%%%%%%   EDIT IF NEEDED (END)  %%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%  SCANIMAGE CONFIGURATION  %%%%%%%%%%%%%%%%%%%%%%%%

% In 'User Functions' select this function for:
%1.acqModeArmed  %was acqStart, but results in delay
%2.acqAbort
%3.acqModeDone

%Add function 'PulseTrainPanelInit' to appOpen event:

%     function PulseTrainPanelInit(eventName, eventData, stimDelay)
%         pcPulseTrainTriggerPanel
%     end

%(click 'View > USR', click down arrow on right, add under 'applicationOpen', save
%usr file)

%pcPulseTrainTriggerPanel.m and pcPulseTrainTriggerPanel.fig are required
%to obtain stim parameters

%%%%%%%%%%%%%%%%%%%%% ScanImage Configuration (END)  %%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%  EPHUS CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ensure savePulseDetails_train.m is enabled as a user function in
%Ephus else the pulse details will be lost. It should be enabled after
%acquirer:TraceAcquired, before the randpulseselection function fires
%(which should be after/at xsg:save);

%%%%%%%%%%%%%%%%%%%%%%% Ephus Configuration (END)  %%%%%%%%%%%%%%%%%%%%%%%%

%ADDITIONAL NOTES: decide whether to make cam global and have parameters configurable
%in the pcPulseTrainTriggerPanel GUI

%%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%

%%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%

persistent hSys hStim hPupilPicCO pulseFrameCounter totalPulses cam ...
    filename pulseFrameCtrCamTrig frameNo2PforCam pupilFrameNo camFrameTime nPupilFrames ...
    existCam

%SWITCH CASE corresponding to ScanImage Event
switch event.EventName
    
    % see eventFrameTime25Frames_usrFcnTest.mat in 
    % scanimage5-3 directory via scim5eventTest.m called on all acquisition
    % events. acqModeStart happens a while before first frame. acqStart
    % happens just before first frame acquired

    %     case {'acqModeStart'} %deprecated / large time difference b/w SCIM 3 and SCIM 5   
    %     case {'acqStart'}
        case {'acqModeArmed'} %happens just before acqStart: 

        if strcmp(source.hSI.acqState,'grab') || strcmp(source.hSI.acqState,'loop')
%                 disp(hSI.hScan2D.frameCounter)

        %check to ensure the savePath was set to an animal folder
        if isempty(regexp(source.hSI.hScan2D.logFileStem,...
                '\D{2}\d{4}','match'))
            warning('CHECK .TIF FILENAME CORRESPONDENCE B/W EPHUS and SCIM')
%             error('ErrorTAG:TagName',strcat('\n','\n',...
%                 'Save path not set, file stamp annotation will go awry...','\n','\n'))
        end
        
        %initiate NI DAQ system object if not present (could also
        %'import dabs.ni.daqmx.*' and call everything under it like Task(...) )
        if isempty(hSys)
            hSys = dabs.ni.daqmx.System();
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% EPHUS STIM TRIGGER %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Get the info about the pulse from pcPulseTrainTriggerPanel GUI
        %to create CO pulse task
        
        %Initialize variable that will store the 2P frame number at which
        %the trigger event occurs (frame numbers at rising and falling edge
        %of CO pulse are stored here and separated later)
        %This is most important for when multiple stims occur in the same
        %tif recording
        pulseFrameCounter = [];
        
        %try to load the handle to the GUI control figure
        try   hFig= evalin('base', 'PulseTrainHandle');
        catch
            hFig = ' '; %if the gui has not been initialized, blank it
        end
        
        %if the GUI has been closed or not initialized, reinitialize it
        if ~ishandle(hFig)
            pcPulseTrainTriggerPanel; %initilaize the GUI;
            
            %get the handle for the pcPulseTrainTriggerPanel GUI
            hFig = evalin('base', 'PulseTrainHandle');
            justinitialize()
            
        else %obtaining params from pulse train trigger panel GUI
            
            %This gets the parameters set in the pcPulseTrainTriggerPanel
            pulseTrainParams = guidata(hFig);
            
            %This inidcates that stim is selected as ON!
            if get(pulseTrainParams.ephusTriggerButton, 'Value')==1
                
                %gets filename for saved .tif
                filename = fullfile(source.hSI.hScan2D.logFilePath,[source.hSI.hScan2D.logFileStem...
                    '_' num2str(source.hSI.hScan2D.logFileCounter,'%05u') '_00001']);
                filenameWext = [filename '.tif'];
                disp(filename)
                
                %get PC clock time for approximately when acquisition
                %started
                acquisitionStartTime = clock;
                
                %Get params from pulseTrainGUI
                ISI = str2double(get(pulseTrainParams.ISItg, 'String'));
                totalPulses = str2double(get(pulseTrainParams.totalPulsesTg, 'String'));
                stimDelay = str2double(get(pulseTrainParams.StimDelayTg, 'String'));
                
                %non-configurable on panel
                pulseTrainDur = str2double(get(pulseTrainParams.TotalTimeTg, 'String'));
                PulseHiTime = str2double(get(pulseTrainParams.PWHtg, 'String'));
                if totalPulses<2
                    PulseLoTime = 0.1;
                else
                    PulseLoTime = str2double(get(pulseTrainParams.PWLtg, 'String'));
                    
                    if pulseTrainDur>(source.hSI.hStackManager.framesPerSlice/...
                            round(source.hSI.hRoiManager.scanFrameRate))
                        error('ErrorTAG:TagName',strcat('\n','\n',...
                            ['NOTICE: Acquisition duration must exceed time to pulse train end... (2s minimum: ' ...
                            num2str((pulseTrainDur+2)*round(source.hSI.hRoiManager.scanFrameRate)) ' frames)'],'\n','\n'))
                    end
                    
                end
                
                %save stim trigger parameters in mat file located in same
                % folder as saved .tif with corresponding acquisition #
                save([filename '_PulseParams.mat'],...
                    'filenameWext',...
                    'acquisitionStartTime',...
                    'ISI',...
                    'totalPulses',...
                    'stimDelay',...
                    'PulseHiTime','PulseLoTime','pulseTrainDur');
                
                %Create pulse counter output channel, trigged by ScanImage
                %acquisitionStarted
                if isempty(hStim) || ~isvalid(hStim)
                    
                    %Checks if task already exists in daqmx system under this name
                    if hSys.taskMap.isKey('DigStimTrig')
                        delete(hSys.taskMap('DigStimTrig'));
                    end
                    %initiate daqmx system task named DigStimTrig
                    hStim = dabs.ni.daqmx.Task('DigStimTrig');
                    
                    %Create counter output channel on the created stim task
                    hStim.createCOPulseChanTime(NIdevNameStim,NIchanStim,'',...
                        PulseLoTime,PulseHiTime,stimDelay);
                    
                    if totalPulses>1
                        %makes COPulse channel continuous (from Task.m:
                        %Sets only the number of samples to acquire or generate
                        %without specifying timing. Typically, you should use
                        %this function when the task does not require sample
                        %timing, such as tasks that use counters for buffered
                        %frequency measurement, buffered period measurement,
                        %or pulse train generation.
                        hStim.cfgImplicitTiming('DAQmx_Val_ContSamps');
                        
                        %this is deprecated now that CO ends when
                        %totalPulses reached
%                         stopTime = pulseTrainDur-PulseHiTime; %subtract a bit of time off to ensure another pulse doesn't start
                        
                            %Timer to end continuous pulse train depending on
                            %pulseNo and ISI. StartDelay is the time between the
                            %start of the timer and the call of TimerFcn.
%                           hTimer = timer('StartDelay',stopTime,'TimerFcn',@timerFcn);
%                       else
%                           hStim.cfgDigEdgeStartTrig(state.init.triggerInputTerminal);
                    end
                    
                    %Fire callback on CO pulses so that they can be stamped
                    %with respective frame numbers
                    %eg: http://zone.ni.com/reference/en-XX/help/370471AJ-01/daqmxcfunc/daqmxexportsignal/
                    %and:  https://forums.ni.com/t5/Counter-Timer/CounterOutputEvent-Callback/td-p/3585052
                    registerSignalEvent(hStim,@pulseCounterCallback,'DAQmx_Val_CounterOutputEvent');
                end %if hStim doesn't exist
                
                %this checks to ensure the same task on given channel
                %wasn't already active and tries to stop
                if ~hStim.isTaskDone()
                    disp('WARNING: Stimulator trigger task was found to be active already. Attempting to stop.');
                    hStim.stop();
                end
                
                %if stim button OFF
            elseif get(pulseTrainParams.ephusTriggerButton, 'Value')==0 %if stim button OFF
                disp('No stim pulse delivered')
            end %if trigger on
            
        end %if pulseTrainFig not open
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% CAMERA INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%
        %FOR MEMORY/BUFFER AND SETTINGS
        
        % Add NET library assembly
        % Works in 2011b 64-bit - 2018a (doesn't work in 2007)
        % Change location of library
        NET.addAssembly('C:\Rig\Scanimage5-3\DotNet\uc480DotNet.dll');
        
        %create camera object handle
        cam = uc480.Camera;
        
        %open 1st available camera
        %  The integer can also be the Cam.ID from the
        %DCx Camera Manager if a particular camera would like to be used.
        if ~cam.Device.IsOpened
            if ~isequal(cam.Init(0), uc480.Defines.Status.SUCCESS)
                fprintf('Could not initialize pupil cam...\nContinuing without pupillometry.\n');
                existCam = 0;
            else
                existCam = 1;
            end
        else
            disp('Be wary, camera opened elsewhere... parameters may have been changed')
        end
        
        if existCam
            %Start camera 2 seconds into stim delay
%             if stimDelay - 2 > 0
%                 camNiTrigDelay = stimDelay - 2;
%             else
%                 camNiTrigDelay = 0;
%             end
            %pupillary Response
            if stimDelay - 30 > 0
                camNiTrigDelay = stimDelay - 30;
            else
                camNiTrigDelay = 0;
            end
            
            % Set display mode to bitmap (DiB)
            cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB);
            
            %Set color mode to mono8
            cam.PixelFormat.Set(uc480.Defines.ColorMode.Mono8);
            % cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed);
            
            %Set trigger mode to software (single image acquisition)
            cam.Trigger.Set(uc480.Defines.TriggerMode.Software);
            
            %subsampling
            subSampVert = uc480.Defines.SubsamplingMode.Vertical2X;
            subSampHorz = uc480.Defines.SubsamplingMode.Horizontal2X;
            cam.Size.Subsampling.Set(subSampVert.bitor(subSampHorz));
            % [a,c] = cam.Size.Subsampling.GetFactorVertical %to confirm
            % [a,c] = cam.Size.Subsampling.GetFactorHorizontal
            
            %Set camera frame rate so that exposure is adjusted to respective
            %max
            [~,actualFR] = cam.Timing.Framerate.Set(pupilFR);
            %
            % %         [~,actualFR] = cam.Timing.Framerate.Set(pupilFR);
            %         %set exposure to max (should already be set to max)
            % %         cam.Timing.Exposure.Set(0);
            %         cam.Timing.Exposure.Set(expSet);
            %
            %         %Set pixel clock (31 from max at which camera was not dropping
            %         %frames w/ 10 Hz FR in ThorCam
            %         cam.Timing.PixelClock.Set(pixelClockMHz);
            %
            %         %set camera gain boost and gain
            %         %Gain Scale: max is 100, corresponding to 1300 factor or (13x)
            %         %58 was selected by inspecting smoothness of image histograms at
            %         %various gain values. Became very noisy above 58
            %         % cam.Gain.Hardware.Scaled.SetMaster(100)
            %         cam.Gain.Hardware.Scaled.SetMaster(scaledCamGain);
            %
            %         %enable gain boost: note in DotNet progInterface manual, bool inputs must
            %         %be converted to logical eg input --> logical(input)
            %         cam.Gain.Hardware.Boost.SetEnable(logical(gainBoost));
            
            %Allocate memory for images: create memID and corresponding sequence ID for each
            %anticipated frame
            %clear previous memory
            cam.Memory.Sequence.Clear;
            [~,memIDlist] = cam.Memory.GetList;
            if ~isempty(memIDlist)
                cam.Memory.Free(memIDlist);
            end
            
            %calculate desired frames from ScanImage settings & camera FR
            [~,camFR] = cam.Timing.Framerate.Get;
            
            if pupilFR==round(camFR) && (camFR-floor(camFR)-round(camFR-floor(camFR)))<0.01
                nPupilFrames = ((source.hSI.hStackManager.framesPerSlice/...
                    round(source.hSI.hRoiManager.scanFrameRate))-camNiTrigDelay)*pupilFR; %if pupil frame capture goes to end of acquisition
            else
                disp('Changing camera frame rate... It was not set at 10 Hz.')
                [~,camFR] = cam.Timing.Framerate.Set(pupilFR);
                nPupilFrames = round(((source.hSI.hStackManager.framesPerSlice/...
                    round(source.hSI.hRoiManager.scanFrameRate))-camNiTrigDelay)*camFR);
            end
            
            for fNo = 1:nPupilFrames
                cam.Memory.Allocate(true);
            end

            %check that memory allocated
            [~,memIDlist] = cam.Memory.GetList;
            if ~(memIDlist.Length==int32(nPupilFrames))
                error('ErrorTAG:TagName',strcat('\n','\n',...
                    'Issue with camera memory allocation...','\n','\n'))
            end
            
            %add memids to sequence list
            cam.Memory.Sequence.Add(memIDlist);
            
            %Initiate image queue
            cam.Memory.Sequence.InitImageQueue;
            
            %                     %Set whether want delay before capture starts when capture called:
            %                     % cam.Trigger.Delay.Set(4000000) %in usec (4000000 is 4 sec)
            %                     cam.Trigger.Delay.Set(camCaptureDelay);

            
            camParamsAtCap = struct('FR',0,'exposure',0,'pixelClockMHz',0);
            [~,camParamsAtCap.FR] = cam.Timing.Framerate.Get;
            [~,camParamsAtCap.exposure] = cam.Timing.Exposure.Get;
            [~,camParamsAtCap.pixelClockMHz] = cam.Timing.PixelClock.Get;
            
            %save camera parameters in .mat file in same folder as .tif with
            %corresponding acquisition number
            filename = fullfile(source.hSI.hScan2D.logFilePath,[source.hSI.hScan2D.logFileStem...
                    '_' num2str(source.hSI.hScan2D.logFileCounter,'%05u') '_00001']);
%             filename = fullfile(source.hSI.hScan2D.logFilePath,...
%                 [source.hSI.hScan2D.logFileStem num2str(source.hSI.hScan2D.logFileCounter,'%04u')]);
            save([filename '_pupilometryParams.mat'],'NIdevNameCam',...
                'NIchanCam',...
                'camPulseHiTime',...
                'camPulseLoTime',...
                'camNiTrigDelay',...
                'pupilFR',...
                'actualFR',...
                'nPupilFrames',...
                'camParamsAtCap')
            
            %%%%%%%%%%%%%%%%%%%%%%%% CAMERA INITIALIZATION (END)%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%
            %STILL IN     case {'acqModeArmed'}
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% CAMERA TRIGGER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %NI DAQ CO task for camera trigger
            
            %Initialize variables to contain pupil frame and 2p frame counts
            pulseFrameCtrCamTrig = [];
            frameNo2PforCam = [];
            pupilFrameNo = [];
            camFrameTime = [];
            
            %Create couter output channel, trigged by ScanImage
            %AcquisitionStarted
            if isempty(hPupilPicCO) || ~isvalid(hPupilPicCO)
                
                %Checks if task already exists in daqmx system under this name
                if hSys.taskMap.isKey('PupilPicCtrTrig')
                    delete(hSys.taskMap('PupilPicCtrTrig'));
                end
                
                %Initiate daqmx system task named PupilPicCtrTrig
                hPupilPicCO = dabs.ni.daqmx.Task('PupilPicCtrTrig');
                
                %Note: the above simply creates the channel in the task, it
                %does not start anything yet

                %Create couter output on the created task
                hPupilPicCO.createCOPulseChanTime(NIdevNameCam,NIchanCam,'',...
                    camPulseLoTime,camPulseHiTime,camNiTrigDelay);
                
                %makes COPulse channel continuous (from Task.m:
                %Sets only the number of samples to acquire or generate
                %without specifying timing. Typically, you should use
                %this function when the task does not require sample
                %timing, such as tasks that use counters for buffered
                %frequency measurement, buffered period measurement,
                %or pulse train generation.
                hPupilPicCO.cfgImplicitTiming('DAQmx_Val_ContSamps');
                
                %Fire callback on CO pulses so that they can be stamped
                %with respective frame numbers and potentially used to trigger
                %camera frame captures/freeze
                %eg: http://zone.ni.com/reference/en-XX/help/370471AJ-01/daqmxcfunc/daqmxexportsignal/
                %and:  https://forums.ni.com/t5/Counter-Timer/CounterOutputEvent-Callback/td-p/3585052
                registerSignalEvent(hPupilPicCO,@frameTriggerCallback,'DAQmx_Val_CounterOutputEvent');
                
            end % if hPupilPicCO task doesn't exist
            
            %Starts CO task
            hPupilPicCO.start();
        end
        
        if get(pulseTrainParams.ephusTriggerButton, 'Value')==1
            
            %Start stim trigger CO task and timer
            hStim.start();
            
            if totalPulses>1
                %Output stim details on command window
                disp(['Pulse train started with ' num2str(totalPulses) ' pulses, '...
                    num2str(ISI), 's ISI, with total length of ' num2str(pulseTrainDur)...
                    's and delayed ' num2str(stimDelay) ' sec from acq start'])
            else
                disp(['Single pulse to occur ' num2str(stimDelay) ' seconds from acquisition start'])
            end   

        end %if stim enabled
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%% CAMERA TRIGGER (end) %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%
        %STILL IN     case {'acquisitionStarted'}
        end %if grab mode
        
        
        %called when ABORT is clicked during acquisition
    case {'acqAbort'}
%         source.hSI.acqState
        if (strcmp(source.hSI.acqState,'grab') || strcmp(source.hSI.acqState,'loop')) && ...
                source.hSI.hScan2D.frameCounter~=source.hSI.hScan2D.logFramesPerFile
%         if strcmp(source.hSI.acqState,'grab')
            disp('Acquisition Prematurely Terminated. Trigger task stopped and cleared.');
            %Stop+Clear Stim Trigger Tasks to allow them to be re-used on next acquisition start
            if ~isempty(hStim) && isvalid(hStim)
                if totalPulses>1
                    hStim.stop();
                else
                    hStim.abort();
                end
                hStim.clear();
            end
            
            if existCam
                hPupilPicCO.stop();
                hPupilPicCO.clear();
                %Close camera
                cam.Exit;
            end
        end
        
        
        %called when acquisition successfully completes
    case {'acqModeDone'}
        disp('Acquisition Done');
        
        %%%%%%%%%%%%% FOR STIM TASK %%%%%%%%%%%%%%%
        
        %clear CO tasks so that they can be created anew for next
        %acquisition
        if ~isempty(hStim) && isvalid(hStim)
            if totalPulses>1
                hStim.stop();
            else
                hStim.abort();
            end
            
            hStim.clear();
        end
        
        %Sort 2P frame numbers at each stim pulse and save to _PulseParams
        %file
        [frameOnFallingEdge, frameOnRisingEdge] = deal(zeros(1,totalPulses));
        pulseFrameNo = struct('frameOnRisingEdge',frameOnRisingEdge,...
            'frameOnFallingEdge',frameOnFallingEdge,...
            'all',pulseFrameCounter);
        pulseFrameNo.frameOnRisingEdge = pulseFrameCounter(rem(1:length(pulseFrameCounter),2)==1);
        pulseFrameNo.frameOnFallingEdge = pulseFrameCounter(rem(1:length(pulseFrameCounter),2)==0);
        %IMPORTANT NOTE: state.files.fullFileName would be for the next
        %file already, thus using the variable from persistent function call memory
        save([filename '_PulseParams.mat'],'pulseFrameNo','-append')
        
        %%%%%%%%%%%%% FOR STIM TASK (END) %%%%%%%%%%%%%%%
        
%         disp('line 426')
        %%%%%%%%%%%%% FOR CAMERA TASK %%%%%%%%%%%%%%%
        
        if existCam
            hPupilPicCO.stop();
            hPupilPicCO.clear();
%             disp('line 431')
            
            %save images from allocated camera memory
            %get last acquired memID
            %         [~,activeMemIDSeq] = cam.Memory.Sequence.GetActive;
            %         lastSeqMemID = activeMemIDSeq-1;
            [~,lastSeqMemID] = cam.Memory.Sequence.GetLast;
            
            %memID should be the same, but do this just in case (converts seqId
            %to corresponding memID
            %         [~,lastMemID] = cam.Memory.Sequence.ToMemoryID(lastSeqMemID);
            lastMemID = lastSeqMemID;
            
            %query image params
            [~, Width, Height, Bits, ~] = cam.Memory.Inquire(lastMemID);
            
            %initialize 3D matrix for storing frames (height, width, frame)
            pupilFrames = uint8(zeros(Height,Width,lastMemID));
            
            
%             disp('line 461')
            %get memID capture sequence
            [memIDsave, lockYN] = deal(zeros(1,nPupilFrames));
            for fNo = 1:nPupilFrames
                %             [~,memIDsave(fNo),seqIDsave(fNo)] = cam.Memory.Sequence.WaitForNextImage(0);
                [~,memIDsave(fNo),~] = cam.Memory.Sequence.WaitForNextImage(0); %seq and mem ids should be same
            end
%             disp('line 466')
            
            %check to see if they've been locked with image data
            for fNo = 1:nPupilFrames
                [~,lockYN(fNo)] = cam.Memory.Sequence.GetLocked(memIDsave(fNo));
            end
            storedImageIDs = memIDsave(find(lockYN));
%             disp('line 471')
            
            %collect frame from each camera memoryID
            for memIDno = storedImageIDs
                memID = memIDno;
                
                %Obtain image array from image memoryID
                [~, tmp] = cam.Memory.CopyToArray(memID);
                
                %Reshape image
                Data = reshape(uint8(tmp), [Bits/8, Width, Height]);
                Data = Data(1, 1:Width, 1:Height); %1 color
                Data = permute(Data, [3,2,1]);
                
                %Store image frame in 3D matrix (height, width, frame)
                pupilFrames(:,:,memID) = Data;
                clear memID tmp Data
            end
            
            save([filename '_pupilFrames.mat'],'pupilFrames');
            
            %Save image matrix and frame time info
            camFrameTiming = struct('pulseFrameCtrCamTrig',...
                pulseFrameCtrCamTrig,...
                'pupilFrameNo',pupilFrameNo,...
                'frameNo2PforCam',frameNo2PforCam,...
                'camFrameTime',camFrameTime);
            save([filename '_pupilometryParams.mat'],...
                'camFrameTiming',...
                '-append');
            
            %Close camera
            cam.Exit;
        end
        
        %%%%%%%%%%%%% FOR CAMERA TASK (END) %%%%%%%%%%%%%%%
        
        
end %switch case for ScanImage event handling


%%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%
%%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%
%%%%% /////////////// \\\\\\\\\\\\\\\ /////////////// \\\\\\\\\\\\\\\ %%%%%


%%%%%%%%%%%%%%%%%%%%%% DEFINE ADDITIONAL FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%

%This function is called if the pulseTrainPanel GUI was not found and
%needs to be initialized
    function justinitialize()
        warning('Digital Trigger settings not initialized, doing so then aborting')
        return
    end

%This function obtains the 2P frame numbers corresponding to when CO
%pulses occur (at rising and falling edge of pulse; ephus listens only for rising edge)
%it will be called at every rising and falling edge of the stim CO task
    function null = pulseCounterCallback(~,~,~)
        
        %collect 2P frame number (again, contains frame at both rising and falling
        %edge)
        pulseFrameCounter(end+1) = source.hSI.hScan2D.frameCounter;
        
        %clear CO tasks so that they can be created anew for next
        %acquisition
        if (length(pulseFrameCounter)/2)>=totalPulses && ~isempty(hStim) && isvalid(hStim)
            if totalPulses>1
                hStim.stop();
            else
                hStim.abort();
            end
            
            hStim.clear();
        end
        
        null = 1;
        return
    end %pulseCounterCallback

%This function is called at every rising/falling edge of pulse from the
% camera CO task
    function null2 = frameTriggerCallback(~,~,~)
        
        pulseFrameCtrCamTrig(end+1) = source.hSI.hScan2D.frameCounter;
        
        %on CO pulse falling edge frame counter will be even
        %(rise,fall,rise,fall,rise,fall,...) call camera freeze on fall
        if rem(numel(pulseFrameCtrCamTrig),2)==0
            
            %camera frame ID (memID) to be captured
            [~,pupilFrameTmp] = cam.Memory.Sequence.GetActive;
            
%             if numel(pupilFrameNo)>2 && nPupilFrames>pupilFrameTmp
                
                pupilFrameNo(end+1) = pupilFrameTmp;
                
                %corresponding 2P frame ID on falling edge
                frameNo2PforCam(end+1) = pulseFrameCtrCamTrig(end);
                
                %save time of pupil frame
                camFrameTime(end+1,:) = clock;
                
                %%%%%%%%%%%%%%%%%%%%%%%%  begin camera trig %%%%%%%%%%%%%%%%%%%%%%%%
                
                %acquire image | The Acquisition.Freeze method parameter is a
                %uc480.Defines.DeviceParameter enumeration which defines if the program should wait or not
                %wait for the image to be saved to memory
                cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.DontWait);
                
%             end
            
        end %if even counter pulse
        
        null2 = 1;
        return
        
    end %cameraTrigger Callback

end

%}

%}