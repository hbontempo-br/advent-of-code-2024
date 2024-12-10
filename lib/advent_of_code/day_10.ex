defmodule AdventOfCode.Day10 do
  def part1(args) do
    map = parse(args)

    map
    |> initial_positions()
    |> Enum.map(fn pos -> elem(possible_destinations(pos, map), 0) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def part2(args) do
    map = parse(args)

    map
    |> initial_positions()
    |> Enum.map(fn pos -> elem(possible_paths(pos, map), 0) end)
    |> Enum.sum()
  end

  defp possible_paths(position, map, { count, cache } = meta \\ { 0, Map.new() }) do
    case Map.get(cache, position, nil) do
      nil ->
        value = Map.get(map, position)
        case value == 9 do
          true ->
            new_cache = Map.put(cache, position, 1)
            { count + 1, new_cache }
          false ->
            [:up, :down, :left, :right]
            |> Enum.reduce(
              meta,
              fn dir, acc ->
                next_position = next(position, dir)
                next_value = Map.get(map, next_position)
                case next_value == value + 1 do
                  true -> possible_paths(next_position, map, acc)
                  false -> acc
                end
              end
            )
        end
      val -> { count + val, cache}
    end
  end

  defp possible_destinations(position, map, { responses, visited_nodes } \\ { MapSet.new(), MapSet.new() }) do
    case MapSet.member?(visited_nodes, position) do
      true -> {responses, visited_nodes}
      false ->
        new_visited_nodes = MapSet.put(visited_nodes, position)
        value = Map.get(map, position)
        case value == 9 do
          true -> { MapSet.put(responses, position), new_visited_nodes }
          false ->
            [:up, :down, :left, :right]
            |> Enum.reduce(
              {responses, new_visited_nodes},
              fn dir, acc ->
                next_position = next(position, dir)
                next_value = Map.get(map, next_position)
                case next_value == value + 1 do
                  true -> possible_destinations(next_position, map, acc)
                  false -> acc
                end
              end
            )
        end
    end
  end


  defp initial_positions(map) do
    map
    |> Map.keys()
    |> Enum.filter(
      fn pos -> Map.get(map, pos, nil) == 0 end
    )
  end

  defp next(position, direction)
  defp next({ x, y }, :up),    do: { x-1, y   }
  defp next({ x, y }, :down),  do: { x+1, y   }
  defp next({ x, y }, :left),  do: { x  , y-1 }
  defp next({ x, y }, :right), do: { x  , y+1 }

  defp parse(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Stream.with_index(
      fn line, row ->
        line
        |> parse_line
        |> Enum.map(
          fn {val, col} ->
            {{row, col}, String.to_integer(val)}
          end
        )
      end
    )
    |> Stream.flat_map(&(&1))
    |> Enum.reduce(
      %{},
      fn {position, val}, acc -> Map.put(acc, position, val) end
    )
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.codepoints()
    |> Enum.with_index()
  end
end
