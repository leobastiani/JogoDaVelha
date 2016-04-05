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
	consult('JogoDaVelha.bd'),
	!
	;
	% mesmo se o arquivo nao existe
	% e mesmo se a consulta falhar, devo retornar verdadeiro
	true.


% salva todos os estados
salvarBD :-
	tell('JogoDaVelha.bd'),
	listing(estadoResposta),
	told.



estadosIaInformada(Matriz, ListaPos) :-
	findall(PosLinear, jogada(Matriz, PosLinear, _), ListaPos).


% cria um novo estado a partir das regras inseridas pelo teclado
novoEstado(Matriz) :-
	estadosIaInformada(Matriz, ListaPos),
	assertz(estadoResposta(Matriz, ListaPos)),
	!.


construirBD :-
	% remove todas as respostas carregadas
	retractall(estadoResposta(_, _)),
	% come? a recurs? com uma matriz vazia
	matriz3x3Vazia(Matriz),
	construirBD(Matriz)
	;
	salvarBD.


construirBD(Matriz) :-
	not(fimDeJogo(Matriz)),
	% n? posso ter uma resposta
	not(jogadaCega(Matriz, _)),
	novoEstado(Matriz),
	% para todas as jogadas possiveis
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(Matriz, PosLinear, NovaMatriz),
	% chamo para esse novo estado
	construirBD(NovaMatriz).


marcarTendoResposta(Matriz, XouO, Respostas, MatrizResposta) :-
	% posicaoo linear eh algo entre [1, 2, 3, 4, 5, 6, 7, 8, 9]
	member(PosLinear, Respostas),
	% substituo o elemento na matriz
	setMatriz(XouO, Matriz, PosLinear, MatrizResposta).


% dada uma matriz, devo encontrar a reposta em estadoResposta
marcarCega(Matriz, XouO, MatrizResposta) :-
	% come? sem girar
	marcarCega(Matriz, XouO, MatrizResposta, 0).


marcarCega(Matriz, XouO, MatrizResposta, NumGiradas) :-
	% se ja possuo o estado, sem girar ja retorno ele
	estadoResposta(Matriz, Respostas),
	% encontrei a resposta, vou marca-la
	marcarTendoResposta(Matriz, XouO, Respostas, _) -> marcarTendoResposta(Matriz, XouO, Respostas, MatrizResposta)
	; % se n? achei a resposta, continuo procurando nas giradas
	NumGiradas =< 3,
	NumGiradasMasiUm is NumGiradas + 1,
	matriz3x3GirarH(Matriz, MatrizGirada),
	marcarCega(MatrizGirada, XouO, MatrizGiradaMarcada, NumGiradasMasiUm),
	matriz3x3GirarAH(MatrizGiradaMarcada, MatrizResposta).



% deixa a IA determinar qual a peca q vai jogar
jogadaCega(Matriz, NovaMatriz) :-
	descobrirXouO(Matriz, XouO),
	jogadaCega(Matriz, XouO, NovaMatriz).


% caso de existir um estadoResposta
jogadaCega(Matriz, XouO, NovaMatriz) :-
	% tento marcar, se eu conseguir
	% n? preciso tentar mais
	marcarCega(Matriz, XouO, _) -> marcarCega(Matriz, XouO, NovaMatriz).


jogadaAleatoriaCega(Matriz, NovaMatriz) :-
	findall(NovaMatriz, jogadaCega(Matriz, NovaMatriz), ListaResp),
	random_member(NovaMatriz, ListaResp).