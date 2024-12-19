defmodule AdventOfCode.Day19 do
  def part1(args) do
    {patterns, designs} =
      args
      |> parse()

    valid_designs(designs, patterns)
    |> Enum.count(&(elem(&1,1)>0))
  end

  def part2(args) do
    {patterns, designs} =
      args
      |> parse()

    valid_designs(designs, patterns)
    |> Enum.map(&(elem(&1,1)))
    |> Enum.sum()
  end

  defp valid_designs(designs, patterns) do
    cache = initial_cache(patterns)
    designs
    |> Enum.map_reduce(
      cache,
      fn design, acc ->
        {count, new_acc} = how_many?(design, patterns, acc)
        {{design, count}, new_acc}
      end
    )
    |> elem(0)
  end

  defp initial_cache(patterns) do
    patterns
    |> Enum.sort(
      fn pattern1, pattern2 ->
        length1 = String.length(pattern1)
        length2 = String.length(pattern2)
        case length1 == length2 do
          false -> length1 <= length2
          true -> pattern1 <= pattern2
        end
      end
    )
    |> Enum.reduce(
      Map.new(),
      fn pattern, acc ->
        { count, _ } = how_many?(pattern, Map.keys(acc), acc)
        Map.put(acc, pattern, count + 1)
      end
    )
  end

  defp how_many?(design, patterns, cache) do
    case cache[design] do
      nil ->
        patterns
        |> Enum.reduce(
          { 0, cache },
          fn pattern, { count, acc } ->
            case String.starts_with?(design, pattern) do
              false ->
                {count, acc}

              true ->
                new_design = String.replace_prefix(design, pattern, "")
                {pattern_count, new_acc} = how_many?(new_design, patterns, acc)
                {count + pattern_count, new_acc}
            end
          end
        )
        |> then(
          fn {count, acc} ->
            new_cache = Map.put(acc, design, count)
            {count, new_cache}
          end
        )

      response ->
        {response, cache}
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
