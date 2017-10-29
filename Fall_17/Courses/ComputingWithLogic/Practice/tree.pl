node(5, 4, 3).
node(4, 1, 2).
node(3, 7, 9).
leaf(1).
lead(2).
leaf(7).
leaf(9).

/*preorder(Root, [Root]) :-
	leaf(Root).

preorder(Root, [Root|List]) :-
	node(Root, Child1, Child2),
	preorder(Child1, List1),
	preorder(Child2, List2),
	append(List1, List2, List).
*/

preorder1(Root, List) :-
	preorder2(Root, List, []).

preorder2(Root, [Root|T], T) :-
	leaf(Root).

preorder2(Root, List, Tail) :-
	node(Root, Child1, Child2),
	List = [Root | List1],
	preorder2(Child1, List1, Tail1),
	preorder2(Child2, Tail1, Tail).

