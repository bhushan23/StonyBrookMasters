
findForNode(X, [], []).
findForNode(X,[[X,D]|T], [D|List]) :-
  findForNode(X,T,List).

findForNode(X, [[S,D]|T], List) :-
  findForNode(X,T, List).

  append([], X, X).
  append([H|T], L, [H|L1]) :-
    append(T, L, L1).

find_directly_reachable([], _, []).
find_directly_reachable([H|T], Links, List) :-
  findForNode(H, Links, ReachableList),
  append([], ReachableList, List).
