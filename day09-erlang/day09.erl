-module(day09).
-export([main/0]).

read_line(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try io:get_line(Device, "")
    after file:close(Device)
    end.

get_prev(Marble) ->
    {_, NextMarble} = lists:nth(1, ets:lookup(prev, Marble)),
    NextMarble.

get_next(Marble) ->
    {_, NextMarble} = lists:nth(1, ets:lookup(next, Marble)),
    NextMarble.

get_next_marble(0, CurrentMarble) ->
    CurrentMarble;
get_next_marble(Diff, CurrentMarble) ->
    if
        Diff < 0 ->
            NextMarble = get_prev(CurrentMarble),
            get_next_marble(Diff + 1, NextMarble);
        true ->
            NextMarble = get_next(CurrentMarble),
            get_next_marble(Diff - 1, NextMarble)
    end.

place_marble(Diff, CurrentMarble, Marble) ->
    PrevMarble = get_next_marble(Diff, CurrentMarble),
    NextMarble = get_next(PrevMarble),
    ets:insert(next, {Marble, NextMarble}),
    ets:insert(next, {PrevMarble, Marble}),
    ets:insert(prev, {Marble, PrevMarble}),
    ets:insert(prev, {NextMarble, Marble}).

remove_marble(Diff, CurrentMarble) ->
    MarbleToRemove = get_next_marble(Diff, CurrentMarble),
    PrevMarble = get_prev(MarbleToRemove),
    NextMarble = get_next(MarbleToRemove),
    ets:insert(next, {PrevMarble, get_next(MarbleToRemove)}),
    ets:insert(prev, {NextMarble, get_prev(MarbleToRemove)}),
    {MarbleToRemove, NextMarble}.

high_score(_, Marbles, Scores, _, NextMarble, _) when NextMarble =:= Marbles + 1 ->
    lists:max(maps:values(Scores));
high_score(Players, Marbles, Scores, CurrentMarble, NextMarble, CurrentPlayer) ->
    {NewNextScores, NewNextMarble} =
        if
            NextMarble rem 23 =:= 0 ->
                CurrentPlayerScore = maps:get(CurrentPlayer, Scores, 0),
                {RemovedMarble, NewNext} = remove_marble(-7, CurrentMarble),
                NextScores = maps:put(CurrentPlayer, CurrentPlayerScore + RemovedMarble + NextMarble, Scores),
                {NextScores, NewNext};
            true ->
                place_marble(1, CurrentMarble, NextMarble),
                {Scores, NextMarble}
        end,
    high_score(Players,
               Marbles,
               NewNextScores,
               NewNextMarble,
               NextMarble + 1,
               (CurrentPlayer + 1) rem Players).

high_score(Players, Marbles) ->
    ets:delete_all_objects(next),
    ets:delete_all_objects(prev),
    ets:insert(next, {0, 0}),
    ets:insert(prev, {0, 0}),
    Scores = #{},
    high_score(Players, Marbles, Scores, 0, 1, 0).

main() ->
    Splits = string:split(read_line("09.input"), " ", all),
    Players = list_to_integer(lists:nth(1, Splits)),
    Marbles = list_to_integer(lists:nth(7, Splits)),
    ets:new(next, [set, named_table]),
    ets:new(prev, [set, named_table]),
    io:fwrite("Part 1: ~w~n", [high_score(Players, Marbles)]),
    io:fwrite("Part 2: ~w~n", [high_score(Players, Marbles * 100)]).
