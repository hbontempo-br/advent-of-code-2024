defmodule AdventOfCode.Day03 do
  def clear_args(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.join()
  end

  def extract_multiplications(args) do
    ~r/mul\(\d{1,3},\d{1,3}\)/
    |> Regex.scan(args)
    |> Stream.flat_map(&(&1))
    |> Enum.map(
      fn text ->
        text
        |> String.slice(4..-2//1)
        |> String.split(",")
        |> Stream.map(&String.to_integer/1)
        |> Enum.reduce(1, fn elem, acc -> acc * elem end)
      end
    )
  end

  def extract_disabled_multiplications(args) do
    ~r/don't\(\).+?do\(\)/
    |> Regex.scan(args)
    |> Stream.flat_map(&(&1))
    |> Stream.map(&extract_multiplications/1)
    |> Stream.flat_map(&(&1))
  end

  def part1(args) do
    args
    |> clear_args
    |> extract_multiplications()
    |> Enum.sum()
  end

  def part2(args) do
    all_multiplication = args
    |> clear_args
    |> extract_multiplications()
    |> Enum.frequencies()
    # |> IO.inspect()

    disabled_multiplications = args
    |> clear_args
    |> extract_disabled_multiplications()
    |> Enum.frequencies()
    # |> IO.inspect()

    active_multiplications = disabled_multiplications
    |> Map.keys()
    |> Enum.reduce(
      all_multiplication,
      fn key, acc ->
        Map.update!(
          acc,
          key,
          fn val -> val - Map.get(disabled_multiplications, key) end
        )
      end
    )

    active_multiplications
    |> Map.to_list()
    # |> IO.inspect()
    |> Stream.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end
end
