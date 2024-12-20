defmodule AdventOfCode.Day20 do
  @all_directions [:up, :down, :left, :right]

  def part1(args), do: execute(args, 100, 2)

  def part2(args), do: execute(args, 100, 20)

  def execute(args, expected_savings, max_distance) do
    args
    |> parse()
    |> then(fn { map, start_position, end_position } -> path_with_steps(map, start_position, end_position) end)
    |> shortcuts(max_distance)
    |> then(&(count_valid(&1, expected_savings)))
  end

  defp count_valid(shortcut_list, expected_savings) do
    shortcut_list
    |> Enum.count(&(elem(&1,0) >= expected_savings))
  end

  defp shortcuts(path, max_distance) do
    distance_map = compute_distance_map(max_distance)
    path_map = Map.new(path)
    path
    |> Stream.flat_map(
      fn {initial_position, initial_steps} ->
        { initial_row, initial_column } = initial_position
        distance_map
        |> Stream.map(
          fn { delta_position, delta_steps } ->
            { delta_row, delta_column } = delta_position
            final_position = { initial_row+delta_row, initial_column+delta_column }
            { final_position, delta_steps }
          end
        )
        |> Stream.filter(
          fn { final_position, _delta_steps } ->
            Map.has_key?(path_map, final_position)
          end
        )
        |> Stream.map(
          fn { final_position, delta_steps } ->
            final_steps = Map.get(path_map, final_position)
            {final_steps-initial_steps-delta_steps, initial_position, final_position}
          end
        )
      end
    )
  end

  defp compute_distance_map(distance), do: compute_distance_map([{0,0}], 0, distance, Map.new([{{0,0}, 0}]))
  defp compute_distance_map(_positions, current_distance, max_distance, map) when current_distance == max_distance, do: Map.to_list(map)
  defp compute_distance_map(positions, current_distance, max_distance, map) do
    new_distance = current_distance + 1
    { new_positions, new_map } = positions
      |> Enum.flat_map_reduce(
        map,
        fn position, acc ->
          partial_positions = @all_directions
            |> Enum.map(&(walk(position,&1)))
            |> Enum.filter(&(!Map.has_key?(acc,&1)))
            |> Enum.uniq()
          new_acc = partial_positions
            |> Enum.reduce(
              acc,
              fn partial_position, partial_acc ->
                Map.update(partial_acc,partial_position,new_distance,&(min(&1,new_distance)))
              end
            )
          {partial_positions, new_acc}
        end
      )
      compute_distance_map(new_positions, new_distance, max_distance, new_map)
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
