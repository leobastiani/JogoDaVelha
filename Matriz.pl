matriz3x3GirarH([
	[A1, A2, A3],
	[A4, A5, A6],
	[A7, A8, A9]
],
[
	[A7, A4, A1],
	[A8, A5, A2],
	[A9, A6, A3]
]).

matriz3x3GirarAH([
	[A1, A2, A3],
	[A4, A5, A6],
	[A7, A8, A9]
],
[
	[A3, A6, A9],
	[A2, A5, A8],
	[A1, A4, A7]
]).



matriz3x3Vazia([
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0]
]).



matriz3x3Exemplo([
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8]
]).


% se for digitado '1', o elemento deve ser inserido
% naquela posi?o que est?mostrado
matriz3x3PosLinear([
	[7, 8, 9],
	[4, 5, 6],
	[1, 2, 3]
]).


numZerosVetor([], 0) :- !.
numZerosVetor([0], 1) :- !.
numZerosVetor([_], 0) :- !.
numZerosVetor([0|Xs], Resp) :-
	numZerosVetor(Xs, RespXs),
	Resp is 1+RespXs.
numZerosVetor([_|Xs], Resp) :-
	numZerosVetor(Xs, Resp).

% ja sei como calcular o número de zeros num vetor
% soh transformar uma matriz em um vetor e contar
numZerosMatriz(Matriz, Resposta) :-
	flatten(Matriz, Vetor),
	numZerosVetor(Vetor, Resposta).


/*
 * como converter uma posicao linar para index da linha e da coluna
 * retorna false se a posicaoo linear for invalida
 */
converterPosLinear(PosLinear, Linha, Coluna) :-
	PosLinear >= 1,
	PosLinear =< 9,
	Linha is 2-((PosLinear-1) // 3),
	Coluna is (PosLinear-1) mod 3.


matrizSet(XouO, Matriz, IndexLin, IndexCol, Resposta) :-
	% obtem a linha
	nth0(IndexLin, Matriz, Lin, LinResto),
	% obtem o elemento
	nth0(IndexCol, Lin, Elem, ColResto),
	% o Elem deve ser 0, se nao eh porque ha outro elemento nessa posicao
	Elem == 0,
	% troca o elemento
	nth0(IndexCol, NovaLin, XouO, ColResto),
	% troca a linha
	nth0(IndexLin, Resposta, NovaLin, LinResto).



posValida(Pos, Matriz) :-
	converterPosLinear(Pos, IndLin, IndCol),
	nth0(IndLin, Matriz, Lin),
	nth0(IndCol, Lin, Elem),
	Elem == 0.


vetorPosValidas([X], Matriz) :- posValida(X, Matriz), !.
vetorPosValidas([X|Xs], Matriz) :-
	posValida(X, Matriz),
	vetorPosValidas(Xs, Matriz),
	!.




printMatriz(M) :-
	format("~w\n~w\n~w\n", M).

