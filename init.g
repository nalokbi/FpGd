#############################################################################
##
##  init.g                  FpGd library                  Nisreen Alokbi 
##
############################################################################

if not IsBound(HapGlobalDeclarationsAreAlreadyLoaded) then
ReadPackage("FpGd","lib/fpgd.gd");
HapGlobalDeclarationsAreAlreadyLoaded:=true;
MakeReadOnlyGlobal("FpgdGlobalDeclarationsAreAlreadyLoaded");
fi;

ReadPackage("FpGd","/lib/externalSoftware.gap");


