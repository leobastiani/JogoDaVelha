imprimeMatriz(M) :-
	flatten(M, Vetor),
	IndexLin is 0,
	repeat,
	nth0(Index, M, Lin),
	nth0(0, Lin, A),
	(A =\= 0, writef("|%3c|", A); true),
	nth0(1, Lin, B),
	(B =\= 0, writef("|%6c|", B); true),
	nth0(0, Lin, A),
	(C =\= 0, writef("|%9c|", C); true),
	,
	!.