################################################################################
##																			                                      ##
#W    read.g                 The FpGd package               Nisreen Alokbi    ##
#W                                                      	          	 			  ##
################################################################################
##
#R  Read the install files.
##
###############################################################################


FpGdconstant:=2;	
SetInfoLevel(InfoWarning,0); 

if not CompareVersionNumbers(VERSION,"1.0") then
        IsPackageMarkedForLoading:=function(ver,num) local b;
        b:=LoadPackage(ver,num,false);
        if b=true then return b; else return false; fi;
        end;
fi;


                      ###################################
                      #                                 #
#######################         General Mapper          #######################
                      #                                 #
					            ###################################

ReadPackage( "FpGd", "lib/Mapper/mapper.gi" );

                      ###################################
                      #                                 #
#######################            Groupoid             #######################
                      #                                 #
           					  ###################################


ReadPackage( "FpGd", "lib/Groupoid/GroupoidElems.gi" );



MakeReadOnlyGlobal("TestFpGd");

###############################################################################


#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
