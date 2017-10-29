makeListStr([], []).
makeListStr([H|T], [H|List]) :-
  makeListStr(T, List).

member(X, [X|_]).
member(X, [_|T]) :-
  member(X, T).

memberAt(X, [X|_], 0).
memberAt(X, [_|T], Index) :-
  memberAt(X, T, Index1),
  Index is Index1 + 1.


append([], List, List).
append([H|T], List, [H|OutList]) :-
  append(T, List, OutList).

len([], 0).
len([_|T], L) :-
  len(T, L1),
  L is L1 + 1.

delete(X, [], []) :- fail.
delete(X, [X|T], T).
delete(X,[H|T], [H|List]) :-
  delete(X, T, List).

program:-
  member(X,[1,2,3,4,5,6]),
  write(X),
  nl,
  fail; true.

permute([], []).

permute([X|T], List) :-
  permute(T, List1),
  delete(X, List, List1).

addAtFront(List, H, [H|List]).

reverse([], []).
reverse([H|T], List) :-
  %addAtFront(List1, H, List),
  reverse(T, List1),
  append(List1, [H], List).

reverse1(L1, L2) :-
  reverseAcc(L1, [], L2).

reverseAcc([], Acc, Acc).
reverseAcc([X|T], Acc, AccuAfter) :-
  reverseAcc(T, [X|Acc], AccuAfter).
