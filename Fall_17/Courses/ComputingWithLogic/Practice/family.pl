% give some facts
male(bob).
male(charles).
female(alice).
female(claire).

father(bob, charles).
father(bob, claire).
mother(alice, charles).
mother(alice, claire).
mother(jian, alice).
mother(beta, bob).

% rules
parent(X, Y) :- mother(X, Y).
parent(X, Y) :- father(X, Y).

sibling(X, Y) :- parent(P, X), parent(P, Y), X \= Y.
brother(X, Y) :- sibling(X, Y), male(X).
sister(X, Y) :- sibling(X, Y), female(X).

daughter(X, Y) :- parent(Y, X), female(X).
son(X, Y) :- parent(Y, X), male(X).

grandma(X, Y) :- 
	mother(X, Z),
	parent(Z, Y).

fun(X) :-
	fun(X).