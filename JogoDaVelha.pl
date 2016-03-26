% Carrega os arquivos que auxiliaram o jogo
?- ['Matriz', 'IA', 'Lista'].


printJogo(_) :-
	matriz3x3PosLinear(ModeloMatriz),
	printMatriz(ModeloMatriz).


% dada uma matriz, XouO pode valor x ou o,
% contando o n?mero de zeros,
% se a matriz tiver numero impar de zeros, retorna x,
% se tiver n?mero par de zeros, retorna o
descobrirXouO(x, o) :- !.
descobrirXouO(o, x) :- !.

descobrirXouO(Matriz, XouO) :-
	numZerosMatriz(Matriz, NumZeros),
	(
		% caso se NumZeros for impar, retorna x
		(NumZeros mod 2) =:= 1,
		XouO = x
		;
		% se for par
		XouO = o
	), !.



% a lista de 3 elementos, quando for do tipo
% [x,x,x], mas n? [0,0,0]
vitoriaLista(Lista) :-
	% convertendo para set para unificar a lista
	list_to_set(Lista, Set),
	% n? pode ser de zeros
	Set \= [0],
	% se houver um elemento soh eh pq houve vitoria
	length(Set, 1).


% Lista com as posi?es lineares de
% linha, coluna e diagonal
% Come?ndo com as diagonais
listaPosLCD([7, 5, 3]).
listaPosLCD([1, 5, 9]).
% agora com as linhas
listaPosLCD(Lista) :-
	between(0, 2, IndLinha),
	findall(
		PosLinear,
		converterPosLinear(PosLinear, IndLinha, _),
		Lista
	).
% agora para coluna
listaPosLCD(Lista) :-
	between(0, 2, IndColuna),
	findall(
		PosLinear,
		converterPosLinear(PosLinear, _, IndColuna),
		Lista
	).



% diz se houve vit?ia na Matriz
vitoria(Matriz) :-
	% obtendo as posi?es lineares para consulta
	listaPosLCD(ListaPosLinear),
	% obtendo os elementos dessas posi?es
	findall(
		Elem,
		(
			% para cada posi?o linear
			member(PosLinear, ListaPosLinear),
			% obtenho um elemento
			getMatriz(PosLinear, Matriz, Elem)
		),
		ListaElem
	),
	vitoriaLista(ListaElem).



fimDeJogo(Matriz) :-
	vitoria(Matriz)
	;
	(
		numZerosMatriz(Matriz, NumZeros),
		NumZeros == 0
	).



% ?aquela jogada que se eu fizer, eu ganho o jogo
jogadaVitoriosa(Matriz, NovaMatriz) :-
	% descobrir oq eu tenho q jogar
	descobrirXouO(Matriz, XouO),
	% deve ser uma posi?o v?ida
	jogadaPossivel(PosLinear, Matriz),
	% vou marcar
	setMatriz(XouO, Matriz, PosLinear, NovaMatriz),
	% deve haver vit?ia na nova matriz
	vitoria(NovaMatriz).


% uma jogada que é compulsoria, eu preciso jogar nela
% se nao eu perco o jogo
jogadaDefensiva(Matriz, NovaMatriz) :-
	descobrirXouO(Matriz, MeuXouO),
	descobrirXouO(MeuXouO, AdvXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(AdvXouO, Matriz, PosLinear, MatrizPerdedora),
	vitoria(MatrizPerdedora),
	% j?sei onde o MeuXouO deve jogar
	setMatriz(MeuXouO, Matriz, PosLinear, NovaMatriz).




% eh aquele tipo de jogada que o oponente precisa obrigatoriamente
% se defender, entao a minha proxima jogada eh uma jogada vitoriosa
% ou outra jogada que faz o oponente se defender
jogadaPreparativa(Matriz, MinhaResposta) :-
	descobrirXouO(Matriz, MeuXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(MeuXouO, Matriz, PosLinear, MinhaResposta),
	not(jogadaVitoriosa(MinhaResposta, _)),
	jogadaDefensiva(MinhaResposta, RespAdv),
	% deve haver uma jogada vitoriosa depois de uma play
	% o adv n? pode ter ganhado
	(
		jogadaVitoriosa(RespAdv, _), !
		;
		jogadaPreparativa(RespAdv, _)
	).



% é uma jogada que permito o adversário fazer uma jogada preparativa
% e consequentemente, eu perco o jogo
jogadaPerdedora(Matriz, MinhaResposta) :-
	descobrirXouO(Matriz, MeuXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(MeuXouO, Matriz, PosLinear, MinhaResposta),
	% se a resposta do advers?io for preparativa
	jogadaPreparativa(MinhaResposta, _).


jogadaQualquer(Matriz, NovaMatriz) :-
	jogadaPossivel(PosLinear, Matriz),
	descobrirXouO(Matriz, XouO),
	setMatriz(XouO, Matriz, PosLinear, NovaMatriz),
	% se a nova matriz n? for perdedora
	not(jogadaPerdedora(Matriz, NovaMatriz)).



jogadaAleatoria(Jogada, Matriz, Resp) :-
	findall(NovaMatriz, call(Jogada, Matriz, NovaMatriz), ListaNovaMatriz),
	random_member(Resp, ListaNovaMatriz).



jogada(Matriz, NovaMatriz) :-
	not(fimDeJogo(Matriz)),
	(
		% DUVIDA
		% gostaria que jogada fosse uma função que me retornasse as jogadas possiveis
		% mas se houver jogadas vitoriiosas, não procuro mais
		% se houver jogada defensiva, nao procuro mais
		% se houver jogada preparativa, nao procuro mais
		% por fim, faço uma jogada qlqr
		% ou seja, gostaria de usar o ; em jogada listando todas as jogadas
		jogadaAleatoria(jogadaVitoriosa, Matriz, NovaMatriz), !
		;
		jogadaAleatoria(jogadaDefensiva, Matriz, NovaMatriz), !
		;
		jogadaAleatoria(jogadaPreparativa, Matriz, NovaMatriz), !
		;
		jogadaAleatoria(jogadaQualquer, Matriz, NovaMatriz), !
	).




% para debug
a :-
	matriz3x3Vazia(M1),
	printMatriz(M1),
	nl,
	jogada(M1, M2),
	printMatriz(M2),
	nl,
	jogada(M2, M3),
	printMatriz(M3),
	nl,
	jogada(M3, M4),
	printMatriz(M4),
	nl,
	jogada(M4, M5),
	printMatriz(M5),
	nl,
	jogada(M5, M6),
	printMatriz(M6),
	nl,
	jogada(M6, M7),
	printMatriz(M7),
	nl,
	jogada(M7, M8),
	printMatriz(M8),
	nl,
	jogada(M8, M9),
	printMatriz(M9),
	nl,
	jogada(M9, M10),
	printMatriz(M10),
	nl.


main(_) :-
	a.

% Para teste, escreva no prolog "a."