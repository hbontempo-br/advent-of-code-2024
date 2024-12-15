defmodule AdventOfCode.Day15 do
  def part1(args) do
    args
    |> parse_input()
    |> then(
      fn {robot, map, commands} ->
        simulate(robot, map, commands)
      end
    )
    |> compute_gcp()
  end

  def part2(_args) do
  end

  defp compute_gcp(map) do
    map
    |> Map.to_list()
    |> Enum.filter(&(elem(&1,1) == :box))
    |> Enum.map(&(elem(&1,0)))
    |> Enum.map(fn {row, column} -> (100 * row) + column end)
    |> Enum.sum()
  end

  defp simulate(robot, map, commands)
  defp simulate(_robot, map, []), do: map
  defp simulate(robot, map, [head|tail]) do
    {new_robot, new_map, _} = walk(robot, map, head)
    simulate(new_robot, new_map, tail)
  end

  defp walk(position, map, direction) do
    next_position = next(position, direction)
    do_not_execute_step = fn (map) -> {position, map, false} end
    execute_step = fn (map) ->
      on_position = Map.get(map, position)
      new_map = map
        |> Map.delete(position)
        |> Map.put(next_position, on_position)
      {next_position, new_map, true}
    end
    case Map.get(map, next_position, nil) do
      :wall -> do_not_execute_step.(map)
      nil -> execute_step.(map)
      :box ->
        case walk(next_position, map, direction) do
          {_, new_map, false} -> do_not_execute_step.(new_map)
          {_, new_map, true } -> execute_step.(new_map)
        end
    end
  end

  defp next(position, direction)
  defp next({ x, y }, :up),         do: { x-1, y   }
  defp next({ x, y }, :down),       do: { x+1, y   }
  defp next({ x, y }, :left),       do: { x  , y-1 }
  defp next({ x, y }, :right),      do: { x  , y+1 }


  defp parse_input(input) do
    [map_str, commands_str] = input
    |> String.trim()
    |> String.split("\n\n")

    map = map_str
      |> parse_map()

    robot = map
      |> Map.to_list()
      |> Enum.find(&(elem(&1,1) == :robot))
      |> elem(0)

    fixed_map = Map.delete(map, robot)

    commands = commands_str
      |> parse_commands()

    {robot, fixed_map, commands}
  end

  defp parse_commands(commands_str) do
    commands_str
    |> String.trim()
    |> String.split("\n")
    |> Enum.join("")
    |> String.codepoints()
    |> Enum.map(&parse_command/1)
  end

  defp parse_command(str)
  defp parse_command("^"), do: :up
  defp parse_command("v"), do: :down
  defp parse_command("<"), do: :left
  defp parse_command(">"), do: :right

  defp parse_map(map_str) do
    map_str
    |> String.trim()
    |> String.split("\n")
    |> Stream.with_index()
    |> Stream.flat_map(
      fn {line, row} ->
        line
        |> String.trim()
        |> String.codepoints()
        |> Stream.with_index()
        |> Enum.map(
          fn {val, column} ->
            {{row, column}, parse_object(val)}
          end
        )
      end
    )
    |> Enum.filter(&(!is_nil(elem(&1, 1))))
    |> Enum.reduce(
      Map.new(),
      fn {position, val}, acc -> Map.put(acc, position, val) end
    )
  end

  defp parse_object(str)
  defp parse_object("#"), do: :wall
  defp parse_object("O"), do: :box
  defp parse_object("@"), do: :robot
  defp parse_object(_), do: nil
end
