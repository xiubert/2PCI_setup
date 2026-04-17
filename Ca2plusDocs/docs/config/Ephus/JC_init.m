function JC_init(varargin)
%This should be added as a callback in userFcns under hotswitch:StateX
%(the first hotswitch you press after Ephus starts)

global progmanagerglobal

setLocalBatch(progmanager,qcam,'namingScheme','XSG')

fighandleobj = progmanagerglobal.programs.xsg.xsg.variables.hObject;
setLocalBatch(progmanager,fighandleobj,'directory','D:\Data\sutter2P\Jinbo')

end