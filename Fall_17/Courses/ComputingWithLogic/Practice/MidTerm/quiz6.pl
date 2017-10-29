% 1. Last element in the list
lastElem([], 0).
lastElem([H], H).
lastElem([_|T], Last) :-
  lastElem(T, Last).

% 2. Kth element in the list
kthElem([H|_], 0, H).
kthElem([], _, 0).
kthElem([_|T], K, L) :-
  K1 is K - 1,
  kthElem(T, K1, L).

% 3. Reverse a List
reverseAcc([], L, L).
reverseAcc([H|T], L1, LRev) :-
  reverseAcc(T, [H|L1], LRev).

reverse(List, ListReversed) :-
  reverseAcc(List, [], ListReversed).

% 4. Palindrome
isPalindrome(List) :-
  reverse(List, List).

% 5. Flatten
append([], X, X).
append([H|T], L, [H|L1]) :-
  append(T, L, L1).

flatten([], L, L).
flatten([H|T], InList, [OutList1|OutList]) :-
  append(OutList, H, OutList1),
  flatten(T, OutList1, OutList).

flatten2(X, [X]) :- \+ is_list(X).
flatten2([], []).
flatten2([X|T], Z) :-
  flatten2(X, XFl),
  flatten2(T, TFl),
  append(XFl, TFl, Z).


% 6. duplicate
duplicate([], []).
duplicate([H,H|T], L) :-
  !,
  duplicate([H|T], L).

duplicate([H|T], [H|L]) :-
  duplicate(T, L).

% 7. Pack

/*
packthis(List, OutList) :-
  pack(List, [], OutList).

pack([], [], []).
pack([H,H|T], Temp, OutList) :-
  pack([H|T], [H|Temp], OutList).

pack([H|T], Temp, OutList) :-
  append([H], Temp, OutList),
  pack(T, Temp, OutList).
*/

pack([],[]).
pack([H], [[H]]).
pack([H,H|T], [[H|T0]|L]) :-
  pack([H|T], [T0|L]).
pack([H1,H2|T], [[H1]|L]) :-
  pack([H2|T], L).

% 8. Run-length encoding
runLen([], 1, []).
%runLen([H1], _, [H|L]).
runLen([H,H|T], Count, L) :-
  Count1 is Count + 1,
  !,
  runLen([H|T], Count1, L).


runLen([H|T], Count, [(Count, H)|L]) :-
  runLen(T, 1, L).

% 9. Decode length
decodeSingle(0, Element, []).
decodeSingle(Len, Element, [Element|Out]) :-
  Len1 is Len - 1,
  decodeSingle(Len1, Element, Out).

decodeLen([] , []).
decodeLen([(Len,Element)|T], List) :-
  decodeSingle(Len, Element, OutList),
  decodeLen(T, List1),
  append(OutList, List1, List).


% 10
createRange(U, U, [U]).
createRange(L, U, [L|List]) :-
  L1 is L + 1,
  createRange(L1, U, List).
