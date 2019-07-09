############################################################################

InstallGlobalFunction(FpGroupoid,
function(arg)
local l,k,L,s,t,g,o,r,Rec,Name;
  o:=arg[1];
  L:=arg[2];
  k:=Length(L);
  r:=arg[3];
  l:=Length(arg);
  if l > 3 then
  Name:=arg[4];
  else
  Name:="G";
  fi;
  if Length(SSortedList(L)) <> k then
     Print ("error,"," ","some generators are duplicated", "\n");
     return fail;
   else
      s:=List([1..k],i->L[i][1]);
      g:=List([1..k],i->L[i][2]);
      t:=List([1..k],i->L[i][3]);
      Rec:=rec(objects:=o, generators:=g, sources:=s, targets:=t, relators:=r, name:=Name);
     return Objectify(FpGdFpGroupoid,Rec);
  fi;
end);



##############################################################################

InstallGlobalFunction(IdentityGroupoidElm, 
               "Method for Identity Element of a Groupoid", 
function(G,obj) 
local a, rec_a, A;
a:=[];
rec_a:=rec(list:=[], source:=obj, target:=obj, parent:=G);
if IsFpGdFreeGroupoid(G) then
A:=Objectify(FpGdFreeGroupoidElm,rec_a);
else
A:=Objectify(FpGdFpGroupoidElm,rec_a);
return A;
fi;
end);

##############################################################################





#####################################################################

InstallTrueMethod(IsMultiplicativeElement,IsFpGdFpGroupoidElm);

#####################################################################

InstallOtherMethod
(  \*,
   "for two Fp groupoid elements in 'IsFpGdFpGroupoidElm' ",
   [IsFpGdFpGroupoidElm, IsFpGdFpGroupoidElm],

   function( w1 , w2 )
       local w, F ;
       
       if not (w2!.target = w1!.source) then
       Print("Words are not composable. \n");
       return fail;
       else
       F:=w1!.parent;
       w:=SimplifyList(Concatenation(w1!.list,w2!.list));
       return Objectify(FpGdFpGroupoidElm,
                        rec(list:=w, source:=w2!.source, target:=w1!.target, parent:=F));
       fi;
   end 
);

######################################################################################
 InstallOtherMethod
(  \^,
   "for one Fp groupoid element in 'IsFpGdFpGroupoidElm' ", [IsFpGdFpGroupoidElm, IsInt],
   function( g,n )
   local r,L, ginvList;
   L:=g!.list;
   r:=Length(L);
   if (n=-1) then
        if (r=1) then
         return Objectify(FpGdFpGroupoidElm,
                        rec(list:=-g!.list, source:=g!.target, target:=g!.source, parent:=g!.parent));
        else
        ginvList:=List([1..r],i->-L[r-i+1]);
        return Objectify(FpGdFpGroupoidElm,
                        rec(list:=ginvList, source:=g!.target, target:=g!.source, parent:=g!.parent));
        fi;
   elif (n=1) then 
        if (r=1) then
         return Objectify(FpGdFpGroupoidElm,
                        rec(list:=g!.list, source:=g!.source, target:=g!.target, parent:=g!.parent));
        else
        ginvList:=List([1..r],i->L[r-i+1]);
        return Objectify(FpGdFpGroupoidElm,
                        rec(list:=ginvList, source:=g!.source, target:=g!.target, parent:=g!.parent));
        fi;
    else return fail;
   fi;
   end );


############################################################################

InstallGlobalFunction(RelatorsOfFpGroupoid,
                      function(G)
local rels,t,gens, ListToWord,Rels, r;  
rels:=G!.relators;
t:=Length(rels);
gens:=GeneratorsOfGroupoid(G);
###########################################
ListToWord:=function(L,Gens)
local Lnew, LL, K, i, j, g, k;
g:=Concatenation(Gens,List(Gens,x->x^-1));
Lnew:=Filtered(g,x->x!.list[1] in L);
LL:=[];
for k in L do
for j in [1..Length(Lnew)] do
if Lnew[j]!.list[1]=k then Add(LL,Lnew[j]); fi;
od;
od;
K:=LL[1];
for i in [2..Length(LL)] do
K:=K*LL[i];
od;
return K;
end;
###########################################
Rels:=List([1..t],i->ListToWord(rels[i],gens));
if "parent" in NamesOfComponents(G) then 
for r in Rels do
r!.parent:=G!.parent;
od;
fi;
return Rels;
end);

