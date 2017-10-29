

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

  member(X, []) :- false.
  member(X, [X|_]).
  member(X, [H|T]) :-
    member(X, T).

/*  append([], X, X).
  append([H|T], L, [H|L1]) :-
    append(T, L, L1).
*/
union(L1, L2, R) :-
  findall(L, (member(L, L2), \+member(L, L1)),R1),
  append(L1,R1,R).

flatten([], []).
flatten([[H1, H2] | T], [H1, H2 | List]) :-
  flatten(T,List).

deleteAll(X, [], []).
deleteAll(X, [X|T], List) :-
  !,
  deleteAll(X,T,List).

deleteAll(X, [H|T], [H|List]) :-
  X \= H,
  deleteAll(X, T, List).

removeDuplicates([],[]).
removeDuplicates([H|T], [H|Out]) :-
  deleteAll(H, T, NewList),
  removeDuplicates(NewList, Out).

collectNodes(L, Nodes) :-
  flatten(L, FList),
  removeDuplicates(FList, Nodes).


findForNode(X, [], []).
findForNode(X,[[X,D]|T], [D|List]) :-
  !,
  findForNode(X,T,List).

findForNode(X, [[S,D]|T], List) :-
  !,
  findForNode(X,T, List).

append([], X, X).
append([H|T], L, [H|L1]) :-
  append(T, L, L1).

find_directly_reachable([], _, []).
find_directly_reachable([H|T], Links, List) :-
  !,
  findForNode(H, Links, ReachableList),
  find_directly_reachable(T, Links, List1),
  append(ReachableList, List1, List).

find_reachable_rec([], _,_,_,_).
find_reachable_rec([H|T], L, Reachable, R2, Visited) :-
  !,
  find_directly_reachable([H], L, LocalR),
  append([], [H], Visited),
  (
  \+setEqual(LocalR, R2) ->
    union(LocalR, R2, R3),

    findall(X, (member(X, R3), \+member(X,Visited)),NewT),
    %writeln(NewT),
    find_reachable_rec(NewT, L, Reachable, R3, Visited)
  ),
  Reachable = R2.


find_reachable_from(X, L, R) :-
  find_reachable_rec([X], L, R, [], []).

find_directly_reachable2(H, Links, List) :-
  !,
  findForNode(H, Links, ReachableList),
  append([], ReachableList, List).

find_reachable_rec2([], _, R, R, _).
find_reachable_rec2([H|T], L, Reachable, R2, Visited) :-
  %writeln(H),
  !,
  /*find_reachable_rec2(T, L, Reachable1, R2, Visited1),
  append([H], Visited1, Visited),
  find_directly_reachable2(H, L, Reachable2),
  append(Reachable2, [], R2).
  */
  append([H], Visited, VisitedNew),
  find_directly_reachable2(H, L, LocalR),
  (
  \+setEqual(LocalR, R2) ->
    union(LocalR, R2, R3),
    %writeln(LocalR),
    %writeln(R2),
    %writeln(R3),
    %writeln(VisitedNew),
    findall(X, (member(X, R3), \+member(X,VisitedNew)),NewT),
    %write('NEW T'),
    %writeln(NewT),
    find_reachable_rec2(NewT, L, Reachable, R3, VisitedNew)
    ;
    find_reachable_rec2(T, L, Reachable, LocalR, VisitedNew)
  ).

find_reachable_from2(X, L, R) :-
  find_reachable_rec2([X], L, R, [], []).

pairAll(X, [], []).
pairAll(X, [H|T], [[X, H]|List]) :-
  pairAll(X, T, List).


% transitiveClosure([[1,2],[3,4],[2,3],[5,6]],L2).
transitiveClosure(L, L2) :-
  collectNodes(L, Nodes),
  getReachables(Nodes, Nodes, L, L2).


%  getReachables([1,2,3,4,5,6], [1,2,3,4,5,6], [[1,2],[3,4],[2,3],[5,6]],L2).
getReachables([], _,_,[]).
getReachables([H|T], Nodes, L, R2) :-
  find_reachable_from2(H, L, R),
  write('reachable from '),
  write(H),
  write(': '),
  writeln(R),
  pairAll(H, Nodes, Pairs),
  writeln(Pairs),
  %R=[[1,2],[3,4],[1,1]],
  %Pairs=[[1,2],[3,4]],
  findall([X,Y],(member(Y,R), member([X,Y], Pairs)), Reachable),
  writeln(Reachable),
  getReachables(T, Nodes, L, R1),
  append(Reachable, R1, R2).
