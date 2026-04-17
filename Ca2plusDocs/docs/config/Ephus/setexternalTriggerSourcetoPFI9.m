function setexternalTriggerSourcetoPFI9(varargin)
%This should be added as a callback in userFcns under hotswitch:StateX
%(hotswitches for Widefield) 

global progmanagerglobal

obj = progmanagerglobal.programs.stimulator.stimulator.variables.hObject;
setLocalBatch(progmanager,obj,'externalTriggerSource','PFI9')
shared_extTriggerSourceUpdate(obj)

disp('set external trigger source to PFI9')
end


