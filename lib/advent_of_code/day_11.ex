defmodule AdventOfCode.Day11 do
  require Integer
  def part1(args) do
    args
    |> parse()
    |> process(25)
    |> elem(0)
  end

  def part2(args) do
    args
    |> parse()
    |> process(75)
    |> elem(0)
  end

  defp process(stones, times, cache \\ Map.new(), partial_sum \\ 0)
  defp process([], _times, cache, partial_sum), do: { partial_sum, cache }
  defp process([head|tail], times, cache, partial_sum) do
    { n, new_cache } = count(head, times, cache)
    process(tail, times, new_cache, partial_sum + n)
  end

  defp count(_stone, 0, cache), do: { 1 , cache }
  defp count(stone, times, cache) do
    case Map.get(cache, {stone, times}, nil) do
      nil ->
        new_stones = blink(stone)
        { n, new_cache } = process(new_stones, times - 1, cache)
        new_new_cache = Map.put(new_cache, {stone, times}, n)
        { n , new_new_cache}
      cached_count ->
        { cached_count, cache }
    end
  end

  defp blink(stone)
  defp blink("0"), do: ["1"]
  defp blink(x) do
    length = String.length(x)
    case Integer.is_even(length) do
      true ->
        middle = div(length, 2)
        {x1, x2} = String.split_at(x, middle)
        [
          x1,
          case String.trim_leading(x2, "0") do
            "" -> "0"
            n -> n
          end
        ]
      false ->
        x
        |> String.to_integer()
        |> Kernel.*(2024)
        |> Integer.to_string()
        |> then(&([&1]))
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(" ")
  end

  ## ⬇️ Inefficient logic used initially on part1 ⬇️ ##

  # defp process(stones, times)
  # defp process(stones, 0), do: stones
  # defp process(stones, times), do: process(blink(stones), times - 1)

  # defp blink(stones) do
  #   stones
  #   |> Stream.flat_map(
  #     fn
  #       "" -> ["1"]
  #       "0" -> ["1"]
  #       x ->
  #         length = String.length(x)
  #         case Integer.is_even(length) do
  #           true ->
  #             middle = div(length, 2)
  #             {x1, x2} = String.split_at(x, middle)
  #             [x1, String.trim_leading(x2, "0")]
  #           false ->
  #             x
  #             |> String.to_integer()
  #             |> Kernel.*(2024)
  #             |> Integer.to_string()
  #             |> then(&([&1]))
  #         end
  #     end
  #   )
  # end

end
