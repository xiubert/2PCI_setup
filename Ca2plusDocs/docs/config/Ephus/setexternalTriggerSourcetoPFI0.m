function setexternalTriggerSourcetoPFI0(varargin)
%This should be added as a callback in userFcns under hotswitch:StateX
%(hotswitches for Two-photon) 

global progmanagerglobal

obj = progmanagerglobal.programs.stimulator.stimulator.variables.hObject;
setLocalBatch(progmanager,obj,'externalTriggerSource','PFI0')
shared_extTriggerSourceUpdate(obj)

disp('set external trigger source to PFI0')
end


