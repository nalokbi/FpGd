            #################################
            #                               #
            #        Free Groupoid          #     
            #                               #
            #################################


# 0

DeclareCategory("IsFpGdFreeGroupoid",IsObject);

# 1

DeclareRepresentation(  "IsFpGdFreeGroupoidRep",
                        IsComponentObjectRep,
                        ["objects",
                         "generators",
                         "sources",
                         "targets",
                         "name"]);

# 2

FpGdFreeGroupoidFamily:=NewFamily( "FpGdFreeGroupoidFamily",
                                IsFpGdFreeGroupoid,
                                IsFpGdFreeGroupoid);

# 3

FpGdFreeGroupoid:=NewType(FpGdFreeGroupoidFamily,IsFpGdFreeGroupoidRep);

# 4
InstallMethod( ViewObj,
"for free groupoid",
 [IsFpGdFreeGroupoid],
 function(G)
 local g,List2String;
 g:=G!.generators;
    #######################################
    List2String:=function(L)
        local l,K,PreFun;
        PreFun:=function(L)
        local K,l;
        K:=[]; 
        if L[1]>0 then Append(K,["f",String(L[1])]);
        else Append(K,["f",String(-L[1]),"^-1"]);
        fi;
        for l in [2..Length(L)] do
        if L[l]>0 then Append(K,["*","f",String(l)]); 
        else Append(K,["*","f",String(-L[l]),"^-1"]); 
        fi;
        od;
        return Concatenation(K);
        end;
        if IsInt(L[1]) then return PreFun(L);
        else
        K:=[];
        Append(K,["[ ",PreFun(L[1])]);
        for l in [2..Length(L)] do
        Append(K,[" , ",PreFun(L[l])]);
        od;
        Append(K,[" ]"]);
        K:=Concatenation(K);
        return K;
        fi;
        end;
    #######################################
    g:=List(g,x->[x]);
 Print("<free groupoid on the generators ", List2String(g) ,">");
 end);


##################################  end  #######################################






            #################################
            #                               #
            #    Free Groupoid Elements     #     
            #                               #
            #################################

# 0

DeclareCategory("IsFpGdFreeGroupoidElm",IsObject);

# 1

DeclareRepresentation(  "IsFpGdFreeGroupoidElmRep",
                        IsComponentObjectRep,
                        ["list",
                         "source",
                         "target",
                         "parent"]);
                       
# 2

FpGdFreeGroupoidElmFamily:=NewFamily( "FpGdFreeGroupoidElmFamily",
                                IsFpGdFreeGroupoidElm,
                                IsFpGdFreeGroupoidElm);
                
# 3

FpGdFreeGroupoidElm:=NewType(FpGdFreeGroupoidElmFamily,IsFpGdFreeGroupoidElmRep);

# 4

InstallMethod( ViewObj,
"for free groupoid element",
 [IsFpGdFreeGroupoidElm],
 function(a) local i,L,e,name;
 L:=[]; e:=a!.list; name:=a!.parent; name:=name!.name;
 
 if Length(e)>0 then 
 for i in [1..Length(e)] do
    if i<Length(e) then
        if e[i]>0 then Append(L,["f",String(e[i]),"*"]);
        else Append(L,["f",String(-e[i]),"^-1*"]);
         fi;
    else
        if e[i]>0 then Append(L,["f",String(e[i])]);
        else Append(L,["f",String(-e[i]),"^-1"]);
        fi;
    fi;
 od;
L:=Concatenation(L);
Print(L);
else 
Print(1,"\n");
fi;
 end);


##################################  END  #######################################

