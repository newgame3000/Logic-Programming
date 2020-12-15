:-include("predicats.pl").

svekrov(X,Y):-mother(X,B), father(B,C), mother(Y,C).