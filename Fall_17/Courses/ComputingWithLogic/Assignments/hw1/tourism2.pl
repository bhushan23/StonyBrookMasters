
:- import member/2, length/2, between/3 from basics.

/*
%Sample input 1
people(2).
places(3).
preferences(4).
place(1, 1, 9, 11).
place(2, 1, 9, 11).
place(3, 1, 9, 11).
prefer(1, 1).
prefer(2, 1).
prefer(2, 2).
prefer(2, 3).
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

% Generates places to Visit
% Looks for Opening and Closing hours to decide
% If it is possible to visit the place or not
generateVisitList([], _, VisitingList, VisitingList).
generateVisitList([H|T], CurrentTime, VisitingList, VisitingListFinal) :-
  place(H, VisitingTime, OpeningHour, ClosingHour),
  (
    CurrentTime >= OpeningHour ->
      EndOfVisitTime is VisitingTime + CurrentTime,
      (
        EndOfVisitTime =< ClosingHour ->
          generateVisitList(T, EndOfVisitTime, [H|VisitingList], VisitingListFinal)
        ;
        generateVisitList(T, CurrentTime, VisitingList, VisitingListFinal)
      )
    ;
    generateVisitList(T, CurrentTime, VisitingList, VisitingListFinal)
  ).


% Starting point for place to visit
possibleToVisit([], []).
possibleToVisit([H|T], VisitingListFinal) :-
  place(H, VisitingTime, OpeningHour, ClosingHour),
  generateVisitList([H|T], OpeningHour, [],VisitingListFinal).

% Rounds up satisfaction when all desired places are visited.
roundUpSatisfaction(CurrentSat, CountOfPreference, FinalCount) :-
  places(LOC),
  (
    CurrentSat == CountOfPreference ->
      FinalCount is LOC
      ;
      FinalCount is CurrentSat
  ).

% Counts satisfaction of individual person.
countSatisfactionsOfIndividual([], VisitedList, CountList, CountList).
countSatisfactionsOfIndividual([H|T], VisitedList, CountList, CountListFinal) :-
  findall(Num, (prefer(H, Num), member(Num, VisitedList)), SatisfactionList),
  findall(Num1, prefer(H, Num1), PreferredList),
  length(PreferredList, CountOfPreference),
  length(SatisfactionList, CountOfSatisfaction),
  roundUpSatisfaction(CountOfSatisfaction, CountOfPreference, FinalSat),
  countSatisfactionsOfIndividual(T, VisitedList, [FinalSat|CountList], CountListFinal).

% Counts minimum satisfaction for a given list
countSatisfactions(VisitedList, MinSatisfaction) :-
  people(N),
  findall(Num, between(1, N, Num), ListOfPeople),
  countSatisfactionsOfIndividual(ListOfPeople, VisitedList, [], CountList),
  member(Min, CountList),
  forall(member(MinElem, CountList), MinElem >= Min),
  MinSatisfaction is Min.

% main routine
% Algorithm
% 1. Make a list of N number where N is number of places
% 2. Permute the list and for every permuations
%    a. Calculate possible places to Visit
%    b. Calculate Satisfaction for Visited places
% 3. Find visit order which maximizes satisfaction
main :-
  places(N),
  findall(Num, between(1, N, Num), L),
  findall(Count, (permute(L, PermuteL), possibleToVisit(PermuteL, VisitList), countSatisfactions(VisitList, Count)), SatisfactionList),
  writeln(SatisfactionList),
  member(Max, SatisfactionList),
	forall(member(MaxElement, SatisfactionList), MaxElement =< Max),
  write('satisfaction('),
  write(Max),
	writeln(')').
