node(5, 3, 6).
node(3, 1, 4).
leaf(1).
leaf(4).
leaf(6).

append([], List, List).
append([H|T], List, [H|List1]) :-
  append(T, List, List1).

preOrder(N, [N]) :-
  leaf(N).

preOrder(N, [N|In]) :-
  node(N, C1, C2),
  preOrder(C1, Out1),
  preOrder(C2, Out2),
  append(Out1, Out2, In).

preOrder1(N, [N|Tail], Tail) :-
  leaf(N).

preOrder1(N, Head, Tail) :-
  node(N, C1, C2),
  Head = [N|List1],
  preOrder1(C1, List1, Tail1),
  preOrder1(C2, Tail1, Tail).

preOrderAcc(N, Head) :-
  preOrder1(N, Head, []).

inOrder(N, [N|Tail], Tail) :-
  leaf(N).

inOrder(N,  Head, Tail) :-
  node(N, C1, C2),
  inOrder(C1, Head, TailLeft),
  TailLeft = [N|Tail1],
  inOrder(C2, Tail1, Tail).

inOrderAcc(N, Head) :-
  inOrder(N, Head, []).

inOrderD(N, [N|Tail]-Tail) :-
  leaf(N).

inOrderD(N, List-Tail) :-
  node(N, C1, C2),
  inOrderD(C1, List-T2),
  T2 = [N|T1],
  inOrderD(C2, T1-Tail).

postOrder(N, [N|Tail], Tail) :-
  leaf(N).
postOrder(N, Head, Tail) :-
  node(N, C1, C2),
  postOrder(C1, Head, List1),
  postOrder(C2, List1, List2),
  List2 = [N|Tail].

postOrderAcc(N, Head) :-
  postOrder(N, Head, []).
