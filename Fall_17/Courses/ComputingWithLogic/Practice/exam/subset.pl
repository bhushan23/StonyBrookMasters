
find(X, []) :- false.
find(X, [X|_]).
find(X, [H|T]) :-
  find(X, T).

isSubSet([], L).
isSubSet([H|T], L) :-
  find(H, L),
  !,
  isSubSet(T, L).

setEqual(L1, L2) :-
  isSubSet(L1, L2),
  isSubSet(L2, L1).
