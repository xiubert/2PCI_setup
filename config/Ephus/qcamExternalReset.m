function qcamExternalReset(varargin)
%this function will re-initiate qcam into external mode so that an
%automated cycle can proceed without manual interruption
%TO WORK PROPERLY THIS SHOULD BE ADDED AS A CALLBACK IN usrFcns under
%xsg:save

global progmanagerglobal

disp('Re-initializing qcam to external')

qcamfighandl = progmanagerglobal.programs.qcam.qcam.variables.hObject;
qcamfcn = getFunctionHandle(progmanager, qcam);

pause(1)
feval(qcamfcn,'external_Callback', qcamfighandl, [], qcamfighandl)
end