len([],0).
len([H|T],N):- len(T,A), N is A + 1. 

mem([H|T],H).
mem([A|T],H):- mem(T,H).

app([],X,X).
app([H|T],A,[H|B]):- app(T,A,B).

rem(X,[X|T],T).
rem(X,[H|T],[H|B]):- rem(X,T,B).

per([],[]).
per([H|T],X):- rem(H,X,A), per(T,A).

sub(S,H):- app(A,C,H),app(S,B,C).

remnstd(L,X,N):- app(X, Y, L), len(Y, N).

myremn([],[],0).
myremn([L|H],[],N):-myremn(H,[],N2), N is N2 + 1.
myremn([L|H],[L|A],N):-myremn(H,A,N).

maxstd(L,N):- app(H,[A|_],L), len(H,N), max(A,L).

max(A,[]).
max(A,[L|H]):- max(A,H), A>=L.

mymax(L,N):- max2(L,N,X).

max2([X],0,X).
max2([X,Y|T], 0, X) :- X >= Y, max2([X|T], 0, X).
max2([H|T], N, X) :- max2(T, N1, X), N is N1 + 1, X >= H.

zamena(X,Y,N,T):-myremn(X,L,N), app(L,Y,T).
