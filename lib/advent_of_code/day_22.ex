defmodule AdventOfCode.Day22 do

  def part1(args, times \\ 2000) do
    args
    |> parse()
    |> Enum.map(&(secret_number(&1, times)))
    |> Enum.sum()
  end


  def part2(_args) do
  end

  defp secret_number(current, times)
  defp secret_number(current, 0), do: current
  defp secret_number(current, times) do
    next = next_secret_number(current)
    secret_number(next, times-1)
  end

  defp next_secret_number(current) do
    current
    |> process1()
    |> process2()
    |> process3()
  end

  defp process1(secret_number) do
    secret_number * 64
    |> mix(secret_number)
    |> prune()
  end

  defp process2(secret_number) do
    secret_number / 32
    |> Kernel.trunc()
    |> mix(secret_number)
    |> prune()
  end

  defp process3(secret_number) do
    secret_number * 2048
    |> mix(secret_number)
    |> prune()
  end

  defp mix(val, secret_number), do: Bitwise.bxor(val, secret_number)

  defp prune(val), do: rem(val, 16777216)

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
