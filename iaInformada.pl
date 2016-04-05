% ?aquela jogada que se eu fizer, eu ganho o jogo
% Exemplo:
%          [[ , , ],               [[ , ,x],
% Matriz =  [ ,x,o], e NovaMatriz = [ ,x,o],
%           [x, ,o]]                [x, ,o]]
jogadaGanhadora(Matriz, PosLinear, NovaMatriz) :-
	% deve ser uma posi?o v?ida
	jogadaPossivel(PosLinear, Matriz),
	% vou marcar
	setMatriz(Matriz, PosLinear, NovaMatriz),
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
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(Matriz, PosLinear, MinhaResposta),
	% se meu adversario n? consegue ganhar
	not(jogadaGanhadora(MinhaResposta, _, _)),
	% se meu adversario deve fazer uma jogada defensiva
	jogadaDefensiva(MinhaResposta, _, RespAdv),
	% deve haver uma jogada vitoriosa depois de uma play
	% o adv n? pode ter ganhado
	(
		% se houver uma jogada vitoriosa ou eu conseguir emendar uma jogadaPreparativa
		% retorno verdadeiro
		(jogadaGanhadora(RespAdv, _, _) ; jogadaPreparativa(RespAdv, _, _)) -> true
	).



% uma jogada em que abro brecha para que meu adversario
% fa? uma jogada preparativa
% Exemplo:
%          [[ , , ],               [[ , , ],
%  Matriz = [ ,x, ], e NovaMatriz = [ ,x,o],
%           [ , , ]]                [ , , ]]
jogadaPerdedora(Matriz, PosLinear, MinhaResposta) :-
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(Matriz, PosLinear, MinhaResposta),
	% se a resposta do advers?io for preparativa
	% retorno verdadeiro
	jogadaPreparativa(MinhaResposta, _, _) -> true.


% Uma jogada qualquer
% Exemplo:
%          [[ , , ],               [[ , , ],
%  Matriz = [ ,x, ], e NovaMatriz = [ ,x, ],
%           [ , , ]]                [ , ,o]]
jogadaQualquer(Matriz, PosLinear, NovaMatriz) :-
	jogadaPossivel(PosLinear, Matriz),
	setMatriz(Matriz, PosLinear, NovaMatriz),
	% se a nova matriz n? for perdedora
	not(jogadaPerdedora(Matriz, PosLinear, NovaMatriz)).



jogada(Matriz, PosLinear, NovaMatriz) :-
	not(fimDeJogo(Matriz)),
	(
		(
			% se h?uma jogada vitoriosa, a resposta ?a jogada
			jogadaGanhadora(Matriz, _, _) -> jogadaGanhadora(Matriz, PosLinear, NovaMatriz)
			;
			% caso contr?io, testa outra resposta
			jogadaDefensiva(Matriz, _, _) -> jogadaDefensiva(Matriz, PosLinear, NovaMatriz)
			;
			jogadaPreparativa(Matriz, _, _) -> jogadaPreparativa(Matriz, PosLinear, NovaMatriz)
			;
			jogadaQualquer(Matriz, _, _) -> jogadaQualquer(Matriz, PosLinear, NovaMatriz)
		)
	).


jogadaAleatoriaInformada(Matriz, PosLinear, NovaMatriz) :-
	% obtenho todas as jogadas
	findall([PosLinear, NovaMatriz], jogada(Matriz, PosLinear, NovaMatriz), ListaResultados),
	% escolho um aleatoriamente
	random_member([PosLinear, NovaMatriz], ListaResultados).