######################################################################################

InstallGlobalFunction(FreeGroupoidOfFpGroupoid, function(G)
local objs, gens, s, t, N, R;

objs:= G!.objects;
gens:=G!.generators;
s:=G!.sources;
t:=G!.targets;
N:=G!.name;
R:=rec(objects:=objs,generators:=gens,sources:=s,targets:=t,name:=N);
return Objectify(FpGdFreeGroupoid,R);
end);

######################################################################################


InstallMethod(TreeOfFpGroupoid,"Method for Tree of Fp Groupoid",
              [IsFpGdFpGroupoid, IsInt],
function(G,v)
local g,T, V, objs, gens, ftr; 
T:=[];     V:=[v];
gens:=GeneratorsOfGroupoid(G);
ftr:=Filtered(gens,x->not Source(x)=Target(x));
objs:=G!.objects;

if not v in objs then 
   Print("The vertex should be an object of the Groupoid. \n");
   return fail;
else
   while Length(T)<Length(objs)-1 do
    for g in ftr do
     ##########################################
        if g!.source in V then                #
          if not g!.target in V then          #
               Add(V,g!.target);                #
                   Add(T,g);                        #
              fi;                                 #
          fi;                                   #
     ############################################
          if g!.target in V then                #
            if not g!.source in V then          #
                Add(V,g!.source);                 #
                  Add(T,g^-1);                      #
              fi;                                 #
          fi;                                   #
     ############################################
    od;
   od;
return T;
fi; 
end);


##########################################################################


InstallOtherMethod(IdentityFpGroupoidElm, 
               "Method for Identity Element of Fp Groupoid", 
               [IsFpGdFpGroupoid,IsInt],
function(G,obj) 
local a, rec_a, A;
a:=[];
rec_a:=rec(list:=[], source:=obj, target:=obj, parent:=G);
A:=Objectify(FpGdFpGroupoidElm,rec_a);
return A;
end);

#######################################################################################

InstallOtherMethod(\=,"for two words in Fp Groupoid", IsIdenticalObj, [IsFpGdFpGroupoidElm, IsFpGdFpGroupoidElm], 0, function(w1,w2)
return 
      w1!.source = w2!.source and
        w1!.target = w2!.target and
      w1!.list = w2!.list;
end);


##########################################################################################


InstallMethod( ComponentsOfFpGroupoid, 
               "function for components of Fp Groupoid", 
               [IsFpGdFpGroupoid],
function(G)
local gens,L,C,i,j,g,M,k,N,NN, W, r, Q,SubGroupoid,NeighbouredGenerators;
    NeighbouredGenerators:=function(g1,g2)
                          if g1!.source=g2!.target or g2!.source=g1!.target or
                             g1!.source=g2!.source or g2!.target=g1!.target
                          then return true; else return false; 
                          fi;
    end;
gens:=GeneratorsOfGroupoid(G);
L:=Length(gens);;
C:=List([1..L],i->[gens[i]]);;
for i in [1..L-1] do
for j in [i+1..L] do
if NeighbouredGenerators(gens[i],gens[j]) then Add(C[i],gens[j]); fi;
od;
od;
g:=function(R,r) if Position(R,r)=fail then return 0; else return Position(R,r); fi; end;
M:=List([1..L],i->[]);;
for k in [1..L] do
M[k]:=List([1..L],i->g(C[k],gens[i]));
od;
N:=List([1..L],i->[]);;
for i in [1..L] do
for j in [1..L] do
if not M[i][j]=0 then
N[i][j]:=j;
else 
N[i][j]:=[];
fi;
od;
od;
for i in [1..L-1] do
for j in [i+1..L] do
if not Filtered(Intersection(N[i],N[j]), k -> not k=[])=[] then N[i]:=Union(N[i],N[j]); N[j]:=[];
fi;
od;
od;
NN:=SSortedList(N);;
W:=[];;
r:=0;;
for i in [1..Length(NN)] do
if not NN[i]=[] then r:=r+1; W[r]:=NN[i]; fi;
od;
W:=List([1..Length(W)], i-> Filtered(W[i], k -> not k=[]));
Q:=List([1..Length(W)],i->List([1..Length(W[i])],j->gens[W[i][j]]));
###################################################
SubGroupoid:=function(G,Gens)
local Rec, Rels, objs, gens, sours, targs, rels,  r, g, N,k;
Rels:=RelatorsOfFpGroupoid(G);
objs:= SSortedList( Flat (List(Gens, g -> [g!.source,g!.target]) ));
gens:=List(Gens, g -> g!.list[1] );
sours:=List(Gens, g -> g!.source );
targs:=List(Gens, g -> g!.target );
rels:=[];
for r in Rels do
    if not Intersection(r!.list,gens)=[] then Add(rels,r!.list); fi;
od;
Rec:=rec(objects:=objs, generators:=gens, sources:=sours, targets:=targs, relators:=rels, name:="G" );
return 
Objectify(FpGdFpGroupoid,StructuralCopy(Rec));
end;
##################################################
return List([1..Length(Q)],i->SubGroupoid(G,Q[i]));
end);


