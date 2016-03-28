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
	% mesmo se o arquivo nao existe
	% e mesmo se a consulta falhar, devo retornar verdadeiro
	true.


% salva todos os estados
salvarBD :-
	tell('JogoDaVelha.bd'),
	listing(estadoResposta),
	told.



estadoFromTeclado(Matriz, ListaPos) :-
	writeln('Por favor, digite um vetor de posicoes possiveis para esse estado.'),
	writeln('Devem ser algo como [1, 3, 5, 6, 7],'),
	writeln('seguindo a regra.'),
	printJogo(Matriz),
	read(ListaPos),
	is_list(ListaPos), % garante que ListaPos eh uma lista
	% garante que as posicoes desse vetor fazem parte da solucao
	% de posicoes validas
	findall(PosLinear, jogadaPossivel(PosLinear, Matriz), ListaPos).

% cria um novo estado a partir das regras inseridas pelo teclado
novoEstado(Matriz) :-
	repeat, % existe um false no caso de nao ser uma lista
	estadoFromTeclado(Matriz, ListaPos),
	assertz(estadoResposta(Matriz, ListaPos)),
	salvarBD,
	!.


marcarTendoResposta(Matriz, XouO, Respostas, MatrizResposta) :-
	% posicaoo linear eh algo entre [1, 2, 3, 4, 5, 6, 7, 8, 9]
	random_member(PosLinear, Respostas),
	% substituo o elemento na matriz
	setMatriz(XouO, Matriz, PosLinear, MatrizResposta).


% dada uma matriz, devo encontrar a reposta em estadoResposta
iaMarcar(Matriz, XouO, MatrizResposta) :-
	% come? sem girar
	iaMarcar(Matriz, XouO, MatrizResposta, 0).


iaMarcar(Matriz, XouO, MatrizResposta, NumGiradas) :-
	% se ja possuo o estado, sem girar ja retorno ele
	estadoResposta(Matriz, Respostas),
	% encontrei a resposta, vou marc?la
	marcarTendoResposta(Matriz, XouO, Respostas, MatrizResposta)
	; % se n? achei a resposta, continuo procurando nas giradas
	NumGiradas =< 3,
	NumGiradasMasiUm = NumGiradas + 1,
	matriz3x3GirarH(Matriz, MatrizGirada),
	iaMarcar(MatrizGirada, XouO, MatrizGiradaMarcada, NumGiradasMasiUm),
	matriz3x3GirarAH(MatrizGiradaMarcada, MatrizResposta).



% deixa a IA determinar qual a peca q vai jogar
iaPlay(Matriz, NovaMatriz) :-
	descobrirXouO(Matriz, XouO),
	iaPlay(Matriz, XouO, NovaMatriz).


% caso de existir um estadoResposta
iaPlay(Matriz, XouO, NovaMatriz) :-
	% tento marcar, se eu conseguir
	% n? preciso tentar mais
	iaMarcar(Matriz, XouO, NovaMatriz),
	!.


% caso de nao souber onde jogar
iaPlay(Matriz, XouO, NovaMatriz) :-
	novoEstado(Matriz),
	% agora que eu tenho o novo estado, devo jogar nele
	iaPlay(Matriz, XouO, NovaMatriz),
	!. % ja encontrei a solucao
