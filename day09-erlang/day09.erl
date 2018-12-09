-module(day09).

read_line(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try io:get_line(Device, "")
    after file:close(Device)
    end.

get_next_marble(_, _, 0, CurrentMarble) ->
    CurrentMarble;
get_next_marble(Next, Prev, Diff, CurrentMarble) ->
    if
        Diff < 0 -> get_next_marble(Next, Prev, Diff + 1, maps:get(CurrentMarble, Prev));
        true -> get_next_marble(Next, Prev, Diff - 1, maps:get(CurrentMarble, Next))
    end.

place_marble(Next, Prev, Diff, CurrentMarble, Marble) ->
    PrevMarble = get_next_marble(Next, Prev, Diff, CurrentMarble),
    NextMarble = maps:get(PrevMarble, Next),
    NextNext = maps:put(PrevMarble, Marble, maps:put(Marble, NextMarble, Next)),
    NextPrev = maps:put(NextMarble, Marble, maps:put(Marble, PrevMarble, Prev)),
    {NextNext, NextPrev}.

remove_marble(Next, Prev, Diff, CurrentMarble) ->
    MarbleToRemove = get_next_marble(Next, Prev, Diff, CurrentMarble),
    PrevMarble = maps:get(MarbleToRemove, Prev),
    NextMarble = maps:get(MarbleToRemove, Next),
    NextNext = maps:put(PrevMarble, maps:get(MarbleToRemove, Next), Next),
    NextPrev = maps:put(NextMarble, maps:get(MarbleToRemove, Prev), Prev),
    {NextNext, NextPrev, MarbleToRemove}.

high_score(_, Marbles, Scores, _, _, _, NextMarble, _) when NextMarble =:= Marbles + 1 ->
    lists:max(maps:values(Scores));
high_score(Players, Marbles, Scores, Next, Prev, CurrentMarble, NextMarble, CurrentPlayer) ->
    if
        NextMarble rem 23 =:= 0 ->
            CurrentPlayerScore = maps:get(CurrentPlayer, Scores, 0),
            {NextNext, NextPrev, RemovedMarble} = remove_marble(Next, Prev, -7, CurrentMarble),
            NextScores = maps:put(CurrentPlayer, CurrentPlayerScore + RemovedMarble + NextMarble, Scores),
            high_score(Players,
                       Marbles,
                       NextScores,
                       NextNext,
                       NextPrev,
                       maps:get(RemovedMarble, Next),
                       NextMarble + 1,
                       (CurrentPlayer + 1) rem Players);
        true ->
            {NextNext, NextPrev} = place_marble(Next, Prev, 1, CurrentMarble, NextMarble),
            high_score(Players,
                       Marbles,
                       Scores,
                       NextNext,
                       NextPrev,
                       NextMarble,
                       NextMarble + 1,
                       (CurrentPlayer + 1) rem Players)
    end.

high_score(Players, Marbles) ->
    Next = #{0 => 0},
    Prev = #{0 => 0},
    Scores = #{},
    high_score(Players, Marbles, Scores, Next, Prev, 0, 1, 0).

main(_) ->
    Splits = string:split(read_line("09.input"), " ", all),
    Players = list_to_integer(lists:nth(1, Splits)),
    Marbles = list_to_integer(lists:nth(7, Splits)),
    io:fwrite("Part 1: ~w~n", [high_score(Players, Marbles)]),
    io:fwrite("Part 2: ~w~n", [high_score(Players, Marbles * 100)]).
