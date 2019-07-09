            #################################
            #                               #
            #          Fp Groupoid          #     
            #                               #
            #################################

# 0

DeclareCategory("IsFpGdFpGroupoid",IsObject);

# 1

DeclareRepresentation(  "IsFpGdFpGroupoidRep",
                        IsComponentObjectRep,
                        ["objects",
                         "generators",
                         "sources",
                         "targets",
                         "relators",
                         "name"]);

# 2

FpGdFpGroupoidFamily:=NewFamily( "FpGdFpGroupoidFamily",
                                IsFpGdFpGroupoid,
                                IsFpGdFpGroupoid);

# 3

FpGdFpGroupoid:=NewType(FpGdFpGroupoidFamily,IsFpGdFpGroupoidRep);

# 4

InstallMethod( ViewObj,
"for finitely presented groupoid",
 [IsFpGdFpGroupoid],
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
    if g=[] then Print("<fp groupoid on the generators ", [ ] ,">");
    else
    g:=List(g,x->[x]);
 Print("<fp groupoid on the generators ", List2String(g) ,">");
 fi;
 end);


##################################  end  #######################################


            #################################
            #                               #
            #     Fp Groupoid Elements      #     
            #                               #
            #################################


# 0

DeclareCategory("IsFpGdFpGroupoidElm",IsObject);

# 1

DeclareRepresentation(  "IsFpGdFpGroupoidElmRep",
                        IsComponentObjectRep,
                        ["list",
                         "source",
                         "target",
                         "parent"]);

# 2

FpGdFpGroupoidElmFamily:=NewFamily( "FpGdFpGroupoidElmFamily",
                                IsFpGdFpGroupoidElm,
                                IsFpGdFpGroupoidElm);

# 3

FpGdFpGroupoidElm:=NewType(FpGdFpGroupoidElmFamily,IsFpGdFpGroupoidElmRep);


# 4

InstallMethod( ViewObj,
"for finitely presented groupoid element",
 [IsFpGdFpGroupoidElm],
 function(a) local i,L,e,name;
 L:=[]; e:=a!.list; name:=a!.parent; name:=name!.name;
 
 if Length(e)>0 then 
 for i in [1..Length(e)] do
    if i<Length(e) then
        if e[i]>0 then Append(L,["f",String(e[i]),"*"]); # "f"==name
        else Append(L,["f",String(-e[i]),"^-1*"]);       # "f"==name
        fi;
    else
        if e[i]>0 then Append(L,["f",String(e[i])]);     # "f"==name
        else Append(L,["f",String(-e[i]),"^-1"]);        # "f"==name
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