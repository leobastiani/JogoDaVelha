?- ['IaInformada', 'iaCega', 'JogoDaVelha', 'Lista', 'Matriz'].

%Programa inicia altomaticamente na main
:- initialization main.

%Programa fica em loop, ateh usuario querer sair
main :- repeat, main(Sair), (nonvar(Sair), halt).

/*************************
 ### OPCOES INICIAIS ###
*************************/

main(Sair) :-
	write('--------------------------------\n'),
	write('\tJOGO DA VELHA\n'),
	write('--------------------------------\n\n'),
	quemJoga(Quem),
	(
		(Quem == 49, playerXIA), !;
		(Quem == 50, iaXia), !;
		(Quem == 51, Sair is 1, true)
	).

%Recebe a opcao de quem joga
quemJoga(Quem) :-
	write('Escolha um dos modos:\n1 - Jogador X IA\n2 - IA X IA\n3 - Sair '),
	repeat,
	get_single_char(Quem),	%'Quem' eh o codigo do caracter lido
	valida(Quem), !.


valida(49) :- !. %49 = char '1'
valida(50) :- !. %50 = char '2'
valida(51) :- !. %51 = char '3'

/*************************
	### PLAYER X IA ###
*************************/

%Cabeçalho
playerXIA :-
	exemplo,
	quemComeca(Quem, QuemNao),
	writef("\n\n%w inicia com 'x'. %w joga com 'o'!!\n\n", [Quem, QuemNao]),
	sleep(2),
	jogoInformada(Quem), jogoCega(Quem).

%Quem comeca a jogar
quemComeca(Quem, QuemNao) :-
	write('Voce quer jogar primeiro (s/n)? '),
	repeat,
	get_single_char(Tecla),
	tecla2Quems(Tecla, Quem, QuemNao), !.

tecla2Quems(115, 'Voce', 'IA') :- !. %115 = 's'
tecla2Quems(110, 'IA', 'Voce') :- !. %110 = 'n'

%Gera e imprime o Modelo de teclas para jogar
exemplo :-
	write('\n\nSiga o modelo de teclas para jogar:\n\n'),
	matriz3x3ExemploTeclado(M0),
	printJogo(M0),
	nl.

/*--------------
BUSCA INFORMADA
--------------*/

%Inicio do jogo
jogoInformada(Quem) :-
	write('*** Busca Informada ***\n\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	(
		(Quem == 'Voce', playerInformada(M1)), !;
		(Quem == 'IA', iaInformada(M1))
	); true.

%Vez do jogador
playerInformada(Mx) :-
	%Verifica se a IA ganhou
	not(fimDeJogo(Mx, 'IA')),
	write('Sua Jogada: '),
	jogadaPlayer(Mx, Mxmais1),
	%Passa a vez para a IA
	iaInformada(Mxmais1).

%Jogada do Player
jogadaPlayer(Mx, Mxmais1) :-
	%setMatrizPlayer, le a tecla do usuario
	%Caso a tecla digitada esteja correta, continua
	%caso contrario, chama jogadaPlayer para ler outra tecla
	setMatrizPlayer(Mx, Mxmais1),
	nl,
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
jogoCega(Quem) :-
	carregarBD,
	write('*** Busca Cega ***\n\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	(
		(Quem == 'Voce', playerCega(M1)), !;
		(Quem == 'IA', iaCega(M1))
	)
	; true.

%Vez do jogador
playerCega(Mx) :-
	%Verifica de a IA ganhou
	not(fimDeJogo(Mx, 'IA')),
	write('Sua Jogada: '),
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

/*************************
	  ### IA X IA ###
*************************/

iaXia :- jogoInformada, jogoCega.

/*--------------
BUSCA INFORMADA
--------------*/

jogoInformada :-
	write('\n\n*** Busca Informada ***\n\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	iaInformada(M1, 1); true.

%Num_IA = Numero da IA que estah jogando
iaInformada(Mx, Num_IA) :-
	jogadaAleatoriaInformada(Mx, _, Mxmais1),
    sleep(3),
    writef("Jogada da IA %w:\n", [Num_IA]),
	printJogo(Mxmais1),
	proxJogar(Num_IA, Prox_Num_IA),
	iaInformada(Mxmais1, Prox_Num_IA).

%Dado o numero da IA jogando, retorna a proxima IA a jogar
proxJogar(1, 2):- !.
proxJogar(2, 1):- !.

/*--------------
   BUSCA CEGA
--------------*/

jogoCega :-
	carregarBD,
	write('*** Busca Cega ***\n\n'),
	matriz3x3Vazia(M1),
	printJogo(M1),
	iaCega(M1, 1); true.

%Num_IA = Numero da IA que estah jogando
iaCega(Mx, Num_IA) :-
	jogadaAleatoriaCega(Mx, Mxmais1),
    sleep(3),
    writef("Jogada da IA %w:\n", [Num_IA]),
	printJogo(Mxmais1),
	proxJogar(Num_IA, Prox_Num_IA),
	iaCega(Mxmais1, Prox_Num_IA).
