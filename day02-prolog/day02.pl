has_count([[_, C]|_], C).
has_count([[_, _]|T], C) :-
    has_count(T, C).

add_char_to_map(C, [], [[C, 1]]).
add_char_to_map(C, [[C, CC]|T], [[C, X]|T]) :-
    X is CC + 1.
add_char_to_map(C, [[O, CC]|T], [[O,CC]|M]) :-
    C \= O,
    add_char_to_map(C, T, M).

char_map([], []).
char_map([H|T], M) :-
    char_map(T, MM),
    add_char_to_map(H, MM, M).

count_exact([], _, 0).
count_exact([H|T], N, M) :-
    string_codes(H, L),
    char_map(L, CM),
    has_count(CM, N),
    count_exact(T, N, MM),
    M is MM + 1.
count_exact([H|T], N, M) :-
    string_codes(H, L),
    char_map(L, CM),
    not(has_count(CM, N)),
    count_exact(T, N, M).

repeated([], [], []).
repeated([H|T1], [H|T2], [H|T]) :-
    repeated(T1, T2, T).
repeated([H1|T1], [H2|T2], T) :-
    H1 \= H2,
    repeated(T1, T2, T).

words_as_char_lists([], []).
words_as_char_lists([H|T], [CL|CLT]) :-
    string_codes(H, CL),
    words_as_char_lists(T, CLT).

has_repeated_size(H, [H1|_], L, C) :-
    repeated(H, H1, C),
    length(C, L).
has_repeated_size(H, [_|T], L, C) :-
    has_repeated_size(H, T, L, C).

get_common_letters([H|T], C) :-
    length(H, L),
    LL is L - 1,
    has_repeated_size(H, T, LL, C).
get_common_letters([_|T], C) :-
    get_common_letters(T, C).

check_char_and_read_rest(10, [], _) :- !.
check_char_and_read_rest(32, [], _) :- !.
check_char_and_read_rest(-1, [], _) :- !.
check_char_and_read_rest(end_of_file, [] , _) :- !.
check_char_and_read_rest(Char, [Char|Chars], Stream) :-
    get_code(Stream, NextChar),
    check_char_and_read_rest(NextChar, Chars, Stream).

read_word(Stream, W) :-
    get_code(Stream, Char),
    check_char_and_read_rest(Char, Chars, Stream),
    atom_codes(W, Chars).

read_lines(Stream, []) :-
    at_end_of_stream(Stream).
read_lines(Stream, [H|T]) :-
    not(at_end_of_stream(Stream)),
    read_word(Stream, H),
    read_lines(Stream, T).

main :-
    open('02.input', read, Str),
    read_lines(Str, Lines),
    count_exact(Lines, 2, E2),
    count_exact(Lines, 3, E3),
    RES1 is E2 * E3,
    write("Part 1: "),
    writeln(RES1),
    words_as_char_lists(Lines, CLines),
    get_common_letters(CLines, Common),
    string_codes(Word, Common),
    write("Part 2: "),
    writeln(Word),
    close(Str).
