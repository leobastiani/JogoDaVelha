% ?aquela jogada que se eu fizer, eu ganho o jogo
% Exemplo:
%          [[ , , ],               [[ , ,x],
% Matriz =  [ ,x,o], e NovaMatriz = [ ,x,o],
%           [x, ,o]]                [x, ,o]]
jogadaVitoriosa(Matriz, PosLinear, NovaMatriz) :-
	% descobrir oq eu tenho q jogar 
	descobrirXouO(Matriz, XouO),
	% deve ser uma posi?o v?ida
	jogadaPossivel(PosLinear, Matriz),
	% vou marcar
	setMatriz(XouO, Matriz, PosLinear, NovaMatriz),
	% deve haver vit?ia na nova matriz
	vitoria(NovaMatriz).


% ?aquela que ?preciso jogar, se n? eu perco o jogo
% Exemplo:
%          [[ , , ],               [[ , , ],
% Matriz =  [ ,x,o], e NovaMatriz = [ ,x,o],
%           [ ,x,o]]                [ ,x,o]]
jogadaDefensiva(Matriz, PosLinear, NovaMatriz) :-
	descobrirXouO(Matriz, MeuXouO),
	descobrirXouO(MeuXouO, AdvXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(AdvXouO, Matriz, PosLinear, MatrizPerdedora),
	vitoria(MatrizPerdedora),
	% j?sei onde o MeuXouO deve jogar
	setMatriz(MeuXouO, Matriz, PosLinear, NovaMatriz).




% ?aquele tipo de jogada que o oponente precisa obrigatoriamente
% se defender, ent? a minha pr?ima jogada ?uma jogada vitoriosa
% ou outra jogada que faz o oponente se defender
% Exemplo:
%          [[ , ,o],               [[ , ,o],
% Matriz =  [ ,x,o], e NovaMatriz = [ ,x,o],
%           [x, , ]]                [x, ,x]]
jogadaPreparativa(Matriz, PosLinear, MinhaResposta) :-
	descobrirXouO(Matriz, MeuXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(MeuXouO, Matriz, PosLinear, MinhaResposta),
	% se meu adversario n? consegue ganhar
	not(jogadaVitoriosa(MinhaResposta, _, _)),
	% se meu adversario deve fazer uma jogada defensiva
	jogadaDefensiva(MinhaResposta, _, RespAdv),
	% deve haver uma jogada vitoriosa depois de uma play
	% o adv n? pode ter ganhado
	(
		% DUVIDA
		% porque tem exclama?o?
		jogadaVitoriosa(RespAdv, _, _), !
		;
		jogadaPreparativa(RespAdv, _, _)
	).



% uma jogada em que abro brecha para que meu adversario
% fa? uma jogada preparativa
% Exemplo:
%          [[ , , ],               [[ , , ],
%  Matriz = [ ,x, ], e NovaMatriz = [ ,x,o],
%           [ , , ]]                [ , , ]]
jogadaPerdedora(Matriz, PosLinear, MinhaResposta) :-
	descobrirXouO(Matriz, MeuXouO),
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(MeuXouO, Matriz, PosLinear, MinhaResposta),
	% se a resposta do advers?io for preparativa
	jogadaPreparativa(MinhaResposta, _, _).


% Uma jogada qualquer
% Exemplo:
%          [[ , , ],               [[ , , ],
%  Matriz = [ ,x, ], e NovaMatriz = [ ,x, ],
%           [ , , ]]                [ , ,o]]
jogadaQualquer(Matriz, PosLinear, NovaMatriz) :-
	jogadaPossivel(PosLinear, Matriz),
	descobrirXouO(Matriz, XouO),
	setMatriz(XouO, Matriz, PosLinear, NovaMatriz),
	% se a nova matriz n? for perdedora
	not(jogadaPerdedora(Matriz, PosLinear, NovaMatriz)).



jogadaAleatoria(Jogada, Matriz, Resp) :-
	findall(NovaMatriz, call(Jogada, Matriz, _, NovaMatriz), ListaNovaMatriz),
	random_member(Resp, ListaNovaMatriz).


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
