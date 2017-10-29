:- import member/2, length/2, between/3 from basics.

vessels(4).
source(1).
people(3).
capacity(1, 12).
capacity(2, 4).
capacity(3, 3).
capacity(4, 1).
horizon(10).

% Following are some helper predicates used in the program
addAtFront(X, [], [X]).
% add at front
addAtFront(X, InList, [X|InList]).
% End of helper predicates

pourIntoOthers(H, [H1|T], Horizon, Ans).

startPouring([H|T], Horizon, Ans) :-
    NextHorizon is Horizon - 1,
    pourIntoOthers(H, T, NextHorizon, Ans).

main :-
  vessels(N),
  source(StartVessel),
  findall((Cap, 0), (between(1, N, Num), capacity(Num, Cap), Num \= StartVessel), VList),
  capacity(StartVessel, StartCap),
  addAtFront((StartCap, StartCap), VList, StartList),
  writeln(VList),
  writeln(StartList),
  horizon(Horizon),
  PourList = [StartList],
  writeln(PourList).

  %startPouring(PourList, Horizon, Ans),
  %writeln(Ans).
