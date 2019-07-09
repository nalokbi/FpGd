InstallMethod( VertexGroup, 
               "method for finding vertex group", 
               [IsFpGdFpGroupoid, IsInt],
         function(G,v)
local T,Tinv,gens,ftr,fun,rels,W1,W2,x,RM,L1,LL1,prod,R,F,M,f,K,H,LL,L2,h,ff,s1,s2,s12,i,j;

T:=TreeOfFpGroupoid(G,v);
Tinv:=List(T,x->x^-1);
gens:=GeneratorsOfGroupoid(G);
ftr:=Filtered(gens,x->not x in Concatenation(T,Tinv));
###################################################
fun:=function(p)     # return path from v to p.
   local A,xx,TT,y;
   # if p=v then return []; fi;
   A:=[];
   xx:=Filtered(T,x->Target(x)=p)[1];
   if Source(xx)=v then return xx; fi;   
    TT:=StructuralCopy(T);
    while not Source(xx)=v do

        for y in TT do

            if Target(y)=p then 
                Add(A,y);
                p:=Source(y);
                Unbind(TT[ Position(TT,y) ]);
                #  TT:=SortedList(TT);            may be needed for some examples!!!
                #  if Source(y)=v then break; fi;
                xx:=y;
            fi;
        od;
    od;
A:=List([0..Length(A)-1],i->A[Length(A)-i]);
return FpGdProduct(A);
end;
###################################################
W1:=[];
for x in ftr do
    if Source(x)=v and Target(x)=v then Add(W1,x); fi;
    if Source(x)=v and not Target(x)=v then Add(W1,x*fun(Target(x))^-1); fi;
    if Target(x)=v and not Source(x)=v then Add(W1,fun(Source(x))*x); fi;
    if not Source(x)=v and not Target(x)=v then 
       Add(W1,fun(Target(x))^-1*x*fun(Source(x)));
    fi;
od;
W2:=[];
R:=RelatorsOfFpGroupoid(G);
for x in R do
     if Source(x)=v and Target(x)=v then Add(W2,x); fi;
     if Source(x)=v and not Target(x)=v then Add(W2,x*fun(Target(x))^-1); fi;
     if Target(x)=v and not Source(x)=v then Add(W2,fun(Source(x))*x); fi;
     if not Source(x)=v and not Target(x)=v then 
       Add(W2,fun(Target(x))^-1*x*fun(Source(x)));
     fi;   
od;
L1:=List(W1,x->x!.list);
L2:=List(W2,x->x!.list);

F:=FreeGroup(Length(gens));
H:=FreeGroup(Length(gens));

f:=GeneratorsOfGroup(F);
h:=GeneratorsOfGroup(H);

LL:=List([1..Length(gens)],x->[x]);
LL1:=[];
for x in LL do
   if not x[1] in List(Flat(L1),y->AbsoluteValue(y)) then Add(LL1,x); fi;
od;

if  Length(LL1)<Length(L1)+Length(L1) then 
  for x in LL do
    if not x in Concatenation(L1,LL1)  then
       Add(LL1,x); 
          if Length(LL1)=Length(gens)-Length(L1) then break; fi;
    fi;
  od;
fi;

prod:=function(L) if Length(L)>1 then return FpGdProduct(L); else return L[1]; fi; end;

#L1:=Concatenation(L1,LL1);

ff:=function(M,x) if x in M then return Position(M,x); else return Position(List(M,x->x^-1),x); fi; end;
s1:=List(T,x->ff(gens,x));
s2:=Difference([1..Length(gens)],s1);
s12:=[];
for i in s1 do
    s12[i]:=h[i];
od;
j:=0;
for i in s2 do
    j:=j+1;
    s12[i]:=prod(List(L1[j],x->h[AbsoluteValue(x)]^SignInt(x)));
od;
K:=GroupHomomorphismByImages(F,H,f,s12);
M:= List ( L2, L-> prod( List( L , x -> h[AbsoluteValue(x)]^SignInt(x) ) )  );
rels := Concatenation( List ( M , x-> PreImage(K,x) ) , List(s1,x-> f[x]) );
return F/rels;
end);


#################################################################################################