?- ['iaInformada', 'iaCega', 'JogoDaVelha', 'Lista', 'Matriz'].

main :- main(_).

% para debug
main(_) :-
	test.


test :-
	testInformada,
	testCega.

testInformada :-
	write('testInformada\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	nl,
	jogadaAleatoria(M1, _, M2),
	printJogo(M2),
	nl,
	jogadaAleatoria(M2, _, M3),
	printJogo(M3),
	nl,
	jogadaAleatoria(M3, _, M4),
	printJogo(M4),
	nl,
	jogadaAleatoria(M4, _, M5),
	printJogo(M5),
	nl,
	jogadaAleatoria(M5, _, M6),
	printJogo(M6),
	nl,
	jogadaAleatoria(M6, _, M7),
	printJogo(M7),
	nl,
	jogadaAleatoria(M7, _, M8),
	printJogo(M8),
	nl,
	jogadaAleatoria(M8, _, M9),
	printJogo(M9),
	nl,
	jogadaAleatoria(M9, _, M10),
	printJogo(M10),
	nl.



testCega :-
	write('testCega\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	nl,
	iaPlay(M1, M2),
	printJogo(M2),
	nl,
	iaPlay(M2, M3),
	printJogo(M3),
	nl,
	iaPlay(M3, M4),
	printJogo(M4),
	nl,
	iaPlay(M4, M5),
	printJogo(M5),
	nl,
	iaPlay(M5, M6),
	printJogo(M6),
	nl,
	iaPlay(M6, M7),
	printJogo(M7),
	nl,
	iaPlay(M7, M8),
	printJogo(M8),
	nl,
	iaPlay(M8, M9),
	printJogo(M9),
	nl,
	iaPlay(M9, M10),
	printJogo(M10),
	nl.