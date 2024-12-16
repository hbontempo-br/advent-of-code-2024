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

  def part2(args) do
    args
    |> parse_input()
    |> then(
      fn {robot, map, commands} ->
        {new_robot, new_map} = enlarge(robot, map)
        simulate(new_robot, new_map, commands)
      end
    )
    |> compute_gcp()
  end

  defp enlarge({r, c} = _robot, map) do
    new_robot = {r, c * 2}

    new_map = map
      |> Map.to_list()
      |> Enum.flat_map(
        fn {{row, column}, object} ->
          case object do
            :wall ->
              [
                {{row, 2 * column}, :wall},
                {{row, (2 * column) + 1}, :wall}
              ]
            {:box, _} ->
              blocks = [{row, 2 * column}, {row, (2 * column) + 1}]
              [
                {{row, 2 * column}, {:box, blocks}},
                {{row, (2 * column) + 1}, {:box, blocks}}
              ]

          end
        end
      )
      |> Map.new()

    {new_robot, new_map}
  end

  defp print(robot, direction, map) do
    IO.puts("---------------------")

    {max_row, max_column} = map
    |> Map.keys()
    |> Enum.max()

    0..max_row
    |> Enum.map(
      fn row ->
        0..max_column
        |> Enum.map(
          fn column ->
            position = {row, column}
            case position == robot do
              true ->
                case direction do
                  :up -> "^"
                  :down -> "v"
                  :right -> ">"
                  :left -> "<"
                  :end -> "X"
                end
              false ->
                case Map.get(map, position, nil) do
                  nil -> "."
                  :wall -> "#"
                  {:box, _} -> "0"
                end

            end
          end
        )
        |> Enum.join()
      end
    )
    |> Enum.join("\n")
    |> IO.puts()

    IO.gets("")

    IO.puts("---------------------")


  end

  defp compute_gcp(map) do
    map
    |> Map.values()
    |> Enum.filter(
      fn
        {:box,_} -> true
        _ -> false
      end
    )
    |> Enum.map(&(List.first(elem(&1,1))))
    |> Enum.uniq()
    |> Enum.map(fn {row, column} -> (100 * row) + column end)
    |> Enum.sum()
  end

  defp simulate(robot, map, commands, print_steps \\ false)
  defp simulate(robot, map, [], print_steps) do
    if print_steps, do: print(robot, :end, map)
    map
  end
  defp simulate(robot, map, [head|tail], print_steps) do
    if print_steps, do: print(robot, head, map)

    {new_robot, new_map} = walk(robot, map, head)
    simulate(new_robot, new_map, tail, print_steps)
  end

  defp move?(position, map, direction) do
    case Map.get(map, position, nil) do
      nil -> true
      :wall -> false
      {:box, blocks} ->
        blocks
        |> Enum.map(&(next(&1,direction)))
        |> Enum.filter(&(!Enum.member?(blocks,&1)))
        |> Enum.all?(&(move?(&1, map, direction)))
    end
  end

  def move(position, map, direction) do
    case Map.get(map, position, nil) do
      nil -> map
      :wall -> map
      {:box, blocks} ->
        new_blocks = Enum.map(blocks, &(next(&1,direction)))

        map1 = new_blocks
          |> Enum.filter(&(!Enum.member?(blocks,&1)))
          |> Enum.reduce(
            map,
            &(move(&1,&2,direction))
          )

        map2 = blocks
          |> Enum.reduce(
            map1,
            &(Map.delete(&2,&1))
          )

        new_map = new_blocks
          |> Enum.reduce(
            map2,
            &(Map.put(&2,&1,{:box, new_blocks}))
          )

        new_map
    end
  end

  defp walk(position, map, direction) do
    next_position = next(position, direction)
    case move?(next_position, map, direction) do
      false -> { position, map }
      true ->
        {next_position, move(next_position, map, direction)}
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
            {{row, column}, parse_object(val, {row, column})}
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

  defp parse_object(str, position )
  defp parse_object("#", _position), do: :wall
  defp parse_object("O", position ), do: {:box, [position]}
  defp parse_object("@", _position), do: :robot
  defp parse_object(_, _), do: nil
end
