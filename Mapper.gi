#####################################################################
#0
#F  cluster
##
##  
##  
InstallGlobalFunction( cluster, function(S,r,f)
local clusters, Y, P, C, b, i, j;
if Length(S)=0 then 
  return S; 
fi;
b:=[];
b[1]:=List(S,x->[1,0]);
b[2]:=[];
for i in [1..Length(S)] do
    for j in [i+1..Length(S)] do
            if f(S[i],S[j])<=r then 
                 Add(b[2],[2,i,j]); 
            fi;
   od;
od;
if Length(b[2])>0 then b[3]:=[]; fi;
Y:=RegularCWComplex(b);;
P:=PiZero(Y);
C:=Classify([1..Length(S)],P[2]);
clusters:=List(C,x->S{x});
return clusters;
end);
#
#####################################################################
#0
#F  cluster_alte
##
##  
##  


cluster_alte:=function(S,dS,epsilon)
local SS,i,kk,l,t,K,k,ll,G,HausdorffDistance;
l:=Length(S);
if IsList(S[1]) then 
  ll:=Length(S[1]); 
fi;
##################
G:=function(arg,F,d,epsilon)
local I,n,j,i,l;
l:=Length(arg);
if IsList(arg[1])=false then
  I:=List([1..l],i->[arg[i]]);
else
  I:=arg;
fi;
n:=0;
for j in [1..l-1] do
        for i in [j+1..l] do
           if F(I[j],I[i],d)<>fail and
          F(I[j],I[i],d)<=epsilon then 
              I[j]:=Concatenation(I[j],I[i]);
              I[i]:=[];
           fi;
       od;
od;
return Filtered(I,x->not x=[]);
end;
#################
HausdorffDistance:=function(N,M,d)
local n,m,x,y,N1,M1;
if (N=[] or M=[]) then return fail;
else
if Length(N)<Length(M) then
  N1:=N;   
  M1:=M;
else
  N1:=M;   
  M1:=N;
fi;
n:=Length(N1);  m:=Length(M1);
if m=1 then 
    return AbsoluteValue(N1[1]-M1[1]);
elif m=1 and Length(N)>1 then 
    return d(N1,M1);
else
     return Minimum(Flat(List([1..n],j->
           List([1..m],i->d(N1[j],M1[i])))));
  fi;
fi;
end;
#################
SS:=[];
SS[1]:=S;
SS[2]:=G(SS[1],HausdorffDistance,dS,epsilon);
i:=2;
while Length(SS[i-1])>Length(SS[i]) do
  i:=i+1;
  SS[i]:=G(SS[i-1],HausdorffDistance,dS,epsilon);
od;
if IsList(S[1])=false then 
  return SS[i]; 
else 
  k:=SS[i];
  kk:=Length(SS[i]);
  t:=List([1..kk],j->Length(k[j]));
  K:=List([1..kk],r->List([0..t[r]/ll-1],j->List([1+j*ll..(1+j)*ll],
  i->k[r][i])));
  return K;
fi;
end;
#
#######################################################
VectorsToCovarianceMatrix:=function( S )
local n, a, A, V;
      n:=Length(TransposedMat(S)[1]);
      a:=S-List([1..n],i->1)*S/n;
      A:=TransposedMat(a)*a;
      V:=A/n;
      return V;   
end;
#
#######################################################
#
FloatSpectrum_1:=function(arg)
local M,n,k,fun,K,a,b,N,A,i;
M:=arg[1];
n:=arg[2];
k:=Length(M);
####################
  fun:=function(N)
    local v,i,L,S,M,w;
      v:=List([1..k],x->1);
      for i in [1..n] do
        S:=List(N*v,x->x^2);
        M:=1/Sum(S)^0.5;
        v:=M*N*v;
      od;
      w:=Sum(List(v,x->x^2))^0.5;
      L:=[(v*N*v)/w,v/(v[Length(v)])];
  return L;
end;
####################
N:=M;
a:=fun(N);
K:=[[a[1]],[a[2]]];
for i in [2..k] do
  a:=[K[1][Length(K[1])],K[2][Length(K[2])]];
  A:=Sum(List(a[2],x->x^2))^0.5;
  b:=List(a[2]/A,x->[x]);
  N:=N-(a[1]*( b*TransposedMat(b) ));
  a:=fun(N);
  Add(K[1],a[1]);
  Add(K[2],a[2]);
od;

return K;
end;
#
#######################################################
#
FloatSpectrum_2:=function(arg)
local M,m,n,v,d,bw,zw,it_num,rot_num,U,i,j,thresh,p,q,
       gapq,term,termp,termq,theta,t,c,s,tau,h,g;
M:=arg[1];
m:=arg[2];
n:=Length(M);
v:=(List([1..n],i->List([1..n],j->1)))^0;
d:=List([1..n],i->M[i][i]);
bw:=List(d,x->x);
zw:=List(d,x->0);
it_num:=0;
rot_num:=0;
U:=List([1..n],i->List([1..n],j->0.0));
for i in [1..n] do
    for j in [i..n] do
        U[i][j]:=1.0*M[i][j]^2;
    od;
