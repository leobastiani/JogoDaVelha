%Imprime o jogo
printJogo(Matriz) :-
	tiraZero(Matriz, MatrizSemZero),
	printMatriz(MatrizSemZero).


% dada uma matriz, XouO pode assumir x ou o,
% contando o n?mero de zeros,
% se a matriz tiver numero impar de zeros, retorna x,
% se tiver n?mero par de zeros, retorna o
descobrirXouO(x, o) :- !.
descobrirXouO(o, x) :- !.

descobrirXouO(Matriz, XouO) :-
	numZerosMatriz(Matriz, NumZeros),
	(
		% caso se NumZeros for impar, retorna x

		% Utilizando a compara?o aritm?ica
		(NumZeros mod 2) =:= 1,
		XouO = x
		;
		% se for par
		XouO = o
	), !.


% retorna uma PosLinear em que eu posso ocupar
jogadaPossivel(PosLinear, Matriz) :-
	between(1, 9, PosLinear),
	getMatriz(PosLinear, Matriz, Elem),
	Elem == 0.


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
% Exemplo:
%          [[x, ,o],
% Matriz =  [o,x,o],
%           [x, ,x]]
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


% Diz se ?o fim do jogo
% exemplo:
%          [[o, ,x],             [[o,x,o],
% Matriz =  [o,x, ], ou Matriz =  [o,x,x],
%           [x, , ]]              [x,o,x]]
fimDeJogo(Matriz) :-
	vitoria(Matriz)
	;
	(
		numZerosMatriz(Matriz, NumZeros),
		NumZeros == 0
	).

%Fim de jogo que imprime o resultado.
fimDeJogo(Matriz, Nome) :-
	(vitoria(Matriz), writef("%w ganhou!!\n\n", [Nome]), sleep(3))
	;
	(
		numZerosMatriz(Matriz, NumZeros),
		NumZeros == 0, write('Deu velha!!\n\n'), sleep(3)
	).