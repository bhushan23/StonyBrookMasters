member(X, []) :- false.
member(X, [X|_]).
member(X, [H|T]) :-
  member(X, T).

append([], X, X).
append([H|T], L, [H|L1]) :-
  append(T, L, L1).

union(L1, L2, R) :-
  findall(L, (member(L, L2), \+member(L, L1)),R1),
  append(L1,R1,R).
