simOuNao(y, true).
simOuNao(yes, true).
simOuNao(s, true).
simOuNao(sim, true).
simOuNao(n, false).
simOuNao(nao, false).
simOuNao(not, false).


perguntarSimOuNao(Resp) :-
	write('Por favor, digite sim ou nao: '),
	repeat,
	read(Str),
	downcase_atom(Str, StrEmMinusculo),
	simOuNao(StrEmMinusculo, Resp), % se nao houver associacao, pergutna de novo
	!.
