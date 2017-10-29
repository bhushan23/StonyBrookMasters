:- G = graph([a,b,c,d,e,f,g], [e(a,b), e(a,c), e(a,d), e(c,b)]),  degree(G, a, Degree), writeln(Degree),fail; true.


degree(graph(_,Es), N, D) :-
	findall(Y, member(e(N,Y), Es), L),
	length(L,D).