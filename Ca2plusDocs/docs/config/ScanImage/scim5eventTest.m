function scim5eventTest(source,event,varargin)

persistent frameTime

switch event.EventName
    case {'acqModeArmed'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime(end+1) = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
        
    case {'acqModeStart'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
        
    case {'acqStart'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime(end+1) = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
        
    case {'acqAbort'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime(end+1) = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
        
    case {'acqModeDone'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime(end+1) = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
        assignin('base','frameTime',frameTime)
        
    case {'acqDone'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime(end+1) = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
        
    case {'frameAcquired'}
        disp(['Event: ' event.EventName])
        disp(['acqState: ' source.hSI.acqState])
        disp(['Frame: ' num2str(source.hSI.hScan2D.frameCounter)])
        disp(datetime)
        frameTime(end+1) = struct('event',event.EventName,'frame',source.hSI.hScan2D.frameCounter,'time',datetime);
end