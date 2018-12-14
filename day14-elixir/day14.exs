defmodule Day14 do
  def integer_to_list(i) do
    if i == 0 do []
    else integer_to_list(div(i, 10)) ++ [rem(i, 10)]
    end
  end

  def list_to_integer(l) do
    List.foldl(l, 0, fn x, acc -> acc * 10 + x end)
  end

  def step(state) do
    {recipes, positions} = state
    next_sum = List.foldl(positions, 0, fn x, acc -> recipes[x] + acc end)
    next_recipes_list = if next_sum == 0 do [0] else integer_to_list next_sum end
    next_recipes = List.foldl(
      next_recipes_list,
      recipes,
      fn x, acc -> Map.put(acc, map_size(acc), x) end)
    next_positions = positions |>
      Enum.map(fn pos -> rem(pos + recipes[pos] + 1, map_size next_recipes) end)
    {next_recipes, next_positions}
  end

  def score_after(n, r, state) do
    recipes = elem(state, 0)
    if map_size(recipes) >= (n + r) do
      list_to_integer(Enum.map(r..(r + n - 1), fn x -> recipes[x] end))
    else
      score_after(n, r, step state)
    end
  end
end

{:ok, contents} = File.read("14.input")
{n_recipes, _} = Integer.parse Enum.at(String.split(contents, "\n"), 0)
start_state = {%{0 => 3, 1 => 7}, [0, 1]}
IO.puts "Part 1: " <> String.pad_leading(
  Integer.to_string(Day14.score_after(10, n_recipes, start_state)), 10, "0")
