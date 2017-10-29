:- import member/2, append/3 from basics.

/*
room(3, 3).
booths(1).
dimension(1, 1, 1).
position(1, 0, 0).
target(1, 2, 2).
*/

check(TarW, TarH) :-
	(
		TarW > 3; TarW < 0; TarH > 3; TarH < 0
	),
	false.

move(BoothNumber, TarW, TarH, 0, Visited) :-
	position(BoothNumber, TarW, TarH), true.

move(BoothNumber, TarW, TarH, Count, Visited) :-
	TarW1 is TarW - 1,
	TarH1 is TarH,
  room(W,H),
	TarW1 =< W,
	TarH1 =< H,
	TarW1 >= 0,
	TarH1 >= 0,
  \+member((W,H), Visited),
  append(Visited, (W,H), Visited1),
	move(BoothNumber, TarW1, TarH1, Count1, Visited1),
	Count is Count1 + 1.

move(BoothNumber, TarW, TarH, Count, Visited) :-
	TarW1 is TarW,
	TarH1 is TarH - 1,
  room(W,H),
	TarW1 =< W,
	TarH1 =< H,
	TarW1 >= 0,
	TarH1 >= 0,
  \+member((W,H), Visited),
  append(Visited, (W,H), Visited1),
	move(BoothNumber, TarW1, TarH1, Count1,Visited1),
	Count is Count1 + 1.

move(BoothNumber, TarW, TarH, Count, Visited) :-
	TarW1 is TarW + 1,
	TarH1 is TarH,
  room(W,H),
	TarW1 =< W,
	TarH1 =< H,
	TarW1 >= 0,
	TarH1 >= 0,
  \+member((W,H), Visited),
  append(Visited, (W,H), Visited1),
	move(BoothNumber, TarW1, TarH1, Count1,Visited1),
	Count is Count1 + 1.

move(BoothNumber, TarW, TarH, Count, Visited) :-
	TarW1 is TarW,
	TarH1 is TarH + 1,
  room(W,H),
	TarW1 =< W,
	TarH1 =< H,
	TarW1 >= 0,
	TarH1 >= 0,
  \+member((W,H), Visited),
  append(Visited, (W,H), Visited1),
	move(BoothNumber, TarW1, TarH1, Count1,Visited1),
	Count is Count1 + 1.


main :-
	target(Num, TW, TH),
  position(Num, TarW, TarH),
  move(Num, TW, TH, Count, []),
  write('moves('),
  write(Count),
  writeln(')').
