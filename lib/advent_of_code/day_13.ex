defmodule AdventOfCode.Day13 do
  @a_cost 3
  @b_cost 1

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&min_tokens/1)
    |> Enum.sum()
  end

  def part2(_args) do
  end

  defp min_tokens(machine_data) do
    sollutions = machine_data
      |> possible_sollutions()
      |> Enum.map(&compute_sollution_cost/1)

    case Enum.empty?(sollutions) do
      true -> 0
      false -> sollutions |> Enum.min()
    end
  end

  defp compute_sollution_cost(sollution)
  defp compute_sollution_cost({count_a, count_b}), do: (count_a * @a_cost) + (count_b* @b_cost)

  defp possible_sollutions(machine_data) do
    for count_a <- 0..100//1, count_b <- 0..100//1, price(count_a, count_b, machine_data), do: {count_a, count_b}
  end

  defp price(count_a, count_b, machine_data) do
    %{a: {x_a, y_a}, b: {x_b, y_b}} = machine_data
    current_x = (count_a * x_a) + (count_b * x_b)
    current_y = (count_a * y_a) + (count_b * y_b)

    %{prize: {x_target, y_target}} = machine_data

    (current_x == x_target) && (current_y == y_target)
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_machine_data/1)
  end

  defp parse_machine_data(machine_data_str) do
    [
      button_a_str,
      button_b_str,
      prize_str
    ] = machine_data_str
      |> String.trim()
      |> String.split("\n")

    %{
      a: parse_button_str(button_a_str),
      b: parse_button_str(button_b_str),
      prize: parse_prize_str(prize_str)
    }
  end

  defp parse_button_str(button_str) do
    regex = ~r/Button\ .\:\ X\+(?<x>\d+)\,\ Y\+(?<y>\d+)/
    captures = Regex.named_captures(regex, button_str)

    {
      captures |> Map.get("x") |> String.to_integer(),
      captures |> Map.get("y") |> String.to_integer()
    }
  end

  defp parse_prize_str(prize_str) do
    regex = ~r/Prize\:\ X\=(?<x>\d+)\,\ Y\=(?<y>\d+)/
    captures = Regex.named_captures(regex, prize_str)

    {
      captures |> Map.get("x") |> String.to_integer(),
      captures |> Map.get("y") |> String.to_integer()
    }
  end
end
