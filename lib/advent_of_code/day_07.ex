defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> parse_input
    |> Stream.filter(&is_valid?/1)
    |> Stream.map(fn {val, _} -> val end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input
    |> Stream.filter(&is_valid2?/1)
    |> Stream.map(fn {val, _} -> val end)
    |> Enum.sum()
  end

  defp is_valid?(test_case)
  defp is_valid?({output, [head|tail]}), do: is_valid?(output, head, tail)
  defp is_valid?(expected_output, current_output, other_values)
  defp is_valid?(expected_output, current_output, []), do: expected_output == current_output
  defp is_valid?(expected_output, current_output, [other_head| other_tail]) do
    Kernel.or(
        is_valid?(expected_output, current_output + other_head, other_tail),
        is_valid?(expected_output, current_output * other_head, other_tail)
    )
  end

  defp is_valid2?(test_case)
  defp is_valid2?({output, [head|tail]}), do: is_valid2?(output, head, tail)
  defp is_valid2?(expected_output, current_output, other_values)
  defp is_valid2?(expected_output, current_output, []), do: expected_output == current_output
  defp is_valid2?(expected_output, current_output, [other_head| other_tail]) do
    is_valid2?(expected_output, current_output + other_head, other_tail) ||
    is_valid2?(expected_output, current_output * other_head, other_tail) ||
    is_valid2?(
      expected_output,
      String.to_integer(Integer.to_string(current_output) <> Integer.to_string(other_head)),
      other_tail
    )
  end


  defp parse_input(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(
      fn line ->
        [raw_left, raw_right] = String.split(line, ": ")
        left = raw_left
          |> String.trim()
          |> String.to_integer()
        right = raw_right
          |> String.trim()
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)
        { left, right }
      end
    )
  end
end
