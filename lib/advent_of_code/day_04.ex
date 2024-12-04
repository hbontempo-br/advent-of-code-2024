defmodule AdventOfCode.Day04 do
  def part1(args) do
    map = parse_input(args)
    count_word("XMAS", map)
  end

  def part2(args) do
    map = parse_input(args)
    count_x_mas(map)
  end

  defp count_x_mas(map) do
    map
    |> all_positions()
    |> Stream.map(
      fn {x, y} ->
        leg1 = Enum.join(
          [
            Map.get(map, {x  , y  }, ""),
            Map.get(map, {x+1, y+1}, ""),
            Map.get(map, {x+2, y+2}, "")
          ]
        )
        leg2 = Enum.join(
          [
            Map.get(map, {x+2, y  }, ""),
            Map.get(map, {x+1, y+1}, ""),
            Map.get(map, {x  , y+2}, "")
          ]
        )
        (leg1 == "MAS" || leg1 == "SAM") && (leg2 == "MAS" || leg2 == "SAM")
      end
    )
    |> Stream.filter(&(&1))
    |> Enum.count()
  end

  defp count_word(word, map) do
    codepoints = String.codepoints(word)
    map
    |> all_positions()
    |> Stream.map(fn pos -> valid_words(pos, map, codepoints) end)
    |> Enum.sum()
  end

  defp valid_words(pos, map, [first_letter | other_letters]) do
    case Map.get(map, pos, nil) == first_letter do
      true ->
        all_directions()
        |> Stream.map(fn dir -> check_direction(map, pos, dir, other_letters) end)
        |> Stream.filter(&(&1))
        |> Enum.count()
      false -> 0
    end
  end

  defp check_direction(map, current_position, direction, letters)
  defp check_direction(_map, _current_position, _direction, []), do: true
  defp check_direction(map, current_position, direction, [head|tail]) do
    next = next_position(current_position, direction)
    case Map.get(map, next, nil) == head do
      true -> check_direction(map, next, direction, tail)
      false -> false
    end

  end

  defp all_directions() do
    [:r, :l, :u, :d, :ru, :rd, :lu, :ld]
  end

  defp next_position(pos, direction)
  defp next_position({x, y}, :r ), do: {x  , y+1}
  defp next_position({x, y}, :l ), do: {x  , y-1}
  defp next_position({x, y}, :u ), do: {x-1, y  }
  defp next_position({x, y}, :d ), do: {x+1, y  }
  defp next_position({x, y}, :ru), do: {x-1, y+1}
  defp next_position({x, y}, :rd), do: {x+1, y+1}
  defp next_position({x, y}, :lu), do: {x-1, y-1}
  defp next_position({x, y}, :ld), do: {x+1, y-1}

  defp all_positions(map), do: Map.keys(map)


  defp parse_input(text) do
    text
      |> String.trim()
      |> String.split("\n")
      |> Stream.with_index(
        fn line, row ->
          line
          |> parse_line
          |> Enum.map(
            fn {val, col} ->
              {{row, col}, val}
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
