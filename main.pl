% ?aquela jogada que se eu fizer, eu ganho o jogo
% Exemplo
%          [[ , , ],                [[ , ,x],
% Matriz =  [ ,x,o], e NovaMatriz =  [ ,x,o],
%           [x,o, ]]                 [x,o, ]]
jogadaVitoriosa(Matriz, PosLinear, NovaMatriz) :-
	% descobrir oq eu tenho q jogar
	descobrirXouO(Matriz, XouO),
	% deve ser uma posi?o v?ida
	jogadaPossivel(PosLinear, Matriz),
	% vou marcar
	setMatriz(XouO, Matriz, PosLinear, NovaMatriz),
	% deve haver vit?ia na nova matriz
	vitoria(NovaMatriz).


% uma jogada que ?compulsoria, eu preciso jogar nela
% se nao eu perco o jogo
% Exemplo
%          [[ , , ],                [[ , ,o],
% Matriz =  [ ,x,o], e NovaMatriz =  [ ,x,o],
%           [x, , ]]                 [x, , ]]
jogadaDefensiva(Matriz, PosLinear, NovaMatriz) :-
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
% Exemplo
%          [[ , ,o],                [[ , ,o],
% Matriz =  [ ,x,o], e NovaMatriz =  [ ,x,o],
%           [x, , ]]                 [x, ,x]]
jogadaPreparativa(Matriz, PosLinear, MinhaResposta) :-
	descobrirXouO(Matriz, MeuXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(MeuXouO, Matriz, PosLinear, MinhaResposta),
	not(jogadaVitoriosa(MinhaResposta, PosLinear, _)),
	jogadaDefensiva(MinhaResposta, PosLinear, RespAdv),
	% deve haver uma jogada vitoriosa depois de uma play
	% o adv n? pode ter ganhado
	(
		jogadaVitoriosa(RespAdv, _, _), !
		;
		jogadaPreparativa(RespAdv, _, _)
	).



% ?uma jogada que permito o advers?io fazer uma jogada preparativa
% e consequentemente, eu perco o jogo
% Exemplo
%          [[ , ,o],                [[ , ,o],
% Matriz =  [ ,x, ], e NovaMatriz =  [ ,x,o],
%           [x, , ]]                 [x, , ]]
jogadaPerdedora(Matriz, PosLinear, MinhaResposta) :-
	descobrirXouO(Matriz, MeuXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(MeuXouO, Matriz, PosLinear, MinhaResposta),
	% se a resposta do advers?io for preparativa
	jogadaPreparativa(MinhaResposta, _, _).


% Exemplo
%          [[ , , ],                [[ , ,o],
% Matriz =  [ ,x, ], e NovaMatriz =  [ ,x, ],
%           [ , , ]]                 [ , , ]]
jogadaQualquer(Matriz, PosLinear, NovaMatriz) :-
	jogadaPossivel(PosLinear, Matriz),
	descobrirXouO(Matriz, XouO),
	setMatriz(XouO, Matriz, PosLinear, NovaMatriz),
	% se a nova matriz n? for perdedora
	not(jogadaPerdedora(Matriz, PosLinear, NovaMatriz)).


% dado um sistema de jogadas, fa? uma jogada aleatoria de todas
% as solu?es dele
jogadaAleatoria(Jogada, Matriz, Resp) :-
	findall(NovaMatriz, call(Jogada, Matriz, _, NovaMatriz), ListaNovaMatriz),
	random_member(Resp, ListaNovaMatriz).


% realiza uma jogada dentre as op?es poss?eis
jogada(Matriz, NovaMatriz) :-
	not(fimDeJogo(Matriz)),
	(
		% DUVIDA
		% gostaria que jogada fosse uma fun?o que me retornasse as jogadas possiveis
		% mas se houver jogadas vitoriiosas, n? procuro mais
		% se houver jogada defensiva, nao procuro mais
		% se houver jogada preparativa, nao procuro mais
		% por fim, fa? uma jogada qlqr
		% ou seja, gostaria de usar o ; em jogada listando todas as jogadas
		jogadaAleatoria(jogadaVitoriosa, Matriz, NovaMatriz), !
		;
		jogadaAleatoria(jogadaDefensiva, Matriz, NovaMatriz), !
		;
		jogadaAleatoria(jogadaPreparativa, Matriz, NovaMatriz), !
		;
		jogadaAleatoria(jogadaQualquer, Matriz, NovaMatriz), !
	).