?- ['IaInformada', 'iaCega', 'JogoDaVelha', 'Lista', 'Matriz'].

main :- main(_).

% para debug
main(_) :-
	test2.

test2 :- testPlayer.

testPlayer :-
	write('Teste testPlayer\n'),
	write('Siga o modelo para jogar:\n\n'),
	matriz3x3ExemploTeclado(M0),
	printJogo(M0),
	nl,
	matriz3x3Vazia(M1),
	printJogo(M1),
	nl,
	player(M1).

player(Mx) :-
	setMatrizPlayer(Mx, Mxmais1),
	printJogo(Mxmais1),
	nl,
	pc(Mxmais1).

pc(Mx) :-
        jogadaAleatoriaInformada(Mx, _, Mxmais1),
	printJogo(Mxmais1),
	nl,
	player(Mxmais1).

test :-
	testInformada,
	testCega.

testInformada :-
	write('testInformada\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	nl,
	jogadaAleatoriaInformada(M1, _, M2),
	printJogo(M2),
	nl,
	jogadaAleatoriaInformada(M2, _, M3),
	printJogo(M3),
	nl,
	jogadaAleatoriaInformada(M3, _, M4),
	printJogo(M4),
	nl,
	jogadaAleatoriaInformada(M4, _, M5),
	printJogo(M5),
	nl,
	jogadaAleatoriaInformada(M5, _, M6),
	printJogo(M6),
	nl,
	jogadaAleatoriaInformada(M6, _, M7),
	printJogo(M7),
	nl,
	jogadaAleatoriaInformada(M7, _, M8),
	printJogo(M8),
	nl,
	jogadaAleatoriaInformada(M8, _, M9),
	printJogo(M9),
	nl,
	jogadaAleatoriaInformada(M9, _, M10),
	printJogo(M10),
	nl.



testCega :-
	carregarBD,
	write('testCega\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	nl,
	jogadaAleatoriaCega(M1, M2),
	printJogo(M2),
	nl,
	jogadaAleatoriaCega(M2, M3),
	printJogo(M3),
	nl,
	jogadaAleatoriaCega(M3, M4),
	printJogo(M4),
	nl,
	jogadaAleatoriaCega(M4, M5),
	printJogo(M5),
	nl,
	jogadaAleatoriaCega(M5, M6),
	printJogo(M6),
	nl,
	jogadaAleatoriaCega(M6, M7),
	printJogo(M7),
	nl,
	jogadaAleatoriaCega(M7, M8),
	printJogo(M8),
	nl,
	jogadaAleatoriaCega(M8, M9),
	printJogo(M9),
	nl,
	jogadaAleatoriaCega(M9, M10),
	printJogo(M10),
	nl.
