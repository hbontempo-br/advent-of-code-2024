defmodule AdventOfCode.Day24 do
  def part1(args) do
    args
    |> parse()
    |> compute_number("z")

  end

  def part2(_args) do
  end

  defp compute_number(wire_map, starts_with) do
    wire_map
    |> wires_starting_with(starts_with)
    |> Enum.map_reduce(
      wire_map,
      &compute_value/2
    )
    |> elem(0)
    |> Enum.map(
      fn
        true -> "1"
        false -> "0"
      end
    )
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp compute_value(wire, map) do
    case map[wire] do
      x when is_boolean(x) -> { x, map }
      {action, wire1, wire2} ->
        { val1, cache1 } = compute_value(wire1, map)
        { val2, cache2 } = compute_value(wire2, cache1)
        val = case action do
          :and -> val1 && val2
          :or -> val1 || val2
          :xor -> val1 != val2
        end
        new_cache = Map.put(cache2, wire, val)
        { val, new_cache }
    end
  end

  defp wires_starting_with(wire_map, starts_with) do
    wire_map
    |> Map.keys()
    |> Enum.filter(&(String.starts_with?(&1,starts_with)))
    |> Enum.sort(:desc)
  end

  defp parse(input) do
    [input1, input2] = input
      |> String.trim()
      |> String.split("\n\n")

    Map.new()
    |> parse1(input1)
    |> parse2(input2)
  end

  defp parse1(output, input1) do
    input1
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(
      output,
      fn line, acc ->
        [ wire, value_str ] = line
          |> String.trim()
          |> String.split(": ")
        value = (value_str == "1")
        Map.put(acc, wire, value)
      end
    )


  end

  defp parse2(output, input2) do
    regex = ~r/(?<wire1>.{3})\ (?<command>.+)\ (?<wire2>.{3})\ \-\>\ (?<wire3>.{3})/
    input2
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(
      output,
      fn line, acc ->
        captures = Regex.named_captures(regex, String.trim(line))
        command = captures["command"]
          |> String.downcase()
          |> String.to_atom()
          Map.put(acc, captures["wire3"], { command, captures["wire1"], captures["wire2"]})
      end
    )
  end
end
