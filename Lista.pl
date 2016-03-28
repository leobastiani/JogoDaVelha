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


% conta a qntidade de elementos numa lista, por exemplo:
% n?mero de zeros em [0,9,0] ?2
% Resp deve ser uma variavel
countElemList(Lista, ListaElem, Resp) :-
	var(Resp),
	% caso se eu passar uma lista de elementos
	is_list(ListaElem),
	% DUVIDA
	% Porque ficou muito melhor?
	aggregate_all(count, (member(Elem, Lista), memberchk(Elem, ListaElem)), Resp), !.
countElemList(Lista, Elem, Resp) :-
	var(Resp),
	countElemList(Lista, [Elem], Resp), !.