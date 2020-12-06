%
%start=[b,b,b,b,e,w,w,w].
%final=[w,w,w,e,b,b,b,b].
%

go([b,e,w],X):- X=[b,w,e]; X=[e,b,w].

go([b,e,b],X):- X=[e,b,b].
go([b,b,e],X):- X=[b,e,b].
go([w,b,e],X):- X=[w,e,b].

go([w,e,w],X):- X=[w,w,e].
go([e,w,w],X):- X=[w,e,w].
go([e,w,b],X):- X=[w,e,b].

go([b,w,e],X):- X=[e,w,b].
go([e,b,w],X):- X=[w,b,e].

move(At,To):- append(X,[A,B,C|T],At), go([A,B,C],G), append(X,G,H), append(H,T,To).

prolong([X|T],[Y,X|T]):- move(X,Y), not(member(Y,[X|T])).

path(X,Y,P):- bdth([[X]],Y,P),write(P).

bdth([[X|T]|_],X,[X|T]).
bdth([P|QI],X,R):- findall(Z,prolong(P,Z),T),
                   append(QI,T,QO),!,
                   bdth(QO,X,R).

bdth([_|T],Y,L):- bdth(T,Y,L).

search_id(X,Y,P) :- int(N), search_id(X, Y, P, N), !,write(P).
search_id(X,Y,P,N) :- depth_id([X], Y, P, N).

int(1).
int(N) :- int(M), N is M+1.

depth_id([X|T],X,[X|T], _).
depth_id(X,Y,P,N) :- N>0, prolong(X, XX), N1 is N-1, depth_id(XX, Y, P, N1).

time_bdth(X,Y,Time):- get_time(Start), search_id(X,Y,P), get_time(End), Time is End - Start.
time_search_id(X,Y,Time):- get_time(Start), path(X,Y,P), get_time(End), Time is End - Start.
