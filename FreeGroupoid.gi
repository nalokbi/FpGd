SimplifyList:=function(w)
local l, n, v,i,w_new,x, j;
    l:=Length(w);
    if l=0 then return [];
    else
    w_new:=ShallowCopy(w);
     n:=Int(l/2); 
    for j in [1..n] do
        v:=ShallowCopy(w_new);
        i:=0;
        for x in List([1..Length(v)-1],i->v[i]) do
          i:=i+1;
          if x=-v[i+1] then Unbind(v[i]); Unbind(v[i+1]); fi;
        od;
    w_new:=Filtered(v,a->IsBound(a));
    od;
        return w_new;
    fi;
end;


##############################################################################



InstallMethod(\=,"for two words in Free Groupoid", IsIdenticalObj, [IsFpGdFreeGroupoidElm, IsFpGdFreeGroupoidElm], 0, 
function(w1,w2)
return 
      w1!.source = w2!.source and
      w1!.target = w2!.target and
      w1!.list = w2!.list;
end);
#####################################################################

InstallTrueMethod(IsMultiplicativeElement,IsFpGdFreeGroupoidElm);

#####################################################################

InstallMethod
(  \*,
   "for two free groupoid elements in 'IsFpGdFreeGroupoidElm' ",
   [IsFpGdFreeGroupoidElm, IsFpGdFreeGroupoidElm],

   function( w1 , w2 )
       local w, F ;
       
       if not (w2!.target = w1!.source) then
       Print("Words are not composable. \n");
       return fail;
       else
       F:=w1!.parent;
       w:=SimplifyList(Concatenation(w1!.list,w2!.list));
       return Objectify(FpGdFreeGroupoidElm,
                        rec(list:=w, source:=w2!.source, target:=w1!.target, parent:=F));
       fi;
   end 
);

#############################################################################

InstallGlobalFunction(FpGdProduct, [IsFpGdFreeGroupoidElm],
                      function(w)
                      local k,L,i;
                      k:=Length(w);
                      L:=w[1];
                      for i in [2..k] do
                      L:=L*w[i];
                      od;
return L;
end);

#############################################################################

 InstallMethod
(  \^,
   "for one free groupoid element in 'IsFpGdFreeGroupoidElm' ", [IsFpGdFreeGroupoidElm, IsInt],
   function( g,n )
   local r,L, ginvList;
   L:=g!.list;
   r:=Length(L);
   if (n=-1) then
        if (r=1) then
         return Objectify(FpGdFreeGroupoidElm,
                        rec(list:=-g!.list, source:=g!.target, target:=g!.source, parent:=g!.parent));
        else
        ginvList:=List([1..r],i->-L[r-i+1]);
        return Objectify(FpGdFreeGroupoidElm,
                        rec(list:=ginvList, source:=g!.target, target:=g!.source, parent:=g!.parent));
        fi;
   elif (n=1) then 
        if (r=1) then
         return Objectify(FpGdFreeGroupoidElm,
                        rec(list:=g!.list, source:=g!.source, target:=g!.target, parent:=g!.parent));
        else
        ginvList:=List([1..r],i->L[r-i+1]);
        return Objectify(FpGdFreeGroupoidElm,
                        rec(list:=ginvList, source:=g!.source, target:=g!.target, parent:=g!.parent));
        fi;
    else return fail;
   fi;
   end );

###########################################################################

InstallGlobalFunction(FreeGroupoid,
function(arg)
local l,k,L,s,t,g,o,Rec,Name;
  o:=arg[1];
  L:=arg[2];
  k:=Length(L);
  l:=Length(arg);
  if l > 2 then
  Name:=arg[3];
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
      Rec:=rec(objects:=o, generators:=g, sources:=s, targets:=t, name:=Name);
     return Objectify(FpGdFreeGroupoid,Rec);
  fi;
end);


#####################################################################

InstallOtherMethod(GeneratorsOfGroupoid, [IsFpGdFpGroupoid],
                      function(G)
local g, gens, k, i, s, t, a, A;  
g:=G!.generators;
s:=G!.sources;
t:=G!.targets;
k:=Length(g);
a:=[];
A:=[];
gens:=[];
for i in [1..k] do
a[i]:=rec(list:=[g[i]], source:=s[i], target:=t[i], parent:=G);
A[i]:=Objectify(FpGdFpGroupoidElm,a[i]);
Add(gens,A[i]);
od;
return gens;
end);


