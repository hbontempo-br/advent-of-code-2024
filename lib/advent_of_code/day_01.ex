defmodule AdventOfCode.Day01 do
  defp parse(args) do
    args
      |> String.trim()
      |> String.split("\n")
      |> Stream.map(
        fn line ->
          line
          |> String.split()
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end
      )
      |> Enum.unzip()
  end

  def part1(args) do
    {list1, list2} = parse(args)

    Stream.zip(Enum.sort(list1), Enum.sort(list2))
    |> Stream.map(
      fn {item1, item2} ->
        Kernel.abs(item1 - item2)
      end
    )
    |> Enum.sum

  end

  def part2(args) do
    {list1, list2} = parse(args)

    frequency_map = Enum.frequencies(list2)

    list1
    |> Stream.map(
      fn item ->
        item * Map.get(frequency_map, item, 0)
      end
    )
    |> Enum.sum
  end
end
