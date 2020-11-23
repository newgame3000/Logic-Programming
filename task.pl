s_list(['man','woman']).
g_list(['lives','loves']).
t_list(['that']).

an_s1(B):- s_list(H), member(B,H).
an_t(A):- t_list(H),  member(A,H).
an_g(A):- g_list(H),  member(A,H).


:- op(200, xfy, '&').
:- op(201, xfy, '=>').

test(T,Res):- append(T1,T2,T), an_s(T1,'X',A,B), an_gs(T2,X), Res=..[A,'X',B=>X].

an_s([T1,T2,T3,T4],X,A,C):- an_s([T1,T2],X,A,B), an_t(T3), an_g(T4), D=..[T4,X], C = B & D.
an_s(['every',T2],X,all,B):- an_s1(T2), B=..[T2,X].
an_s(['a',T2],X,exist,B):- an_s1(T2), B=..[T2,X].

an_gs([Z1|Z2],X):- an_g(Z1), an_s(Z2,'Y',A,B), H=..[Z1,'X','Y'], X=..[A,'Y',B & H].































