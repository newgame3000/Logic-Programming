sorev1_1(P,L,K,S):-P=\=L,P=\=K,P=\=S,L=\=K,L=\=S,S=\=K.

sorev1_2(P,_,K,_):-P=\=1,!, K is 4.
sorev1_2(_,_,_,_).

sorev2_1(P,_,K,_):-K is 3,!,P is 4.
sorev2_1(_,_,_,_).

sorev2_2(P,_,_,S):-P<S.

sorev3_1(P,L,_,_):-L=\=1,!,P is 3.
sorev3_1(_,_,_,_).

sorev3_2(_,_,K,S):- K is 2,!,S=\=4.
sorev3_2(_,_,_,_).

sorev4_1(_,_,K,S):- K is 1,!, S is 2.
sorev4_1(_,_,_,_).

sorev4_2(_,L,_,S):-S=\=2,!,L=\=2.
sorev4_2(_,_,_,_).

mesta(P,L,K,S):-
T=[1,2,3,4], member(P,T), member(L,T), member(K,T), member(S,T),
sorev1_1(P,L,K,S),sorev1_2(P,L,K,S),sorev2_1(P,L,K,S), sorev2_2(P,L,K,S), sorev3_1(P,L,K,S), sorev3_2(P,L,K,S),sorev4_1(P,L,K,S), sorev4_2(P,L,K,S).