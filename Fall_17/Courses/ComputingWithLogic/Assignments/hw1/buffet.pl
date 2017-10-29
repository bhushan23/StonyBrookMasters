
:- import member/2 from basics.

/*
%Sample input 1
dishes(4).
separation(1).
hot(2).
table_width(5).

dish_width(1, 3).
dish_width(2, 3).
dish_width(3, 1).
dish_width(4, 1).

demand(1, 1).
demand(2, 1).
demand(3, 1).
demand(4, 1).
*/
/*
%Sample input 2
dishes(3).
separation(1).
hot(1).
table_width(4).

dish_width(1, 1).
dish_width(2, 1).
dish_width(3, 2).

demand(1, 1).
demand(2, 1).
demand(3, 1).
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

% isHot() - To find out if Dish X is hot or cold.
isHot(X, Y) :-
	hot(HotDishNum),
	(
	HotDishNum >= X ->
		Y is 1;
		Y is 0
	).

% roundedCounts() - Helper for CountTables
roundedCounts(DishWidth, DishCount, TableCount, TableWidth, NewDishCount, NewTableCount) :-
    (
		  DishCount > TableWidth ->
				NewDishCount is DishWidth,
			  NewTableCount is TableCount + 1
		  ;
		    % Separation on same table
			  NewDishCount is DishCount,
			  NewTableCount is TableCount
			).

% isDishCounterGreaterThanOne() - Helper for CountTables
isDishCounterGreaterThanOne(DishCount) :-
		DishCount > 0.

% areBothDishHot - Helper for CountTables
areBothDishHot(Dish1, Dish1).

% countTables() -
% Counts the number of table required for give List
countTables([], C, U, X, Y, X, Y) :- true.

countTables([H|T], IsPreviousHot, AllDish, DishCount, TableCount, FinalDishCount, FinalTableCount) :-
	isHot(H, HotNess),
	separation(SeparationSize),
	table_width(TableWidth),
	dish_width(H,DishWidth),
 	(
		isDishCounterGreaterThanOne(AllDish) ->
	  		% Other than first dish
			 (
			 		 %HotNess \+ IsPreviousHot ->
					 areBothDishHot(HotNess, IsPreviousHot) ->
						  % If both dish are same
						 DishCountFinal is DishWidth + DishCount,
						 roundedCounts(DishWidth, DishCountFinal, TableCount, TableWidth, DishCountFinal1, TableCountFinal1),
						 AllDish1 is AllDish + 1,
						 countTables(T, HotNess, AllDish1, DishCountFinal1, TableCountFinal1, FinalDishCount, FinalTableCount)
					 ;
					 % If dish are different
							 DishCounterTemp is DishCount + SeparationSize,
							 roundedCounts(0, DishCounterTemp, TableCount, TableWidth, DishCountWithSeparation, TableCountWithSeparation),
							 DishCountFinal is DishWidth + DishCountWithSeparation,
							 roundedCounts(DishWidth, DishCountFinal, TableCountWithSeparation, TableWidth, DishCountFinal1, TableCountFinal1),
							 AllDish1 is AllDish + 1,
							 countTables(T, HotNess, AllDish1, DishCountFinal1, TableCountFinal1, FinalDishCount, FinalTableCount)
			 )
   		 ;
	 		 % First Dish
 			 DishCountFinal is DishWidth,
			 roundedCounts(DishWidth, DishCountFinal, TableCount, TableWidth, DishCountFinal1, TableCountFinal1),
			 /*
			 write('Placing First Dish '),
			 write(H),
			 write(' '),
			 write(DishWidth),
			 write(' '),
			 write(DishCountFinal1),
			 writeln(TableCountFinal1),
			 */
			 AllDish1 is AllDish + 1,
			 countTables(T, HotNess, AllDish1, DishCountFinal1, TableCountFinal1, FinalDishCount, FinalTableCount)
	).


% populateDishes() -
% Populates dish into a list.
% Flattens out all the dish.
% e.g. if demand of dish 1 is 2, there will be 2 entries of 1
populateDishes(TotalDishes, DishDemand, TotalDishes, List) :-
	addAtEnd(TotalDishes, [], List).

populateDishes(Starting, DishDemand, TotalDishes, List) :-
	Starting =< TotalDishes,
	%addAtEnd(Starting, List1, List),
	demand(Starting, RealDemand),
	(
		DishDemand < RealDemand ->
			DishDemand1 is DishDemand + 1,
			NextDish is Starting,
		  populateDishes(NextDish, DishDemand1, TotalDishes, List1)
	 ;
		  NextDish is Starting + 1,
			DishDemand1 is 1,
			populateDishes(NextDish, DishDemand1, TotalDishes, List1)
		),
	% populateDishes(NextDish, DishDemand1, TotalDishes, List1),
	addAtFront(Starting, List1, List).


% main routine
% Algorithm
% Add all the dishes in a list (Flatten out demand and make sure each dish have its entry)
% Permute the list and compute number of tables required in all.
% Return the minimum of table count.
main :-
	dishes(TotalDishes),
	hot(HotNum),
	table_width(TableW),
	populateDishes(1, 1, TotalDishes, List),
	% UNCOMMENT FOLLOWING TO SEE WHICH LIST IS BEING PERMUTED FOR FINDING MIN. TABLES
	% FOR LARGE LIST, PROGRAM WILL TAKE A WHILE TO FINISH
	%write(List),
	%permuteAndCount(List, TableW, TableCount, TableList, TableList1),
	findall(TableCount, (permute(List, PermutedList), countTables(PermutedList, 0, 0, 0, 1, DishCount, TableCount)), TableList),
	member(Min, TableList),
	forall(member(N, TableList), N >= Min),
	write('table('),
	write(Min),
	writeln(')').

	%permute(List, PermutedList),
	%countTables(PermutedList, 0, 0, 0, 1, DishCount, TableCount),

	%min(X, TableList),
	%write('\nFinal MIN COUNT: '),
	%writeln(X),
	%permute(List, PermutedList),
	%writeln(TableList).
