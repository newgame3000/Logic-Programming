:- include('two.pl').

len([],0).
len([H|T],N):- len(T,A), N is A + 1. 

sum([],0).
sum([H|T],N):- sum(T,A), N is A + H.


sr_ball(T,N):- bagof(X,A^B^grade(A,B,T,X),L), len(L,F), sum(L,K), N is K/F.

ne_sdalgr(G,T):- bagof(2,A^B^grade(G,A,B,2),L), len(L,T).

ne_sdalpr(X,T):-  bagof(2,A^B^grade(A,B,X,2),L), len(L,T).
