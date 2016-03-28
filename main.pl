?- ['ia', 'iaEstados', 'JogoDaVelha', 'Lista', 'Matriz'].

main :- main(_).

% para debug
main(_) :-
	matriz3x3Vazia(M1),
	printJogo(M1),
	nl,
	jogada(M1, M2),
	printJogo(M2),
	nl,
	jogada(M2, M3),
	printJogo(M3),
	nl,
	jogada(M3, M4),
	printJogo(M4),
	nl,
	jogada(M4, M5),
	printJogo(M5),
	nl,
	jogada(M5, M6),
	printJogo(M6),
	nl,
	jogada(M6, M7),
	printJogo(M7),
	nl,
	jogada(M7, M8),
	printJogo(M8),
	nl,
	jogada(M8, M9),
	printJogo(M9),
	nl,
	jogada(M9, M10),
	printJogo(M10),
	nl.
