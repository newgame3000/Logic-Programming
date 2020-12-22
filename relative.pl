:-include("predicats.pl").

brother(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'M'), X \== Y,!.
sister(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'F'), X \== Y,!.
daughter(X,Y):- mother(Y,X), pol(X,'F'),!.
daughter(X,Y):- father(Y,X), pol(X,'F'),!.
son(X,Y):- father(Y,X), pol(X,'M'),!. 
son(X,Y):- mother(Y,X), pol(X,'M'),!. 

move(X,Y):- mother(X,Y).
move(X,Y):- father(X,Y).
move(X,Y):- daughter(X,Y).
move(X,Y):- son(X,Y).
move(X,Y):- brother(X,Y).
move(X,Y):- sister(X,Y).

prolong([X|T], [Y,X|T]):- move(X,Y), not(member(Y,[X|T])).

to_relationship([_], []) :- !.

to_relationship([X, Y | T], ['daughter' | R]) :-
	daughter(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['son' | R]) :-
	son(Y,X),
	pol(Y,'M'),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['mother' | R]) :-
	mother(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['father' | R]) :-
	father(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['brother' | R]) :-
	brother(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['sister' | R]) :-
	sister(Y, X),
	to_relationship([Y | T], R).

search([X | T], X, [X | T]).

search(X, Y, R) :-
	prolong(X, Z),
	search(Z, Y, R).

relative(R_E,X,Y):- search([X], Y, R), to_relationship(R,R2), reverse(R2,R_E).
