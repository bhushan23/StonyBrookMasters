% selectionSort
findMin([], Min, Min).
findMin([H|T], X, Min) :-
  (
    H < Min,
    findMin(T, X, H)
  )
  ;
  (
    findMin(T, X, Min)
  ).

findMinimum(List, MinNum) :-
  findMin(List, MinNum, 999999).

delete([], X, _) :- fail.
delete([X|T], X, T).
delete([H|T], X, [H|List]) :-
  delete(T, X, List).


selectionSort([],[]).
selectionSort(UnsortedList, SortedList) :-
  findMinimum(UnsortedList, MinNum),
  delete(UnsortedList, MinNum, NewList),
  selectionSort(NewList, SortedList1),
  SortedList = [MinNum|SortedList1].

swapElem([], Head, Min, []).
swapElem([Min|T], Head, Min, [Head|T]).
swapElem([H|T], Head, Min, [H|List]) :-
  swapElem(T, Head, Min, List).

selectionSort2([],[]).
selectionSort2([H|T], SortedList) :-
  findMinimum([H|T], MinNum),
  swapElem(T, H, MinNum, NewList),
  selectionSort2(NewList, SortedList1),
  SortedList = [MinNum|SortedList1].
