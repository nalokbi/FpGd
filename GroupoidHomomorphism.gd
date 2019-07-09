
            #################################
            #                               #
            #     Groupoid Homomorphism     #     
            #                               #
            #################################

# 0

DeclareCategory("IsGroupoidMorphism",IsObject);

# 1

DeclareRepresentation(  "IsGroupoidMorphismRep",
                        IsComponentObjectRep,
                        ["source",
                         "target",
                         "mappingObj",
                         "mappingArr",
                         "name"]);

# 2

GroupoidMorphismFamily:=NewFamily( "GroupoidMorphismFamily",
                                IsGroupoidMorphism,
                                IsGroupoidMorphism);

# 3

GroupoidMorphism:=NewType(GroupoidMorphismFamily,IsGroupoidMorphismRep);


# 4

InstallMethod( ViewObj,  "for groupoid morphism", [IsGroupoidMorphism],
    function(F)
local S,T,MapArr,gensS,arrowsT,List2String,geS,arrT;
    #######################################
    List2String:=function(L)
        local l,K,PreFun;
        PreFun:=function(L)
          local K,l;
          if L=[] then return "Identity"; fi;
          K:=[]; 
          if L[1]>0 then Append(K,["f",String(L[1])]);
          else Append(K,["f",String(-L[1]),"^-1"]);
          fi;
            for l in [2..Length(L)] do
              if L[l]>0 then Append(K,["*","f",String(L[l])]); 
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
    S:=F!.source;
    T:=F!.target;
    MapArr:=F!.mappingArr;
    gensS:=GeneratorsOfGroupoid(S);
    geS:=List(gensS,x->x!.list);
    arrowsT:=List(gensS,x->MapArr(x));
    arrT:=List(arrowsT,x->x!.list);
Print("Objects Mapping : ", S!.objects, " -> "  , T!.objects , "\n" ,
      "Arrows Mapping  : ",  List2String(geS) , " -> ", List2String(arrT));
 end);
 

##################################  END  #######################################