##########################################################################################


InstallMethod( IsConnectedFpGroupoid, 
               "method for connectivity of Fp Groupoid", 
               [IsFpGdFpGroupoid],
function(G)
if Length(ComponentsOfFpGroupoid(G))=1 then return true; else return false; fi;
end);

##########################################################################################


InstallMethod( RelatorToGroupWord, 
               "method for connectivity of Groupoid", 
               [IsFpGdFpGroupoid, IsFpGdFpGroupoidElm, IsInt],
function(G,w,v)
local T,L,s,e;
s:=w!.source;
T:=TreeOfFpGroupoid(G,v);
L:=Length(T);
if s=v then return w;
else
while not w!.source=v do
for e in T do
s:=w!.source;
if e!.target=s then 
w:=e*w*e^-1;
fi;
od;
od;
return w;
fi;
end);


##########################################################################################









InstallOtherMethod(Source,
"source of of an arrow of a Fp Groupoid",
[IsFpGdFreeGroupoidElm],
function(f) return f!.source;
end);

InstallOtherMethod(Target,
"target of of an arrow of a Fp Groupoid",
[IsFpGdFreeGroupoidElm],
function(f) return f!.target;
end);

InstallOtherMethod(Length,
"length of of an alement of a Groupoid",
[IsFpGdFpGroupoidElm],
function(f) return Length(f!.list);
end);




##################              #################

InstallOtherMethod( \in , "for free groupoid elements" ,
                          [IsFpGdFpGroupoidElm , IsFpGdFpGroupoid] ,
        function (g,G)
        local N;

        if IsFpGdFpGroupoidElm(g)  then
                 N:=g!.parent;
              if N=G then
                 return true;
                 else
                 return false;
              fi;
        else
        return false;
        fi;
end);




InstallOtherMethod( \= , "for two fp groupoids" ,
                          [IsFpGdFpGroupoid, IsFpGdFpGroupoid],
        function (G1,G2)
        if G1!.objects = G2!.objects and
           G1!.generators = G2!.generators and
           G1!.sources = G2!.sources and
           G1!.targets = G2!.targets and
           G1!.relators = G2!.relators then
        return true;
        else
        return false;
        fi;
end);

##########################################################################################




InstallGlobalFunction( FpGroupToFpGroupoid, 
               "method for changing Fp Group to be Fp Groupoid",
function(arg)
local G,v,F, gensF, rels, L, Rels, Objs, Gens, O, Rel2List;
if Length(arg)>1 then G:=arg[1]; v:=arg[2]; else G:=arg[1]; fi;
F:=FreeGroupOfFpGroup(G);
gensF:=GeneratorsOfGroup(F);
rels:=RelatorsOfFpGroup(G);
L:=Concatenation(List([1..Length(gensF)],i->[gensF[i],gensF[i]^-1]));
########################
Rel2List:=function(R,L)
local l1,l2,K,C,i,j,k,A;
l1:=Length(R);   
l2:=Length(L);
K:=Concatenation(List([1..l2/2],i->[-i,i]));
C:=[];
k:=1;
A:=[];   
A[1]:=StructuralCopy(R);
  for i in [1..l1] do
     for j in[1..l2] do
         if Length(L[j]*A[k])=Length(A[k])-1 
              then  k:=k+1;
                A[k]:=L[j]*A[k-1];
                Add(C,K[j]);
         fi;
     od;
  od;
return C;
end;
######################
Rels:=List([1..Length(rels)],i->Rel2List(rels[i],L));
Gens:=[1..Length(gensF)];
if Length(arg)>1 then return FpGroupoid([v],List(Gens,x->[v,x,v]),Rels); else
                      return FpGroupoid([1],List(Gens,x->[1,x,1]),Rels);
fi;
end);


