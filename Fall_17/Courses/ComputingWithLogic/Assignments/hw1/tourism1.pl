
:- import member/2, length/2, between/3 from basics.
/*
%Sample input 1
  people(2).
  places(3).
  preferences(4).
	
  order(1, 1, 2).
  order(1, 2, 3).
  order(2, 3, 2).
  order(2, 2, 1).
*/

% Following are some helper predicates used in the program
addAtFront(X, [], [X]).
% add at front
addAtFront(X, InList, [X|InList]).

% add element at the end of list
addAtEnd(X, [], [X]).
addAtEnd(X, [InH|InT], [InH|OutList]) :-
	addAtEnd(X, InT, OutList).


delete([], X, _) :-
	fail.

delete([X|T],X,T).

delete([H|T], X, [H|L]) :-
	delete(T,X,L).

permute([], []) :-
	false; true.

permute([H|T], L) :-
	permute(T,S),
	delete(L, H, S).

% End of basic predicates used in the program

% Check if order exists
isInOrder(V, X, Y) :-
  order(V,X, Y).
isInOrder(V,X, Y) :-
  order(V,X, Z),
  isInOrder(V, Z, Y).

% Calculate violations for give two places
getViolations(X, Y, Count) :-
  findall(V, (isInOrder(V, Y, X)), List),
  length(List, Count).

% Calculate violations for give Head and Rest of the list
countViolationLoop(Head, [], 0).
countViolationLoop(Head, [H|T], CountViolations) :-
  getViolations(Head, H, Violations1),
  countViolationLoop(Head, T, Violations2),
  CountViolations is Violations1 + Violations2.

% Calculate Violations for give list.
countViolations([H], 0).
countViolations([H1|T], ViolationCount) :-
    countViolationLoop(H1, T, Violations),
    countViolations(T, Violations1),
    ViolationCount is Violations + Violations1.

% main routine
% Algorithm
% 1. Make a list of N number where N is number of places
% 2. Permute the list and for every permuations
%    a. Calculation violations for every pair of member
% How Violation is calculated?
%    violates(X, Y) if order(Y,X) exists.
main :-
  places(N),
  findall(Num, between(1, N, Num), L),
  findall(Count, (permute(L, PermuteL), countViolations(PermuteL, Count)), ViolationList),
  member(Min, ViolationList),
	forall(member(El, ViolationList), El >= Min),
  write('violations('),
  write(Min),
	writeln(')').
