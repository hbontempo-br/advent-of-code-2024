defmodule Mix.Tasks.D14.P2 do
  use Mix.Task

  import AdventOfCode.Day14

  @shortdoc "Day 14 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(14, 2024)
    grid = {101, 103}

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> part2(input, grid) end}),
      else:
        part2(input, grid)
        |> IO.inspect(label: "Part 1 Results")
  end
end
