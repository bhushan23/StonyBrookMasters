
% 15
createList(H, 0, []).
createList(H, Count, [H|Out]) :-
  Count1 is Count - 1,
  createList(H, Count1, Out).

duplicate([], Count, []).
duplicate([H|T], Count, List) :-
  createList(H, Count, List1),
  duplicate(T, Count, List2),
  append(List1, List2, List).

% 16
everyNth([], _, _, []).
everyNth([_|T], 0, N, List) :-
  everyNth(T, N, N, List).
everyNth([H|T], Count, N, [H|List]) :-
  C is Count - 1,
  everyNth(T, C, N, List).

% 17
%split([], _, L1, L2).
split(T, 0, [], T).
split([H|T], Len, [H|L1], L2) :-
  Len1 is Len - 1,
  split(T, Len1, L1, L2).

% 18
sliceH([], _,_, _, []).

sliceH([H|T], Index, Lo, Up, L) :-
  Index < Lo,
  Index1 is Index+1,
  sliceH(T, Index1, Lo, Up, L).

sliceH(_, Up, Lo, Up, []).

sliceH([H|T], Index, Lo, Up, [H|L]) :-
  Index >= Lo,
  Index < Up,
  Index1 is Index + 1,
  sliceH(T, Index1, Lo, Up, L).

slice(List, Lo, Up, OutList) :-
  sliceH(List, 0, Lo, Up, OutList).

% 19
newIndex(Index, Len, Index1) :-
  (
    Index < 0 ->
      Index1 is Len + Index
    ;
      Index1 is Index
  ).

length([], 0).
length([H|T], Len) :-
  length(T, Len1),
  Len is Len1 + 1.

%
rotate(List, Index, L) :-
  length(List, Len),
  newIndex(Index, Len, Index1),
  split(List, Index1, L1, L2),
  append(L2, L1, L).


% Combo

el(X,[X|L],L).
el(X,[_|L],R) :- el(X,L,R).

combination(0,_,[]).
combination(K,L,[X|Xs]) :- K > 0,
   el(X,L,R), K1 is K-1, combination(K1,R,Xs).

  delete([], X, _) :-
  	fail.

  delete([X|T],X,T).

  delete([H|T], X, [H|L]) :-
  	delete(T,X,L).

  permute([], 0, []) :-
    !.
  permute([], _, []) :-
  	false; true.

  permute([H|T], Count, L) :-
    Count1 is Count - 1,
  	permute(T,Count1, S),
  	delete(L, H, S).

test(List, Count) :-
  findall(L, permute([1,2,3,4,5,6], Count, L), List).

  cbal_tree(0,nil) :- !.
  cbal_tree(N,t(x,L,R)) :- N > 0,
  	N0 is N - 1,
  	N1 is N0//2, N2 is N0 - N1,
  	distrib(N1,N2,NL,NR),
  	cbal_tree(NL,L), cbal_tree(NR,R).

  distrib(N,N,N,N) :- !.
  distrib(N1,N2,N1,N2).
  distrib(N1,N2,N2,N1).


% QuickSort
quickSort([], []).
quickSort([H|T], Sorted) :-
  partition(H, T, P1, P2),
  quickSort(P1, Y1),
  quickSort(P2, Y2),
  append(Y1, [H|Y2], Sorted).

partition(X, [], [], []).
partition(X, [H|T], [H|P1], P2) :-
  H =< X,
  partition(X, T, P1, P2).

partition(X, [H|T], P1, [H|P2]) :-
    H > X,
    partition(X, T, P1, P2).
