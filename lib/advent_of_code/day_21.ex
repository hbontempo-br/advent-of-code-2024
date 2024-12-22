defmodule AdventOfCode.Day21 do
  # +---+---+---+
  # | 7 | 8 | 9 |
  # +---+---+---+
  # | 4 | 5 | 6 |
  # +---+---+---+
  # | 1 | 2 | 3 |
  # +---+---+---+
  #     | 0 | A |
  #     +---+---+

  @numeric_keypad_tree %{
    "1" => [            {"4", "^"}, {"2", ">"}            ],
    "2" => [{"1", "<"}, {"5", "^"}, {"3", ">"}, {"0", "v"}],
    "3" => [{"2", "<"}, {"6", "^"},             {"A", "v"}],
    "4" => [            {"7", "^"}, {"5", ">"}, {"1", "v"}],
    "5" => [{"4", "<"}, {"8", "^"}, {"6", ">"}, {"2", "v"}],
    "6" => [{"5", "<"}, {"9", "^"},             {"3", "v"}],
    "7" => [                        {"8", ">"}, {"4", "v"}],
    "8" => [{"7", "<"},             {"9", ">"}, {"5", "v"}],
    "9" => [{"8", "<"},                         {"6", "v"}],
    "0" => [            {"2", "^"}, {"A", ">"}            ],
    "A" => [{"0", "<"}, {"3", "^"}                        ],
  }

  #     +---+---+
  #     | ^ | A |
  # +---+---+---+
  # | < | v | > |
  # +---+---+---+

  @directional_keypad_tree %{
    "^" => [                        {"A", ">"}, {"v", "v"}],
    "A" => [{"^", "<"},                         {">", "v"}],
    "<" => [                        {"v", ">"}            ],
    "v" => [{"<", "<"}, {"^", "^"}, {">", ">"}            ],
    ">" => [{"v", "<"}, {"A", "^"}                        ],
  }


  def part1(args), do: execute(args, 2)

  def part2(args), do: execute(args, 25)

  def execute(input, times) do
    codes = get_codes(input)
    possible_paths = precompute_paths()

    values = numeric_values(codes)


  end


  defp compute_code_input_length(code, times, cache) do
    case cache[{code, times}] do
      nil ->
        {path_lengths, partial_cache} = ["A"|code]
          |> Enum.chunk_every(2,1)
          |> Enum.map(&List.to_tuple/1)
          |> Enum.map_reduce(
            cache,
            fn path, acc -> compute_path_input_length(path, times-1, acc) end
          )
        value = path_lengths |> Enum.sum()
        new_cache = Map.put(partial_cache, {code, times}, value)
        { value, new_cache }

      cached_value -> { cached_value, cache }
    end
  end

  defp compute_path_input_length(code, times, cache) do

  end



  defp precompute_paths() do
    Map.new()
    |> compute_all_paths(@numeric_keypad_tree)
    |> compute_all_paths(@directional_keypad_tree)
       # This may not be correct.
       # Can the end input be shorter if one of the internal paths is not the
       # smallest possible?
    |> only_shortest()
       # It may be possible to reduce the possible paths even further.
       # Paths with more "direction changes" are possibly shorter.
       # Example: "<<v" is probably shorter than "<v<" despite ending in the same position
  end

  defp only_shortest(path_map) do
    path_map
    |> Map.to_list()
    |> Stream.map(fn {key, paths} -> {key, shortest_paths(paths)} end)
    |> Map.new()
  end

  defp shortest_paths(paths) do
    size = paths
      |> Stream.map(&Enum.count/1)
      |> Enum.min()

    paths
    |> Enum.filter(fn path -> Enum.count(path) == size end)
  end

  defp compute_all_paths(path_map, tree) do
    nodes = Map.keys(tree)
    pairs = for from <- nodes, to <- nodes, do: {from, to}
    pairs
    |> Enum.reduce(
      path_map,
      fn {from, to}=key, acc ->
        p = paths(from, to, tree)
        Map.put(acc, key, p)
      end
    )
  end

  defp paths(from, to, tree), do: paths(from, to, tree, [from])
  defp paths(from, to, tree, previous)
  defp paths(from, to, _tree, _previous) when from == to, do: [["A"]]
  defp paths(from, to, tree, previous) do
    tree
    |> Map.get(from)
    |> Stream.filter(fn {value, _direction} -> !Enum.member?(previous, value) end)
    |> Enum.flat_map(
      fn {value, direction} ->
        paths(value, to, tree, [value|previous])
        |> Enum.map( &([direction|&1]))
      end
    )
  end

  defp numeric_values(codes) do
    Enum.map(codes, &numeric_value/1)
  end

  defp numeric_value(code) do
    code
    |> Enum.slice(0..-2//1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp get_codes(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.codepoints/1)
  end
end
