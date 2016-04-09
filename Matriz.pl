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

matriz3x3ExemploTeclado([
	[q, w, e],
	[a, s, d],
	[z, x, c]
]).



% se for digitado '1', o elemento deve ser inserido
% naquela posi?o que est?mostrado
matriz3x3PosLinear([
	[7, 8, 9],
	[4, 5, 6],
	[1, 2, 3]
]).




% Transforma uma matriz em um vetor e conta
% Resp deve ser uma variavel
numZerosMatriz(Matriz, Resposta) :-
	var(Resposta),
	flatten(Matriz, Vetor),
	countElemList(Vetor, 0, Resposta).


/*
 * Converte uma posicao linar para index da linha e da coluna
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

%Seta a matriz quando eh a vez do player
setMatrizPlayer(Matriz, NovaMatriz) :-
    %Le a tecla do usuario
	get_single_char(Tecla),	%'Tecla' eh o codigo do caracter lido
	%Transforma em posicao linear
	tecla2Poslinear(Tecla, Poslinear),
	%Cria NovaMatriz com uma peça inserida na posicao
	setMatriz(Matriz, Poslinear, NovaMatriz).

%Fatos que transformam tecla em posicao linear
tecla2Poslinear(122, 1) :- !.	%122 = 'z'
tecla2Poslinear(120, 2) :- !.	%120 = 'x'
tecla2Poslinear(99, 3) :- !.	%99 = 'c'
tecla2Poslinear(97, 4) :- !.	%97 = 'a'
tecla2Poslinear(115, 5) :- !.	%115 = 's'
tecla2Poslinear(100, 6) :- !.	%100 = 'd'
tecla2Poslinear(113, 7) :- !.	%113 = 'q'
tecla2Poslinear(119, 8) :- !.	%119 = 'w'
tecla2Poslinear(101, 9) :- !.	%101 = 'e'

% obtem um elemento da matriz atrav? da posi?o linear
getMatriz(PosLinear, Matriz, Elem) :-
	converterPosLinear(PosLinear, IndLinha, IndColuna),
	nth0(IndLinha, Matriz, Linha),
	nth0(IndColuna, Linha, Elem).

%Substitui os elementos 0 da matriz pelo caracter '_'
%para melhor visualizacao quano imprimir na tela
tiraZero(Matriz, MatrizSemZero) :-
	tiraZero(0, Matriz, MatrizSemZero). %Começa com a linha 0

%Se o indice da linha eh 3, acabou
tiraZero(3, Matriz, Matriz) :- !.

%Se o indice nao for 3, pega a linha de numero IndexLin,
%substitui seus elementos 0 por '_', insere novamente na matriz
%e faz o mesmo para proxima linha.
tiraZero(IndexLin, Matriz, MatrizSemZero) :- 
	nth0(IndexLin, Matriz, Lin, LinResto),
	substitui(0, '_' , Lin, LinSemZero),
	nth0(IndexLin, MatrizMeioSemZero, LinSemZero, LinResto),
	NextIndexLin is IndexLin + 1,
	tiraZero(NextIndexLin, MatrizMeioSemZero, MatrizSemZero), !.

%Substitui todos os elementos de uma lista que valem X por NX
%substitui(+Elemento, +NovoElemento, +Lista, -NovaLista)
substitui(_, _, [ ], [ ]).
substitui(X, NX, [X|C1], [NX|C2]) :- 
	substitui(X, NX, C1, C2), !.
substitui(X, NX, [A|C1], [A|C2]) :- 
	substitui(X, NX, C1, C2).

%Imprime a matriz no formato de tabuleiro
printMatriz(M) :-
	flatten(M, Vetor),
	writef("|%7c|%7c|%7c|\n|%7c|%7c|%7c|\n|%7c|%7c|%7c|\n\n", Vetor).