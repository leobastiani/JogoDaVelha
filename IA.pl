% estadoResposta possui dois parametros
% Estado que eh uma matriz 3x3 que dado esse determinado estado, vamos considerar a resposta
% Resposta que eh um vetor com os numero de cada casa correspondente

% Exemplo:
% para o estado:
% [
%	[0, 0, X], % posicoes: [0, 1, 2],
%	[0, O, 0], % posicoes: [3, 4, 5],
%	[X, 0, 0]  % posicoes: [6, 7, 8]
% ]
% Resposta eh [1, 3, 5, 7]
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


marcarTendoResposta(Matriz, XouO, Respostas, MatrizResposta) :-
	% posicaoo linear eh algo entre [1, 2, 3, 4, 5, 6, 7, 8, 9]
	random_member(PosLinear, Respostas),
	% converto a posicao para linha e coluna da martiz
	converterPosLinear(PosLinear, IndexLin, IndexCol),
	% substituo o elemento na matriz
	matrizSet(XouO, Matriz, IndexLin, IndexCol, MatrizResposta).


% dada uma matriz, devo encontrar a reposta em estadoResposta
iaMarcar(Matriz, XouO, MatrizResposta, Giradas) :-
	% se ja possuo o estado, sem girar ja retorno ele
	estadoResposta(Matriz, Respostas),
	% encontrei a resposta, vou marcá-la
	marcarTendoResposta(Matriz, XouO, Respostas, MatrizResposta),
	! % se achei, nao procuro mais
	;
	Giradas =< 3,
	NovaGiradas is Giradas + 1,
	matriz3x3GirarH(Matriz, MatrizGirada),
	iaMarcar(MatrizGirada, XouO, MatrizGiradaMarcada, NovaGiradas),
	matriz3x3GirarAH(MatrizGiradaMarcada, MatrizResposta),
	!.


% deixa a IA determinar qual a peca q vai jogar
iaPlay(Matriz, NovaMatriz) :-
	descobrirXouO(Matriz, XouO),
	iaPlay(Matriz, XouO, NovaMatriz),
	!. % nao volta mais aqui


% caso de existir um estadoResposta
iaPlay(Matriz, XouO, NovaMatriz) :-
	iaMarcar(Matriz, XouO, NovaMatriz, 0),
	!.


% caso de nao souber onde jogar
iaPlay(Matriz, XouO, NovaMatriz) :-
	novoEstado(Matriz),
	% agora que eu tenho o novo estado, devo jogar nele
	iaPlay(Matriz, XouO, NovaMatriz),
	!. % ja encontrei a solucao
