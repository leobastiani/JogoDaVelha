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



% ja sei como calcular o n?mero de zeros num vetor
% soh transformar uma matriz em um vetor e contar
% Resp deve ser uma variavel
numZerosMatriz(Matriz, Resposta) :-
	var(Resposta),
	flatten(Matriz, Vetor),
	countElemList(Vetor, 0, Resposta).


/*
 * como converter uma posicao linar para index da linha e da coluna
 * retorna false se a posicaoo linear for invalida
 */
converterPosLinear(PosLinear, Linha, Coluna) :-
	% PosLinear tem que estar entre 1 e 9
	% caso de PosLinear nao ser variavel
	nonvar(PosLinear),
	between(1, 9, PosLinear),
	Linha is 2-((PosLinear-1) // 3),
	Coluna is (PosLinear-1) mod 3.


converterPosLinear(PosLinear, Linha, Coluna) :-
	% caso de PosLinear ser variavel
	var(PosLinear),
	between(0, 2, Linha),
	between(0, 2, Coluna),
	PosLinear is (2-Linha)*3+Coluna+1.


% set na matriz considerando a ordem de X e O
setMatriz(Matriz, PosLinear, Resposta) :-
	descobrirXouO(Matriz, XouO),
	setMatriz(XouO, Matriz, PosLinear, Resposta).


% seta na matriz passando a posicao linear
setMatriz(XouO, Matriz, PosLinear, Resposta) :-
	% primeiro converte a posicao linear
	converterPosLinear(PosLinear, Linha, Coluna),
	% agora escreve usando a propria funcao
	setMatriz(XouO, Matriz, Linha, Coluna, Resposta),
	!.



% seta na matriz passando a linha e a coluna
setMatriz(XouO, Matriz, IndexLin, IndexCol, Resposta) :-
	% condicao de existencia
	between(0, 2, IndexLin), between(0, 2, IndexCol),
	% obtem a linha
	nth0(IndexLin, Matriz, Lin, LinResto),
	% obtem o elemento
	nth0(IndexCol, Lin, Elem, ColResto),
	% o Elem deve ser 0, se nao eh porque ha outro elemento nessa posicao
	Elem == 0,
	% troca o elemento
	nth0(IndexCol, NovaLin, XouO, ColResto),
	% troca a linha
	nth0(IndexLin, Resposta, NovaLin, LinResto),
	!.


% obtem um elemento da matriz atrav? da posi?o linear
getMatriz(PosLinear, Matriz, Elem) :-
	converterPosLinear(PosLinear, IndLinha, IndColuna),
	nth0(IndLinha, Matriz, Linha),
	nth0(IndColuna, Linha, Elem).


% imprime a matriz
printMatriz(M) :-
	format("[~w,\n ~w,\n ~w]\n", M).