#####################################################################

InstallOtherMethod(GeneratorsOfGroupoid, [IsFpGdFreeGroupoid],
                      function(G)
local g, gens, k, i, s, t, a, A;  
g:=G!.generators;
s:=G!.sources;
t:=G!.targets;
k:=Length(g);
a:=[];
A:=[];
gens:=[];
for i in [1..k] do
a[i]:=rec(list:=[g[i]], source:=s[i], target:=t[i], parent:=G);
A[i]:=Objectify(FpGdFreeGroupoidElm,a[i]);
Add(gens,A[i]);
od;
return gens;
end);



############################################################################





InstallOtherMethod(Source,
"source of of a generator of a Free Groupoid",
[IsFpGdFpGroupoidElm],
function(f) return f!.source;
end);

InstallOtherMethod(Target,
"target of of a generator of a Free Groupoid",
[IsFpGdFpGroupoidElm],
function(f) return f!.target;
end);


InstallOtherMethod(Length,
"length of of an element of a Groupoid",
[IsFpGdFreeGroupoidElm],
function(f) return Length(f!.list);
end);



################################################################################################


InstallOtherMethod
(  \/,
   "  ",
   [IsFpGdFreeGroupoid, IsList],

   function( F , L )
     local Rels, N, G;
     Rels:=List([1..Length(L)],i->L[i]!.list);
    if L=[] then G:=Objectify(FpGdFpGroupoid,
                                             rec(objects:=F!.objects,
                                                 generators:=F!.generators,
                                                 sources:=F!.sources, 
                                                 targets:=F!.targets, 
                                                 relators:=Rels,
                                                 name:="G"));
    else
     N:=L[1]!.parent;
     Rels:=List([1..Length(L)],i->L[i]!.list);
     G:= Objectify(FpGdFpGroupoid,
                        rec(objects:=F!.objects,
                            generators:=F!.generators,
                            sources:=F!.sources, 
                            targets:=F!.targets, 
                            relators:=Rels,
                            name:=N!.name));
     G!.parent:=N;
     fi;
     return G;
   end);

##################   NEW    ##############

InstallOtherMethod( \in , "for groupoid elements" ,
                          [IsObject, IsObject],
        function (g,G)
        local N;

        if IsFpGdFreeGroupoidElm(g) or IsFpGdFpGroupoidElm(g)   then
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





################################################

InstallOtherMethod( \= , "for two free groupoids" ,
                          [IsFpGdFreeGroupoid, IsFpGdFreeGroupoid],
        function (F1,F2)
        if F1!.objects = F2!.objects and
           F1!.generators = F2!.generators and
           F1!.sources = F2!.sources and
           F1!.targets = F2!.targets then
        return true;
        else
        return false;
        fi;
end);


################################################







InstallGlobalFunction( UnionOfGroupoids, "method for defining union of two groupoids", 
function(G1,G2)
local f,Obj,gens,g1,g2,g12,r1,r2,R1,R2,rels,a,b,x;
##################
f:=function(L,LL,n,m)
local K,J,x;
J:=[n..n+m-1];
K:=[];
for x in L do
   if x>0 then Add(K,J[Position(LL,x)]); else Add(K,(-1)*J[Position(LL,AbsoluteValue(x))]); fi;
od;
return K;
end;
##################
a:=Length(G1!.objects);
b:=Length(G2!.objects);
Obj:=[1..a+b];
g1:=GeneratorsOfGroupoid(G1);
gens:=List(g1,x->[x!.source,x!.list[1],x!.target]);
g2:=GeneratorsOfGroupoid(G2);
for x in g2 do
   Add(gens,[x!.source+a,x!.list[1]+Length(g1),x!.target+a]);
od;
if IsFpGdFpGroupoid(G1) and IsFpGdFpGroupoid(G2) then
r1:=G1!.relators;
R1:=List(r1, x-> f(x,Concatenation(List(g1,x->x!.list)),1,Length(g1)));
r2:=G2!.relators;
R2:=List(r2, x-> f(x,Concatenation(List(g2,x->x!.list)),Length(g1)+1,Length(g2)));
rels:=Concatenation(R1,R2);
return FpGroupoid(Obj,gens,rels);
else
return FreeGroupoid(Obj,gens);
fi;
end);
#######################################################################################
#######################################################################################


