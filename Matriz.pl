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

%Seta a matriz quando eh a vez do player
setMatrizPlayer(Matriz, NovaMatriz) :-
    %Le a tecla do usuario
	read(Tecla),
	%format("~w\n", Tecla),
	%Transforma em posicao linear
	tecla2Poslinear(Tecla, Poslinear),
	%Cria NovaMatriz com uma peça inserida na posicao
	setMatriz(Matriz, Poslinear, NovaMatriz).

%Fatos que transformam tecla em posicao linear
tecla2Poslinear(z, 1) :- !.
tecla2Poslinear(x, 2) :- !.
tecla2Poslinear(c, 3) :- !.
tecla2Poslinear(a, 4) :- !.
tecla2Poslinear(s, 5) :- !.
tecla2Poslinear(d, 6) :- !.
tecla2Poslinear(q, 7) :- !.
tecla2Poslinear(w, 8) :- !.
tecla2Poslinear(e, 9) :- !.

% obtem um elemento da matriz atrav? da posi?o linear
getMatriz(PosLinear, Matriz, Elem) :-
	converterPosLinear(PosLinear, IndLinha, IndColuna),
	nth0(IndLinha, Matriz, Linha),
	nth0(IndColuna, Linha, Elem).

tiraZero(Matriz, MatrizSemZero) :-
	tiraZero(0, Matriz, MatrizSemZero).

tiraZero(3, Matriz, Matriz) :- !.

tiraZero(IndexLin, Matriz, MatrizSemZero) :- 
	nth0(IndexLin, Matriz, Lin, LinResto),
	substitui(0, '_' , Lin, LinSemZero),
	nth0(IndexLin, MatrizMeioSemZero, LinSemZero, LinResto),
	NextIndexLin is IndexLin + 1,
	tiraZero(NextIndexLin, MatrizMeioSemZero, MatrizSemZero), !.


substitui(X, NX, [ ], [ ]).
substitui(X, NX, [X|C1], [NX|C2]) :- 
	substitui(X, NX, C1, C2), !.
substitui(X, NX, [A|C1], [A|C2]) :- 
	substitui(X, NX, C1, C2).

printMatriz(M) :-
	flatten(M, Vetor),
	writef("|%7c|%7c|%7c|\n|%7c|%7c|%7c|\n|%7c|%7c|%7c|\n\n", Vetor).

/*% imprime a matriz
printMatriz(M) :-
	flatten(M, Vetor),
	%format(" ~w ~w ~w\n ~w ~w ~w\n ~w ~w ~w\n", Vetor).
	write("|---|---|---|\n"),
	writef("| %n | %n | %n |\n|---|---|---|\n| %n | %n | %n |\n|---|---|---|\n| %n | %n | %n |\n", Vetor),
	write("|---|---|---|\n\n").*/
