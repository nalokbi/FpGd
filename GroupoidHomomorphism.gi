

##########################################################################################

InstallGlobalFunction( GroupoidMorphismByImages, "method for defining groupoid morphism", 
function(arg)
local G,H,Smo,Tmo,Sma,Tma,gens,MapObj,MapArr,L,K,Word2List;

    if Length(arg)>3 then
      G:=arg[1];
      H:=arg[2];
      Smo:=arg[3][1];
      Tmo:=arg[3][2];
      Sma:=arg[4][1];
      Tma:=arg[4][2];
    else
      G:=arg[1];
      H:=arg[2];
      Sma:=arg[3][1];
      Tma:=arg[3][2];
    fi;
                gens:=GeneratorsOfGroupoid(G); 

                MapObj:=function(x) 
                                return Tma[Position(Sma,x)]; 
                end;
      L:=Sma;
      Append(L, List (L,x->x^-1) );
      K:=Tma;
      Append(K, List (K,x->x^-1) );

                Word2List:=function(w)   # function to convert word to list of generators (w=f1^-1*f2 -> [f1^-1,f2])
                   local i,j, LfromW;      
                            LfromW:=[]; 
                            j:=0; 
                            for i in w!.list do 
                            j:=j+1; 
                            if i>0 then 
                            LfromW[j]:=gens[i]; 
                            else LfromW[j]:=gens[-i]^-1;
                            fi;
                                             od; 
                            return LfromW; 
                end;

                MapArr:=function(w)  
                   local Lw,k,x,i;
                   Lw:=Word2List(w);
                   k:=Length(Lw);
                   if k=1 then x:=Lw[1]; return K[Position(L,x)];
                   else
                        x:=K[Position(L,Lw[1])];
                        for i in [2..k] do
                           x:=x*K[ Position(L,Lw[i]) ];
                        od;
                   return x;
                   fi;
                end;
if Length(arg)>3 then
    return Objectify(GroupoidMorphism,rec(source:=G,target:=H,mappingObj:=MapObj,mappingArr:=MapArr,name:="N"));
else
    return Objectify(GroupoidMorphism,rec(source:=G,target:=H,mappingArr:=MapArr,name:="N"));
fi;
end);



############################################################

InstallOtherMethod(Source,
"source of of a groupoid morphim",
[IsGroupoidMorphism],
function(f) return f!.source;
end);
###########################################################

InstallOtherMethod(Target,
"target of of a groupoid morphim",
[IsGroupoidMorphism],
function(f) return f!.target;
end);

############################################################

InstallGlobalFunction(ImageOfArrow,
"image of of an arrow under a groupoid morphism",
function(arg)
local a, f, x;
f:=arg[1];
x:=arg[2];
a:=f!.mappingArr;
return a(x);
end);

############################################################


InstallGlobalFunction(FundamentalGroupoidOfRegularCWMap,
              "method for defining the groupoid functor",
function(map,V)
local S,T,f,GS,gensS,GT,gensT,VV,L,cc,1c,path,Deform,PATHS,x,i,prod,CC,1C,v,f1c,B,y,f_path,dom,codom,g,rev;

S:=Source(map);
T:=Target(map);
f:=map!.mapping;
VV:=List(V , y -> f(0,y) );
GS:=FundamentalGroupoidOfRegularCWComplex(S,V);
GT:=FundamentalGroupoidOfRegularCWComplex(T,VV);

gensS:=GeneratorsOfGroupoid(GS);
gensT:=GeneratorsOfGroupoid(GT);

cc:=S!.criticalCells;
1c:=List(Filtered(cc,x->x[1]=1),y->y[2]);

path:=List( 1c , x-> S!.path(x) );

f_path:=List(path , x-> List(x,y-> f(1,y)) );


#####################################
#
#
#
Deform:=function(Y,n,kk)
local sgnn,x,f,k,sgnk,cnt,bnd,def,sn,tog,def1,def2,DCSrec,dim,rev; 
dim:=Dimension(Y);
DCSrec:=List([1..dim+1],i->[]);;           
k:=AbsInt(kk);
sgnk:=SignInt(kk);
if [n,k] in Y!.criticalCells then return [kk]; fi;
if n>0 then if IsBound(Y!.vectorField[n][k]) then return []; fi; fi;
if IsBound(DCSrec[n+1][k]) then if sgnk=1 then return DCSrec[n+1][k]; else return -DCSrec[n+1][k]; fi; fi;
f:=Y!.inverseVectorField[n+1][k];
bnd:=Y!.boundaries[n+2][f];
sn:=Y!.orientation[n+2][f];
def:=[]; def1:=[];def2:=[];
for x in [2..Length(bnd)] do
if not bnd[x]=k then Add(def1,sn[x-1]*bnd[x]); else sgnn:=sn[x-1]; break; fi;
od;
cnt:=x+1;
for x in [cnt..Length(bnd)] do
Add(def2,sn[x-1]*bnd[x]);
od;
if sgnn=1 then def:=-Concatenation(def1,def2); else def:=Concatenation(def2,def1); fi;
Apply(def,x->Deform(Y,n,x));
def:=Flat(def);
Apply(def,x->[x,0]);
def:=AlgebraicReduction(def);
Apply(def,x->x[1]);
DCSrec[n+1][k]:=def;
if sgnk=1 then return def; else return -def; fi;
end;
#
#
#
#####################################

Apply(f_path,x-> List(x, a->Deform(T,1,a)));

rev:=function(L) return List([0..Length(L)-1],i->L[Length(L)-i]); end;

Apply(f_path,rev);
Apply(f_path,Flat);



f1c:=List(Filtered(T!.criticalCells,x->x[1]=1),y->y[2]);
B:= List(f_path, x-> List(x, y-> gensT[ Position(f1c,AbsInt(y)) ]^(SignInt(y)) ) );

dom:=List(gensS,x->Source(x));
codom:=List(dom,x->f(0,x));

g:=function(L,0c)
local k,i,LL;
k:=Length(L);
LL:=[];
for i in [0..k-1] do
    if Source(L[k-i])=0c 
    then
    LL[k-i]:=L[k-i];
    0c:=Target(L[k-i]);
    else
    LL[k-i]:=L[k-i]^-1;
    0c:=Target(L[k-i]);
    fi;
od;
return LL;
end;

B:=List([1..Length(B)],i->g(B[i],codom[i]));

prod:=function(L) if Length(L)>1 then return FpGdProduct(L); else return L[1]; fi; end;
PATHS:=List(B,x->prod(x));

return GroupoidMorphismByImages(GS,GT,[gensS,PATHS]);
end);



