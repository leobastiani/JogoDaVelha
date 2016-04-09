?- ['IaInformada', 'iaCega', 'JogoDaVelha', 'Lista', 'Matriz'].

main :- main(_).

% para debug
main(_) :-
	playerXIA.

%Cabeçalho
playerXIA :- 
	write('--------------------------------\n'),
	write('\tJOGO DA VELHA\n'),
	write('--------------------------------\n\n'),
	exemplo,
	jogoInformada, jogoCega.

%Gera e imprime o Modelo de teclas para jogar
exemplo :- 
	write('Siga o modelo de teclas para jogar:\n\n'),
	matriz3x3ExemploTeclado(M0),
	printJogo(M0),
	nl.

/*--------------
BUSCA INFORMADA
--------------*/

%Inicio do jogo
jogoInformada :-
	write('***Busca Informada***\n\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	playerInformada(M1); true.

%Vez do jogador
playerInformada(Mx) :-
	%Verifica se a IA ganhou
	not(fimDeJogo(Mx, 'IA')),
	write('Sua Jogada:\n'),
	jogadaPlayer(Mx, Mxmais1),
	%Passa a vez para a IA
	iaInformada(Mxmais1).

%Jogada do Player
jogadaPlayer(Mx, Mxmais1) :-
	%setMatrizPlayer, le a tecla do usuario
	%Caso a tecla digitada esteja correta, continua
	%caso contrario, chama jogadaPlayer para ler outra tecla
	setMatrizPlayer(Mx, Mxmais1),
	printJogo(Mxmais1), !;
	jogadaPlayer(Mx, Mxmais1).

%Jogada da IA
iaInformada(Mx) :-
    jogadaAleatoriaInformada(Mx, _, Mxmais1),
    sleep(3),
    write('Jogada da IA:\n'),
	printJogo(Mxmais1),
	playerInformada(Mxmais1).

/*--------------
   BUSCA CEGA
--------------*/
%Inicio do jogo
jogoCega :- 
	carregarBD,
	write('***Busca Cega***\n\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	playerCega(M1); true.

%Vez do jogador
playerCega(Mx) :-
	%Verifica de a IA ganhou
	not(fimDeJogo(Mx, 'IA')),
	write('Sua Jogada:\n'),
	jogadaPlayer(Mx, Mxmais1),
	%Passa a vez para a IA
	iaCega(Mxmais1).

%Vez da IA
iaCega(Mx) :-
	jogadaAleatoriaCega(Mx, Mxmais1),
	sleep(3),
	write('Jogada da IA:\n'),
	printJogo(Mxmais1),
	playerCega(Mxmais1).

/*test :-
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
*/