od;
while it_num < m do
     it_num := it_num + 1;
     thresh := Sqrt(Sum(List(U,x->Sum(x))))/(4.0 * n);
     if thresh = 0.0 then
      break;
     fi;

     for p in [1 .. n] do
        for q in [p + 1 .. n] do
            gapq := 10.0 * AbsoluteValue ( M[p][q] );
            termp := gapq + AbsoluteValue ( d[p] );
            termq := gapq + AbsoluteValue ( d[q] );
            if (4 < it_num and 
               termp = AbsoluteValue( d[p] ) and 
               termq = AbsoluteValue( d[q] ) ) 
               then
               M[p][q] := 0.0;
            elif thresh <= AbsoluteValue( 1.0*M[p][q] ) then
               h := d[q] - d[p];
               term := AbsoluteValue( h ) + gapq;
               if term = AbsoluteValue( 1.0*h ) then
                    t := M[p][q] / h;
               else
                    theta := 0.5 * h / M[p][q];
                    t := 1.0 / ( AbsoluteValue( theta ) + 
                                    ( 1.0 + theta * theta )^0.5 );
                    if theta < 0.0 then 
                         t := - t;
                    fi;
               fi;

               c := 1.0 / ( 1.0 + t * t )^0.5;
               s := t * c;
               tau := s / ( 1.0 + c );
               h := t * M[p][q];

               zw[p] := zw[p] - h;                  
               zw[q] := zw[q] + h;
               d[p] := d[p] - h;
               d[q] := d[q] + h;
               M[p][q] := 0.0;

               for j in [1..p - 1] do
                   g := M[j][p];
                   h := M[j][q];
                   M[j][p] := g - s * ( h + g * tau );
                   M[j][q] := h + s * ( g - h * tau );
               od;

               for j in [p + 1..q - 1] do
                   g := M[p][j];
                   h := M[j][q];
                   M[p][j] := g - s * ( h + g * tau );
                   M[j][q] := h + s * ( g - h * tau );
               od;

               for j in [q + 1..n]  do
                   g := M[p][j];
                   h := M[q][j];
                   M[p][j] := g - s * ( h + g * tau );
                   M[q][j] := h + s * ( g - h * tau );
               od;

               for j in [1..n] do
                   g := v[j][p];
                   h := v[j][q];
                   v[j][p] := g - s * ( h + g * tau );
                   v[j][q] := h + s * ( g - h * tau );
               od;

               rot_num := rot_num + 1;
            fi;
        od;
    od;
    bw := bw + zw;
    d := bw;
    zw := 0.0*zw;
od;
return [d,v];
end;
#
#####################################################################
#0
#F  FloatSpectrum
##
##  
##  
InstallGlobalFunction( FloatSpectrum, function(arg)
local k,K;
k:=Length(arg);
if k=2 then  K:=FloatSpectrum_1(arg[1],arg[2]); fi;
if k=3 then  K:=FloatSpectrum_2(arg[1],arg[2],arg[3]); fi;
return K;
end);
#
#####################################################################
#0
#F  Mapper
##
##  
##  
InstallGlobalFunction( GeneralMapper, function(S,f,P,dx,epsilon,dz,r,C)
local  L, i, s , N, t, tol, nerve;
####################
  nerve:=function(L,n)
  local S, V, m, i, x, T;

  V:=[1..Length(L)];
  S:=List(V,i->[i]);
  m:=1; 
  T:=true;

  while m<=n and T=true do
      m:=m+1;
      T:=false;
      for x in Combinations(V,m) do
          if Length(Intersection(List(x,i->L[i])))>0 
              then Add(S,x); 
              T:=true; 
          fi;
      od;
  od;

S:=List(S,x->SSortedList(x));
S:=SSortedList(S);
return SimplicialComplex(S);

end;
####################
L:=List(P,x->[]);
for s in S do
for i in [1..Length(P)] do
if dz(f(s),P[i]) <=r then Add(L[i],s); fi;
od;
od;

L:=List(L,x->C(x,epsilon,dx));
L:=Concatenation(L);
L:=Filtered(L,x->Length(x)>0);

N:=nerve(L,10);
N!.clustersizes:=List(L,Size);
N!.clusters:=L;
return N;
end);
#
#####################################################################
#0
#F  ReadAMCfileAsPatternMatrex
##
##  
##  
InstallGlobalFunction( ReadAMCfileAsPatternMatrex, 
function(dir)  
local instr,f,A,J,i,j,K,T,s,d,k,TexToList,S;
instr:=InputTextFile(dir);
f:=true;
A:=[]; J:=[]; i:=0; j:=0;
while not f=fail do
    j:=j+1;
    f:=ReadLine(instr);
    Add(A,f);
    if f=Concatenation(String(1+i),"\n") then
      i:=i+1; Add(J,j); 
    fi;
od;
d:=function(f) return f{[1..Length(f)-1]}; end;
A:=List([4..Length(A)-1],i->d(A[i]));;
k:=Int(Length(A)/30);
A:=List([0..k-1],i-> List([1+i*30..(1+i)*30],j->A[j]));;
#######################################################
TexToList:=function(x)                               
local l,i, j, I, Y;                                  
l:=Length(x);                                        
I:=[];                                               
for i in [1..l] do                                   
if x{[i]}=" " or x{[i]}="\r"  then Add(I,i); fi;     
od;                                                  
Y:=[];
for j in [1..Length(I)-1] do
    Add(Y,Float(x{[I[j]+1..I[j+1]-1]}));
od;
return Y;                                            
end;                                                 
#######################################################
S:= List([1..Length(A)],j-> Flat(List([1..Length(A[j])] ,
i->TexToList(A[j][i]))));;
for i in [1..Length(S)] do
    S[i]:=Concatenation([i*1.0],S[i]);
od;
return S;
end);

######################     THE END    ##########################