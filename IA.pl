% estadoResposta possui dois parametros
% Estado que ?uma matriz 3x3 que dado esse determinado estado, vamos considerar a resposta
% Resposta que ?um vetor com os n?mero de cada casa correspondente

% Exemplo:
% para o estado:
% [
%	[0, 0, X], % posi?es: [0, 1, 2],
%	[0, O, 0], % posi?es: [3, 4, 5],
%	[X, 0, 0]  % posi?es: [6, 7, 8]
% ]
% Resposta ?[1, 3, 5, 7]
:- dynamic estadoResposta/2.


% carrega todos os estados
carregarBD :-
	exists_file('JogoDaVelha.bd'),
	consult('JogoDaVelha.bd')
	;
	true.


% salva todos os estados
salvarBD :-
	tell('JogoDaVelha.bd'),
	listing(estadoResposta),
	told.


% cria um novo estado a partir das regras inseridas pelo teclado
novoEstado(Matriz) :-
	repeat, % existe um false no caso de nao ser uma lista
	writeln('Por favor, digite um vetor de posicoes possiveis para esse estado.'),
	writeln('Devem ser algo como [1, 3, 5, 6, 7],'),
	writeln('seguindo a regra.'),
	printJogo(Matriz),
	read(Str),
	is_list(Str), % garante que Str eh uma lista
	assertz(estadoResposta(Matriz, Str)),
	salvarBD,
	!.


% dada uma matriz, devo encontrar a reposta em estadoResposta
encontrarResposta(Matriz, Respostas) :-
	% se ja possuo o estado, sem girar ja retorno ele
	estadoResposta(Matriz, Respostas),
	! % se achei, n? procuro mais
	;
	% mas se eu n? achei, procuro nas giradas
	encontrarResposta(Matriz, Respostas, 1).

% vou giro e encontro
encontrarResposta(Matriz, Respostas, _) :-
	matriz3x3GirarH(Matriz, MatrizGirada),
	estadoResposta(MatrizGirada, Respostas),
	!. % ja encontrei mesmo

% giro e procuro de novo
encontrarResposta(Matriz, Respostas, NumeroGiradas) :-
	NovoGiradas is NumeroGiradas+1,
	NumeroGiradas =< 3, % vou dar 3 giradas
	matriz3x3GirarH(Matriz, MatrizGirada),
	encontrarResposta(MatrizGirada, Respostas, NovoGiradas).


% deixa a IA determinar qual a peça q vai jogar
iaPlay(Matriz, NovaMatriz) :-
	descobrirXouO(Matriz, XouO),
	iaPlay(Matriz, XouO, NovaMatriz).


% caso de existir um estadoResposta
iaPlay(Matriz, XouO, NovaMatriz) :-
	encontrarResposta(Matriz, Respostas),
	% posicaoo linear eh algo entre [1, 2, 3, 4, 5, 6, 7, 8, 9]
	random_member(PosLinear, Respostas),
	% converto a posicao para linha e coluna da martiz
	converterPosLinear(PosLinear, IndexLin, IndexCol),
	% substituo o elemento na matriz
	matrizSet(XouO, Matriz, IndexLin, IndexCol, NovaMatriz),
	!. % ja encontrei a solucao


% caso de nao souber onde jogar
iaPlay(Matriz, XouO, NovaMatriz) :-
	novoEstado(Matriz),
	% agora que eu tenho o novo estado, devo jogar nele
	iaPlay(Matriz, XouO, NovaMatriz),
	!. % ja encontrei a solucao