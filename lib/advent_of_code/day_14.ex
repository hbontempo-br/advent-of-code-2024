defmodule AdventOfCode.Day14 do
  def part1(input, grid) do
    input
    |> parse_input()
    |> Enum.map(&(compute_position(&1, grid, 100)))
    |> Enum.map(&(quadrant(&1, grid)))
    |> Enum.frequencies()
    |> Map.delete(nil)
    |> Map.values()
    |> Enum.product()

  end

  def part2(input, grid) do
    input
    |> parse_input()
    |> next?(grid)
  end

  #  Now that I know how the tree looks like, we could improove the search method

  # ###############################
  # #.............................#
  # #.............................#
  # #.............................#
  # #.............................#
  # #..............#..............#
  # #.............###.............#
  # #............#####............#
  # #...........#######...........#
  # #..........#########..........#
  # #............#####............#
  # #...........#######...........#
  # #..........#########..........#
  # #.........###########.........#
  # #........#############........#
  # #..........#########..........#
  # #.........###########.........#
  # #........#############........#
  # #.......###############.......#
  # #......#################......#
  # #........#############........#
  # #.......###############.......#
  # #......#################......#
  # #.....###################.....#
  # #....#####################....#
  # #.............###.............#
  # #.............###.............#
  # #.............###.............#
  # #.............................#
  # #.............................#
  # #.............................#
  # #.............................#
  # ###############################

  # The parameter jump is a "hack" to not waist time again looking into ascii
  defp next?(robots, grid, count \\ 0, jump \\ 07900) do
    positions = robots
      |> Enum.map(&(&1[:position]))

    IO.puts("+-------------+")
    IO.puts("| Step: #{String.pad_leading(Integer.to_string(count), 5, "0")} |")
    IO.puts("+-------------+")
    IO.puts("")
    print(positions, grid)
    IO.puts("")
    response = IO.gets("Is this a christmas tree ?\n")
      |> String.trim()
      |> String.upcase()
    case response == "Y" do
      true -> count
      false ->
        new_positions = robots
          |> Enum.map(&(compute_position(&1, grid, jump + 1)))
        new_robots = Enum.zip(robots, new_positions)
          |> Enum.map(
            fn {robot, position} ->
              Map.put(robot, :position, position)
            end
          )
        next?(new_robots, grid, count + jump + 1, 0)
    end
  end

  defp print(positions, grid) do
    {x_grid, y_grid} = grid

    0..(y_grid-1)
    |> Enum.map(
      fn y ->
        0..(x_grid-1)
        |> Enum.map(
          fn x ->
            case Enum.member?(positions, {x, y}) do
              true -> "#"
              false -> "."
            end
          end
        )
        |> Enum.join()
        |> IO.puts()
      end
    )


  end

  defp quadrant(position, grid) do
    { x_grid, y_grid } = grid
    { x_mid, y_mid } = { div(x_grid-1, 2), div(y_grid-1, 2) }

    { x, y } = position
    case { x == x_mid, y == y_mid } do
      {true, _} -> nil
      {_, true} -> nil
      _ ->
        case { x < x_mid, y < y_mid } do
          {true,  true } -> 1
          {false, true } -> 2
          {true,  false} -> 3
          {false,  false} -> 4
        end
    end
  end

  defp compute_position(robot, grid, time) do
    {x_initial, y_initial} = robot[:position]
    {x_shifted, y_shifted} = {x_initial + 1, y_initial + 1}
    {v_x, v_y} = robot[:speed]
    {x_size, y_size} = grid

    x_final_shifted = x_shifted + v_x * time
    y_final_shifted = y_shifted + v_y * time

    x_final = x_final_shifted - 1
    y_final = y_final_shifted - 1

    x_adjusted = case rem(x_final, x_size) do
      x when x >= 0 -> x
      x when x < 0 -> x + x_size
    end

    y_adjusted = case rem(y_final, y_size) do
      y when y >= 0 -> y
      y when y < 0 -> y + y_size
    end

    {x_adjusted, y_adjusted}
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    regex = ~r/p\=(?<x>.+)\,(?<y>.+)\ v\=(?<v_x>.+),(?<v_y>.+)/

    captures = Regex.named_captures(regex, line)
    x = captures |> Map.get("x") |> String.to_integer()
    y = captures |> Map.get("y") |> String.to_integer()
    v_x = captures |> Map.get("v_x") |> String.to_integer()
    v_y = captures |> Map.get("v_y") |> String.to_integer()

    %{
      position: {x, y},
      speed: {v_x, v_y}
    }
  end
end
