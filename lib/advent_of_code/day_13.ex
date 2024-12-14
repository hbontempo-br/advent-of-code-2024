defmodule AdventOfCode.Day13 do
  # Problem:
  # x_a * a + x_b * b = x_prize
  # y_a * a + y_b * b = y_prize
  #
  # a = (x_prize - x_b * b)/x_a
  # a = (y_prize - y_b * b)/y_a
  #
  # (x_prize - x_b * b)/x_a =  (y_prize - y_b * b)/y_a
  # (x_prize * y_a) - (y_a * x_b) * b = (y_prize * x_a) - (x_a * y_b) * b
  # b * [(x_a * y_b) - (y_a * x_b)] = [(y_prize * x_a) - (x_prize * y_a)]
  #
  # b = [(y_prize * x_a) - (x_prize * y_a)] / [(x_a * y_b) - (y_a * x_b)]
  # b1 = (y_prize * x_a) - (x_prize * y_a)
  # b2 = (x_a * y_b) - (y_a * x_b)
  # b = b1 / b2
  #
  # a = (x_prize - x_b * b)/x_a
  # a1 = (x_prize - x_b * b)
  # a2 = x_a
  # a = a1 / a2

  @a_cost 3
  @b_cost 1

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&clicks/1)
    |> Enum.map(&filter_results/1)
    |> Enum.map(&tokens/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.map(&adjust_data/1)
    |> Enum.map(&clicks/1)
    |> Enum.map(&tokens/1)
    |> Enum.sum()
  end

  defp adjust_data(machine_data) do
    {x, y} = machine_data[:prize]
    new_prize = {x+10000000000000, y+10000000000000}
    Map.put(machine_data, :prize, new_prize)
  end

  defp tokens({ a, b } = _result) do
    (a * @a_cost) + (b * @b_cost)
  end

  defp filter_results({a, _b}) when a > 100, do: {0, 0}
  defp filter_results({_a, b}) when b > 100, do: {0, 0}
  defp filter_results(result), do: result

  defp clicks(machine_data) do
    { x_a,     y_a     } = machine_data[:a]
    { x_b,     y_b     } = machine_data[:b]
    { x_prize, y_prize } = machine_data[:prize]

    b2 = (x_a * y_b) - (y_a * x_b)

    case b2 do
      0 -> {0, 0}
      _ ->
        b1 = (y_prize * x_a) - (x_prize * y_a)
        case rem(b1, b2) == 0 do
          false -> {0, 0}
          true ->
            b = div(b1, b2)

            a1 = (x_prize - x_b * b)
            a2 = x_a

            case rem(a1, a2) == 0 do
              false -> {0, 0}
              true ->
                a = div(a1, a2)

                {a, b}
            end

        end
    end

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
