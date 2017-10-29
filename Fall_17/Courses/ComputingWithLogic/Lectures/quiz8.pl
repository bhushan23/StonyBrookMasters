% 1. Append
make_difference_list([], T-T).

make_difference_list([H|T], [H|T2]-T3) :-
	make_difference_list(T, T2-T3).


get_concrete_list([], T-T) :-
	!.
get_concrete_list([H|T]-T2, [H|T3]) :-
	get_concrete_list(T-T2,T3).

get_concrete_list_short(L-T, L) :-
	T= [].	

append([], List, List).
append([H|Tail], List, [H|List1]) :-
	append(Tail, List, List1).


dappend(X, T, Y, T2, L, T3) :-
	T = Y,
	T2 = T3,
	L = X.

dappend1(X, T, T, T2, X, T2).

%?- dappend([1,2,3|T], T, [4,5,6|T2], T2, L, T3).


dappend1(X-T, T-T2, X-T2).

%?- dappend([1,2,3|T]-T, [4,5,6|T2]-T2, L-T3).


% Unify difference list element with [] (empty list) to make it normal list
% 2. Add element at the end of List

add(L-T, X, L2-T2) :-
	T = [X|T2],
	L = L2.

add1(L-T, X, L-T3) :-
	dappend(L-T,[X|T3]-T3,L-T3).

add2(L-[X|T2], X, L-T2).


% 3. Palindrome
% 

reverse(T-T, T-T) :-
 	!.

reverse([H-T4]-T,[T3]-T2) :-
	reverse(T4-T, T3-T2),
	add(T3-T5, H, T3-T2).

reverse1([H-T4]-T,[T3]-T2) :-
	dappend(T4-T, [H|T5]-T5, T3-T2).


palindrome(L-T) :-
	reverse(L-T, L-T).

palindrome(T-T).

% To Do 
% palindrome([H|T2]-T2) :-
%	L = T2-[H|T],



