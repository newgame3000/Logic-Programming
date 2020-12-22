:-include("predicats.pl").

brother(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'M'), X \== Y.
sister(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'F'), X \== Y.
daughter(X,Y):- mother(Y,X), pol(X,'F').
daughter(X,Y):- father(Y,X), pol(X,'F').
son(X,Y):- father(Y,X), pol(X,'M'). 
son(X,Y):- mother(Y,X), pol(X,'M'). 


question_list(['How','many','Who']).
gl_list(['Is','is','are','Are']).
s_list(['mother','father','son','daughter','brother','sister','mothers','fathers','sons','daughters','brothers','sisters']).
o_list(['do','does','of']).
m_list(['he','she','him','her']).

name(NAME,J):-
m_list(M),
member(NAME,M), nb_getval('L_NAME', NAME).

name(NAME,NAME):-
m_list(M),
not(member(NAME,M)), nb_setval('L_NAME', J).


%% How many object does name have?
question(X,R):-

	question_list(Q),
	o_list(O),
	s_list(S),

	append([Q1|_],T,X),
	member(Q1,Q),
	append([Q2|_],T1,T),
	member(Q2,Q),
	append([OB|_],T2,T1),
	member(OB,S),
	append([DO|_],T3,T2),
	member(DO,O),
	append([NAME|_],T4,T3),
	name(NAME,N),
	T4 = ['have'|_],
	score(OB, N, R).

%% Is name object of name2?
question(X):-

	gl_list(Q),
	o_list(O),
	s_list(S),

	append([Q1|_],T,X),
	member(Q1,Q),
	append([NAME|_],T1,T),
	name(NAME,N1),
	append([OB|_],T2,T1),
	member(OB,S),
	append([DO|_],T3,T2),
	member(DO,O),
	append([NAME2|_],T4,T3),
	name(NAME2,N2),
	rel(OB,N1,N2).

%% Who is object of name?
question(X,R):-
	question_list(Q),
	gl_list(G),
	o_list(O),
	s_list(S),

	append([Q1|_],T,X),
	member(Q1,Q),
	append([H|_],T1,T),
	member(H,G),
	append([OB|_],T2,T1),
	member(OB,S),
	append([DO|_],T3,T2),
	member(DO,O),
	append([NAME|_],T4,T3),
	name(NAME,N),
	rel(OB,R,N).

rel('father',A,B):- father(A,B).
rel('mother',A,B):- mother(A,B).
rel('son',A,B):- son(A,B).
rel('sister',A,B):- sister(A,B).
rel('daughter',A,B):- daughter(A,B).
rel('brother',A,B):- brother(A,B).

score('mothers', NAME, 1).
score('fathers', NAME, 1).

score('sons', NAME, R):-
setof(X, son(X,NAME),RL),
length(RL,R).

score('daughters', NAME, R):-
setof(X, daughter(X,NAME),RL),
length(RL,R).

score('brothers', NAME, R):-
setof(X, brother(X,NAME),RL),
length(RL,R).

score('sisters', NAME, R):-
setof(X, sister(X,NAME),RL),
length(RL,R).






