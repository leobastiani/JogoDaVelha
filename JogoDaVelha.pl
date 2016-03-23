% Carrega os arquivos que auxiliaram o jogo
?- ['Matriz', 'IA'].


printJogo(_) :-
	matriz3x3PosLinear(ModeloMatriz),
	printMatriz(ModeloMatriz).


% dada uma matriz, XouO pode valor x ou o,
% contando o n?mero de zeros,
% se a matriz tiver n?mero ?par de zeros, retorna x,
% se tiver n?mero par de zeros, retorna o
descobrirXouO(Matriz, XouO) :-
	numZerosMatriz(Matriz, NumZeros),
	(
		% caso se NumZeros for ?par, retorna x
		(NumZeros mod 2) =:= 1,
		XouO = x
		;
		% se for par
		XouO = o
	), !.
