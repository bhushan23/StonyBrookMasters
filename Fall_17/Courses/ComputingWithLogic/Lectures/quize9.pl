% GRAPH
max(X, Y, Y) :- X =< Y, !.
max(X, Y, X) :- X > Y.

% 

degreeHelper([], _, PD, PD).

degreeHelper([e(N,_)|T], N, PD, D) :-
	!,
	PD1 is PD + 1,
	degreeHelper(T, N, PD1, D).

degreeHelper([_|T], N, PD, D) :-
	degreeHelper(T,N, PD, D).

degree(graph(_,Es), N, D) :-
	degreeHelper(Es, N, 0, D).


:- G = graph([a,b,c,d,e,f,g], [e(a,b), e(a,c), e(a,d), e(c,b)]),  degree(G, a, Degree), writeln(Degree),fail; true.


degree2(graph(_,Es), N, D) :-
	findall(Y, member(e(N,Y), Es), L),
	length(L,D).

% Undirected graphs

degreeHelperUndirected([X|T], N, PD, D) :-
	(
		X = e(N, _);
		X = e(_, N)
	),
	!.
	PD2 is PD + 1,
	degreeHelperUndirected(T, N, PD2, D).

degree2UnDirectioned(graph(_,Es), N, D) :-
	findall(Y, (member(e(N,Y), Es);member(e(Y,N), Es)), L),
	length(L,D).

% 2. Degree in sorted order

sortByDegree(G, L) :-
	G = graph(Nodes,Edges),
	findDegrees(G, Nodes, NodeDegrees),
	sortNodesByDegree(NodeDegreesm, L).

findDegrees(_, [], []).

findDegrees(G, [N|T], [degree(N,D) | T2]) :-
	degree(G, N, D),
	findDegrees(G, T, T2).

sortNodesByDegree([], []).
sortNodesByDegree(NodeDegrees, [Min|T]) :-
	minDegree(NodeDegrees, Min),
	select(Min, NodeDegrees, Rest),
	sortNodesByDegree(Rest, T).

minDegree([degree(N, D) | NodeDegrees], Min) :-
	minDegreeHelper(NodeDegrees, degree(N,D), Min).

minDegreeHelper([], Min, Min).
minDegreeHelper([degree(N2, D2)|NodeDegrees], degree(N,D), Min) :-
	D < D2,
	!,
	minDegreeHelper(NodeDegrees, degree(N,D), Min).

minDegreeHelper([degree(N2, D2)|NodeDegrees], _, Min) :-
	D < D2,
	!,
	minDegreeHelper(NodeDegrees, degree(N2,D2), Min).


