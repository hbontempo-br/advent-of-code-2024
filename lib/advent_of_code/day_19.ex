defmodule AdventOfCode.Day19 do
  def part1(args) do
    {patterns, designs} =
      args
      |> parse()

    valid_designs(designs, patterns)
    |> Enum.count(&(elem(&1,1)))
  end

  def part2(_args) do
  end

  defp valid_designs(designs, patterns, cache \\ Map.new()) do
    designs
    |> Enum.map_reduce(
      cache,
      fn design, acc ->
        {status, new_acc} = valid_design?(design, patterns, acc)
        {{design, status}, new_acc}
      end
    )
    |> elem(0)
  end

  defp valid_design?(design, patterns, cache) do
    case Enum.any?(patterns, &(&1 == design)) do
      true ->
        {true, cache}

      false ->
        case cache[design] do
          nil ->
            patterns
            |> Enum.reduce_while(
              {false, cache},
              fn pattern, { _status, acc} ->
                case String.starts_with?(design, pattern) do
                  false ->
                    new_acc = Map.put(acc, pattern, false)
                    {:cont, {false, new_acc}}

                  true ->
                    new_design = String.replace_prefix(design, pattern, "")
                    {status, new_acc} = valid_design?(new_design, patterns, acc)
                    new_new_acc = Map.put(new_acc, pattern, status)

                    case status do
                      false -> {:cont, {false, new_new_acc}}
                      true -> {:halt, {true, new_new_acc}}
                    end
                end
              end
            )

          response ->
            {response, cache}
        end
    end
  end

  defp parse(input) do
    [patterns_str, designs_str] =
      input
      |> String.trim()
      |> String.split("\n\n")

    patterns = parse_patterns(patterns_str)
    designs = parse_designs(designs_str)

    {patterns, designs}
  end

  defp parse_patterns(patterns_str) do
    patterns_str
    |> String.trim()
    |> String.split(", ")
  end

  defp parse_designs(designs_str) do
    designs_str
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end
end