############################################################

                      
InstallMethod(PushoutOfFpGroupoids, [IsGroupoidMorphism,IsGroupoidMorphism],
function(f,g)
local P, rels, FhomP, FFhomP, GhomP, GGhomP, FGhomP, F, FF, G, GG, 
      FG, U, W, gensF, gensFF, gensG, gensGG, gensP, x, gg,tot,
      UF,UG,mappingOBJ;
F:=Target(f);
FF:=FreeGroupoidOfFpGroupoid(F);
G:=Target(g);
GG:=FreeGroupoidOfFpGroupoid(G);
FG:=Source(f);
gensFF:=GeneratorsOfGroupoid(FF);
gensF:=GeneratorsOfGroupoid(F);
gensGG:=GeneratorsOfGroupoid(GG);
gensG:=GeneratorsOfGroupoid(G);
U:=FG!.objects;
#####################
mappingOBJ:=function(f,x)
local S,T,gensS,gensT,gS;
S:=Source(f);
T:=Target(f);
gensS:=GeneratorsOfGroupoid(S);
gensT:=GeneratorsOfGroupoid(T);
gS:=Filtered(gensS,y->Source(y)=x)[1];
return Source(f!.mappingArr(gS));
end;
#####################
 UF:=List(U,x->mappingOBJ(f,x));
 UG:=List(U,x->mappingOBJ(g,x));
W:=[];
tot:=[1..Length(gensF)+Length(gensG)];
Append(W,List([1..Length(gensF)],x->[U[Position(UF,gensF[x]!.source)],x,U[Position(UF,gensF[x]!.target)]]));
Append(W,List([1..Length(gensG)],x->[U[Position(UG,gensG[x]!.source)],x+Length(gensF),U[Position(UG,gensG[x]!.target)]]));
P:=FreeGroupoid( U , W );
gensP:=GeneratorsOfGroupoid(P);
FFhomP:=GroupoidMorphismByImages(FF,P,[gensFF, gensP{[1..Length(FF!.generators)]}]);
FhomP:=GroupoidMorphismByImages(F,P,[gensF, gensP{[1..Length(FF!.generators)]}]);
GGhomP:=GroupoidMorphismByImages(GG,P,[gensGG, gensP{[1+Length(FF!.generators)..Length(gensP)]}]);
GhomP:=GroupoidMorphismByImages(G,P,[gensG, gensP{[1+Length(FF!.generators)..Length(gensP)]}]);
gg:=GroupoidMorphismByImages(FG,G,[GeneratorsOfGroupoid(FG),List(GeneratorsOfGroupoid(Source(g)),x->ImageOfArrow(g,x)) ]);
rels:=[];
Append(rels, List(RelatorsOfFpGroupoid(F),x->ImageOfArrow(FFhomP,x)) );
Append(rels, List(RelatorsOfFpGroupoid(G),x->ImageOfArrow(GGhomP,x)) );
for x in GeneratorsOfGroupoid(FG) do
    Add(rels,(ImageOfArrow(GhomP, ImageOfArrow(gg,x)))*(ImageOfArrow(FhomP, ImageOfArrow(f,x)))^-1);
od;
return P/rels;
end);
