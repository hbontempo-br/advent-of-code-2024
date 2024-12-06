defmodule AdventOfCode.Day06 do
  def part1(args) do
    {
      map,
      { initial_position, initial_direction }
    } = parse_input(args)
    path = walk(initial_position, initial_direction, map)
    unique_positions = MapSet.new(path)

    MapSet.size(unique_positions)
  end

  def part2(args) do
    {
      map,
      { initial_position, initial_direction }
    } = parse_input(args)

    map
    |> map_permutations
    |> Enum.count(&(loop?(initial_position, initial_direction, &1)))
  end

  defp map_permutations(map) do
    map
    |> Map.keys()
    |> Enum.flat_map(
      fn position ->
        case Map.get(map, position) do
          "." -> [Map.put(map, position, "#")]
          _ -> []
        end
      end
    )
  end

  defp loop?(initial_position, initial_direction, map) do
    loop?(
      initial_position,
      initial_direction,
      map,
      MapSet.new([{initial_position, initial_direction}])
    )
  end

  defp loop?(current_position, current_direction, map, walked_path) do
    next_position = next(current_position, current_direction)
    case Map.get(map, next_position) do
      nil -> false
      "#" -> loop?(current_position, rotate(current_direction), map, walked_path)
      "." ->
        new_step = {next_position, current_direction}
        case MapSet.member?(walked_path, new_step) do
          true -> true
          false -> loop?(next_position, current_direction, map, MapSet.put(walked_path, new_step))
        end
    end
  end

  defp walk(initial_position, initial_direction, map), do: walk(initial_position, initial_direction, map, [initial_position])
  defp walk(current_position, current_direction, map, walked_path) do
    next_position = next(current_position, current_direction)
    case Map.get(map, next_position) do
      "#" -> walk(current_position, rotate(current_direction), map, walked_path)
      "." -> walk(next_position, current_direction, map, [next_position | walked_path])
      nil -> Enum.reverse(walked_path)
    end
  end

  defp next(position, direction)
  defp next({ x, y }, :up),    do: { x-1, y   }
  defp next({ x, y }, :down),  do: { x+1, y   }
  defp next({ x, y }, :left),  do: { x  , y-1 }
  defp next({ x, y }, :right), do: { x  , y+1 }

  defp rotate(direction)
  defp rotate(:up),    do: :right
  defp rotate(:right), do: :down
  defp rotate(:down),  do: :left
  defp rotate(:left),  do: :up

  defp parse_input(text) do
    text
      |> String.trim()
      |> String.split("\n")
      |> Stream.with_index(
        fn line, row ->
          line
          |> String.trim()
          |> String.codepoints()
          |> Enum.with_index(
            fn val, column ->
              { {row, column}, val }
            end
          )
        end
      )
      |> Stream.flat_map(&(&1))
      |> Enum.reduce(
        { Map.new(), nil },
        fn { pos, val }, { current_map, initial_state } ->
          { new_initial_state, new_val } = case val do
            "^" -> { { pos, :up }   , "." }
            "v" -> { { pos, :down } , "." }
            ">" -> { { pos, :right }, "." }
            "<" -> { { pos, :left } , "." }
            _ ->   { initial_state  , val }
          end
          new_map = Map.put(current_map, pos, new_val)
          { new_map, new_initial_state}
        end
      )


  end
end
