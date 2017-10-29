ins([H|T],N) :-
    H in 1..N,
    ins(T,N).