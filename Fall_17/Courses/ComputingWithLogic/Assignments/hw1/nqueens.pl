/*
    import append/3, member/2, length/2, ith/3 from basics.
    [bounds].
*/
board(4).
block(1,1).
block(2,2).
block(4,3).

main :-
    board(N),
    length(List,N),
    ins(List,N),
    findall(block(R,C),block(R,C),BlockedCells),
    constraint_blocked(BlockedCells,List),
    gen_lists(List,1,N,List2,List3),
    all_different(List),
    all_different(List2),
    all_different(List3),
    label(List),
    output(List,1).
ins([],_).
ins([H|T],N):-
    H in 1..N,
    ins(T,N).
constraint_blocked([],_List).
constraint_blocked([block(R,C)|BCells],List) :-
    ith(R,List,V),
    V #\= C,
    constraint_blocked(BCells,List).

gen_lists(_List,I,N,List2,List3) :-
    I>N,!,
    List2=[], List3=[].
gen_lists(List,I,N,List2,List3) :-
    ith(I,List,V),
    V1 #= V+I,
    V2 #= V-I,
    List2 = [V1|List2R],
    List3 = [V2|List3R],
    I1 is I+1,
    gen_lists(List,I1,N,List2R,List3R).

output([],_).
output([Q|L],I) :-
    write(queen(I,Q)), writeln('.'),
    I1 is I+1,
    output(L,I1).

