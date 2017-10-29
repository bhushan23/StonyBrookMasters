member(X, []) :- false.
member(X, [X|T]).
member(X, [H|T]) :-
  member(X, T).

adjacent(graph(_, Es), X, Y) :-
  member(e(X,Y), Es).
adjacent(graph(_, Es), X, Y) :-
    member(e(Y,X), Es).

path(G, A, B, P) :-
  path1(G, A, [B], P).

path1(_, A, [A|P1], [A|P1]).
path1(G, A, [Y|P1], P) :-
  adjacent(G, X, Y),
  \+member(X, [Y|P1]),
  path1(G, A, [X, Y|P1], P).

len([], 0).
len([H|T], Len) :-
    len(T, Len1),
    Len is Len1+1.

append([], List, List).
append([H|T], List, [H|List1]) :-
  append(T, List, List1).


cycle(G, A, P) :-
  adjacent(G, A, B),
  path(G, A, B, P1),
  len(P1, L),
  L > 2,
  append(P1, [A], P).

readFromFile :-
  see('graph.pl'),
  read(X),
  writeln(X),
  seen.
