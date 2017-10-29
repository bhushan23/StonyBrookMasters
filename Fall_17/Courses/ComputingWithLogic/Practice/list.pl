% search for element in the list

member(X, [X|_]).
member(X, [_|Y]) :-
	member(X,Y).

% append one list to other
append([], L, L).
append([InH|InT], L2, [InH|OutList]) :-
	append(InT,L2,OutList).

% add element at the end of list
addAtEnd(X, [], [X]).
addAtEnd(X, [InH|InT], [InH|OutList]) :-
	addAtEnd(X, InT, OutList).

% length of list

length(0, []).
length(X1, [H|T]) :-
	length(X, T),
	X1 is X + 1.


len([],0).
len([_|X], N+1) :-
	len(X, N).

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

addAtEnd(X, [], L) :-
	L = [X].

rev([], []).
rev([H|T], L) :-
	rev(T, L1),
	append(L1, [H], L).

revAcc(L1, L2) :-
	revAcc(L1, [], L2).

revAcc([], List, List).

revAcc([X|T], ListB, ListA) :-
	revAcc(T, [X|ListB], ListA).

addNumberInList(N, [], []).

addNumberInList(N, [H|T], [LH|LT]) :-
	LH is H + 1,
	addNumberInList(N, T, LT).

getNth(1, [X|T], X) :- true.
getNth(N, [H|T], Num) :-
	N > 1,
	N1 is N - 1,
	getNth(N1, T, Num).

swap(List, N1, N2) :-
	getNth(N1, List, Num1),
	getNth(N2, List, Num2),
	Temp is Num1,
	Num1 is Num2,
	Num2 is Temp.


smallestNumber(L, Num) :-
	smallestNumber(L, Num, 99999).

smallestNumber([], N, N).

smallestNumber([H|T], Num, SmallestTill) :-
	(
		H < SmallestTill ->
			SmallestTill1 is H,
			smallestNumber(T, Num, SmallestTill1)
		;
			smallestNumber(T, Num, SmallestTill)
	).

selectionSort(L,OutList) :-
	selectionSort(L, List, []),
	rev(List, OutList).

selectionSort([], L, L).

selectionSort([H|T], SortedList, L1) :-
	smallestNumber([H|T], SmallestNum),
	delete([H|T], SmallestNum, NewList),
	selectionSort(NewList, SortedList, [SmallestNum | L1]).
