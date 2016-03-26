suffix(Sufixo, Lista) :- append(_, Sufixo, Lista).

% a lista vazia tamb? ?sublista
sublist([], [_|_]).
sublist(SubLista, Lista) :- suffix(Sufixo, Lista),  prefix(SubLista, Sufixo), SubLista \= [].


comblist(Comb, Lista) :-
	% tenho que no m?imo informar a lista
	nonvar(Lista),

	sublist(SubList, Lista),
	permutation(SubList, Comb).


comblist(Comb, Lista, N) :-
	% tenho que no m?imo informar a lista
	nonvar(Lista),

	suffix(Sufixo, Lista),
	length(Sufixo, TamSufixo),
	TamSufixo >= N,

	prefix(SubLista, Sufixo),
	length(SubLista, TamSubLista),
	TamSubLista == N,

	permutation(SubLista, Comb).