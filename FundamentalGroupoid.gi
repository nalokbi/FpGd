InstallMethod( FundamentalGroupoidOfRegularCWComplex, 
               "method for finding fundamental groupoid", 
               [IsHapRegularCWComplex, IsList],
function(Y,V)
local Fun_1,L,K,vector_field, path, x, N,M,F,gens,i,j,Rels,RELs,SIGNs,U,J,fun_3,1LL,y,z;

Y!.vectorField:=fail;
Y!.inverseVectorField:=fail;
Y!.criticalCells:=fail;
Fun_1:=function(Y)
local P,base,e,bool, b, vertices,edges, r,x,w, gens, rels, 
      cells, 0cells,1cells, 2cells, 2boundaries, deform,BOOL;
base:=1;
BOOL:=true;
if Dimension(Y)<4 then
cells:=CriticalCellsOfRegularCWComplex(Y);
else
cells:=CocriticalCellsOfRegularCWComplex(Y,3);
fi;
Y!.criticalCells:=cells;
###########################################################
P:=SSortedList(List(Y!.orientation[1],Sum));
if P=[0] then Y!.homotopyOrientation:=Y!.orientation{[1,2,3]};
else
P:=TruncatedRegularCWComplex(Y,2);;
P!.orientation:=fail;
OrientRegularCWComplex(P);
Y!.homotopyOrientation:=P!.orientation;
fi;
Unbind(P);
###########################################################
0cells:=Filtered(cells,x->x[1]=0);
Apply(0cells,x->x[2]);
1cells:=Filtered(cells,x->x[1]=1);
Apply(1cells,x->x[2]);
2cells:=Filtered(cells,x->x[1]=2);
Apply(2cells,x->x[2]);
2boundaries:=List(2cells,x->[Y!.boundaries[3][x],Y!.homotopyOrientation[3][x]]);
Apply(2boundaries,x->[x[1]{[2..Length(x[1])]},x[2]]);
Apply(2boundaries,x->List([1..Length(x[1])],i->x[1][i]*x[2][i]));
deform:=ChainComplex(Y)!.homotopicalDeform;
Apply(2boundaries,x->Flat(List(x,a->deform(1,a))));
vertices:=[deform(0,base)];
edges:=[];
###################################
if not Length(0cells)=1 then 
bool:=true;
while bool do
bool:=false;
for e in 1cells do
b:=Y!.boundaries[2][e];
b:=b{[2,3]};
Apply(b,x->deform(0,x));
if b[1] in vertices and not b[2] in vertices
then Add(edges,e); Add(vertices,b[2]); bool:=true;
fi;
if b[2] in vertices and not b[1] in vertices
then Add(edges,e); Add(vertices,b[1]); bool:=true;
fi;
od;
od;
1cells:=Difference(1cells,edges);
1cells:=Filtered(1cells,e->deform(0,Y!.boundaries[2][e][2]) in vertices);
fi;
return [1cells,2boundaries];
end;
###########################
L:=Fun_1(Y);
###########################

#######################################
vector_field:=function(Y,V)
local track,cc,c,p,L,A,A0,A1,i,w,e;

track:=function(v,c)
local vf,vf_i,ver,edg;
vf:=Y!.vectorField[1];
vf:=Filtered(vf,x->IsInt(x));
vf_i:=Y!.inverseVectorField[1];
ver:=[v];
edg:=[vf_i[Position(vf,v)]];
while true do
        w:=Filtered(Y!.boundaries[2][edg[Length(edg)]]{[2,3]},x->not x=ver[Length(ver)])[1];
        if not w=c then
        Add(ver,w);
        e:=vf_i[Position(vf,w)];
        Add(edg,e);
        if c in Y!.boundaries[2][e]{[2,3]} then break; fi;
        else break;
        fi;
od;
return [Reversed(Concatenation(ver{[2..Length(ver)]},[c])),Reversed(edg)];
end;
#################   END   ##############
cc:=CriticalCells(Y);
c:=Filtered(cc,x->x[1]=0)[1][2];
if c in V then 
   p:=Position(V,c);
   Remove(V,p);
   Add(V,c,1);
fi;
if not c in V then 
L:=track(V[1],c);
Unbind(Y!.vectorField[1][Position(Y!.vectorField[1],V[1])]);

for i in [1..Length(L[2])] do
    Y!.vectorField[1][L[2][i]]:=L[1][i];
od;
Y!.inverseVectorField[1]:=List(Filtered(Y!.vectorField[1],x->IsInt(x)),y->Position(Y!.vectorField[1],y));
fi;
if Length(V)>1 then
for x in V{[2..Length(V)]} do
    y:=Position(Y!.vectorField[1],x);
    Unbind(Y!.vectorField[1][y]);
    z:=Position(Y!.inverseVectorField[1],y);
    Unbind(Y!.inverseVectorField[1][z]);
    Y!.inverseVectorField[1]:=Filtered(Y!.inverseVectorField[1],z->IsBound(z)); 
od;
fi;
A:=Filtered(Y!.criticalCells,y->y[1]=2);
A1:=List(Filtered([1..Y!.nrCells(1)],x->not x in Y!.inverseVectorField[1]), y->[1,y]);
if Length(Y!.vectorField)>1 then
A1:=List(Filtered([1..Y!.nrCells(1)],x->not x in Y!.inverseVectorField[1] and not x in Y!.vectorField[2]), y->[1,y]);
Append(A,A1);
fi;
A0:=List(V,y->[0,y]);
Append(A,A0);
Y!.criticalCells:=A;
return true;
end;
#################################
Y!.vectorField:=fail;
Y!.inverseVectorField:=fail;
Y!.criticalCells:=fail;
vector_field(Y,V);
#################################
path:=function(e)
local 1cc,v1,v2,L1,L2,x;
1cc:=Filtered(Y!.inverseVectorField[1],x->IsBound(x));

1LL:=List(1cc,x->[x,Y!.boundaries[2][x]{[2,3]}]);


v1:=Y!.boundaries[2][e][2];
v2:=Y!.boundaries[2][e][3];
L1:=[e];





if not v1 in V then 
while true do
z:=Position(Y!.vectorField[1],v1);
Add(L1,z);
v1:=Filtered(Y!.boundaries[2][z]{[2,3]},x->not x=v1)[1];
if v1 in V then break; fi;
od;
fi;

L1:=Reversed(L1);


L2:=[e];
if not v2 in V then 
while true do
z:=Position(Y!.vectorField[1],v2);
Add(L2,z);
v2:=Filtered(Y!.boundaries[2][z]{[2,3]},x->not x=v2)[1];
if v2 in V then break; fi;
od;
fi;

if Length(L2)=1 then L2:=[]; fi;
L2:=L2{[2..Length(L2)]};
Append(L1,L2);

return L1;
end;
#################################
K:=List(Filtered(Y!.criticalCells,x->x[1]=1),y->y[2]);

N:=[];
for x in K do
    Add(N,path(x));
od;

M:= List(N,L->[Filtered(Y!.boundaries[2][L[1]]{[2,3]},x-> x in V)[1],
               Filtered(Y!.boundaries[2][L[Length(L)]]{[2,3]},x-> x in V)[1]]);


#################################

F:=FreeGroupoid(V,List([1..Length(M)],i->[M[i][1],i,M[i][2]]));
gens:=GeneratorsOfGroupoid(F);


fun_3:=function(g)
local L,s,t,e;
L:=[g];
s:=Source(g);
t:=Target(g);
if not t=V[1] then
for e in gens do
    if Source(e)=t then t:=Target(e); Add(L,e); fi;
    if t=V[1] then break; fi;
od;
fi;
if not s=V[1] then
for e in gens do
    if Target(e)=s then s:=Source(e); Add(L,e,1); fi;
    if s=V[1] then break; fi;
od;
fi;

return L;
end;
J:=List(gens,x->fun_3(x));
U:=[J[1]];
for i in [2..Length(J)] do
    if not List(J[i],x->[x!.source,x!.list[1],x!.target]) in List(U,L->List(L,x->[x!.source,x!.list[1],x!.target]))
    then Add(U,J[i]); fi;
od;
U:=Filtered(U,x->not x=[]);
for x in U do
    if not Source(x[1])=V[1] then Add(x,x[Length(x)]^-1,1); fi;
    if not Target(x[Length(x)])=V[1] then Add(x,x[1]^-1); fi;
od;

RELs:=List(L[2],i->[]);
SIGNs:=List(L[2],i->[]);
for i in [1..Length(RELs)] do
    Add(RELs[i],List(L[2][i],x->U[Position(L[1],AbsoluteValue(x))]));
    Add(SIGNs[i],List(L[2][i],x->SignInt(x)));
od;
RELs:=RELs[1];  SIGNs:=SIGNs[1];
Rels:=List(RELs,x->[]);
for i in [1..Length(RELs)] do
for j in [1..Length(RELs[i])] do
    if SIGNs[i][j]=-1 then Add(Rels[i],List(Reversed(RELs[i][j]),x->x^-1)); 
    else
    Add(Rels[i],RELs[i][j]);
    fi;
od;
od;
Rels:=List(Rels,x->Flat(x));



return F/List(Rels,x->FpGdProduct(Reversed(x)));
end); 

##########################################################################################






