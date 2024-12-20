defmodule AdventOfCode.Day20 do
  @all_directions [:up, :down, :left, :right]

  def part1(args, expected_savings \\ 100) do
    args
    |> parse()
    |> then(fn { map, start_position, end_position } -> path_with_steps(map, start_position, end_position) end)
    |> shortcuts()
    |> then(&(count_valid(&1, expected_savings)))
  end

  def part2(_args) do
  end

  defp count_valid(shortcut_list, expected_savings) do
    shortcut_list
    |> Enum.count(&(elem(&1,0) >= expected_savings))
  end

  defp shortcuts(path) do
    path_map = Map.new(path)
    path
    |> Enum.flat_map(
      fn {position1, step1} ->
        @all_directions
        |> Stream.map(&(walk(position1,&1)))
        |> Stream.filter(&(!Map.has_key?(path_map,&1)))
        |> Stream.flat_map(
          fn cheat_position ->
            @all_directions
            |> Stream.map(&(walk(cheat_position,&1)))
            |> Stream.filter(&(Map.has_key?(path_map,&1)))
            |> Stream.filter(&(&1!=position1))
            |> Stream.map(&({Map.get(path_map,&1)-step1-2,position1,&1}))
          end
        )
      end
    )
  end

  defp path_with_steps(map, start_position, end_position)do
    path_with_steps(map, end_position, start_position, nil, 0, [{start_position, 0}])
  end
  defp path_with_steps(_map, end_position, current_position, _previous_position, _steps, path) when current_position == end_position do
    Enum.reverse(path)
  end
  defp path_with_steps(map, end_position, current_position, previous_position, steps, path) do
    next_position = @all_directions
      |> Enum.map(&(walk(current_position, &1)))
      |> Enum.filter(&(&1!=previous_position))
      |> Enum.find(&(map[&1] == :road))
    new_steps = steps+1
    path_with_steps(map, end_position, next_position, current_position, new_steps, [{next_position, new_steps}|path])
  end

  defp walk(position, direction)
  defp walk({ x, y }, :up),    do: { x-1, y   }
  defp walk({ x, y }, :down),  do: { x+1, y   }
  defp walk({ x, y }, :left),  do: { x  , y-1 }
  defp walk({ x, y }, :right), do: { x  , y+1 }

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.with_index()
    |> Enum.reduce(
      { Map.new(), nil, nil },
      fn {line, row}, acc ->
        line
        |> String.trim()
        |> String.codepoints()
        |> Stream.with_index()
        |> Enum.reduce(
          acc,
          fn {val, column}, {map, s, e} ->
            position = {row, column}
            case parse_object(val) do
              :start -> { Map.put(map, position, :road), position, e }
              :end -> { Map.put(map, position, :road), s, position }
              object -> { Map.put(map, position, object), s, e }
            end
          end
        )
      end
    )
  end

  defp parse_object(str )
  defp parse_object("#"), do: :wall
  defp parse_object("."), do: :road
  defp parse_object("S"), do: :start
  defp parse_object("E"), do: :end
end
