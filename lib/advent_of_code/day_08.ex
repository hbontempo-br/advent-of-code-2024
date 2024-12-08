defmodule AdventOfCode.Day08 do
  def part1(args) do
    { _map, positions, antenas } = parse_input(args)

    # IO.inspect(antenas)

    antenas
    |> Map.values()
    |> Stream.map(&antinodes/1)
    # |> Enum.to_list() |> IO.inspect()
    |> Stream.map(&(MapSet.intersection(&1, positions)))
    # |> Enum.to_list() |> IO.inspect()
    |> Enum.reduce(
      MapSet.new(),
      fn elem, acc -> MapSet.union(acc, elem) end
    )
    |> MapSet.size()
  end

  defp parse_input(text) do
    map = text
      |> String.trim()
      |> String.split("\n")
      |> Stream.with_index()
      |> Stream.flat_map(
        fn {line, row} ->
          line
          |> String.trim()
          |> String.codepoints()
          |> Stream.with_index()
          |> Enum.map(fn {val, column} -> {{row, column}, val} end)
        end
      )
      |> Enum.reduce(
        Map.new(),
        fn {position, val}, acc -> Map.put(acc, position, val) end
      )

    positions = map
      |> Map.keys

    antenas = positions
      |> Enum.reduce(
        Map.new(),
        fn position, acc ->
          case Map.get(map, position) do
            "." -> acc
            val ->
              current = Map.get(acc, val, [])
              Map.put(acc, val, [position|current])
          end
        end
      )

    { map, MapSet.new(positions), antenas}
  end

  defp antinodes(positions)
  defp antinodes([head|tail]), do: antinodes(head, tail, MapSet.new())
  defp antinodes(current_position, other_positions, antinodes)
  defp antinodes(_current_position, [], antinodes), do: antinodes # |> IO.inspect()
  defp antinodes(current_position, [other_head|other_tail] = other_positions, antinodes) do
    new_antidotes = other_positions
      |> Enum.reduce(
        antinodes,
        fn other_position, acc ->
          MapSet.union(acc, mirros(current_position, other_position))
        end
      )
    antinodes(other_head, other_tail, new_antidotes)
  end

  defp mirros(position1, position2) do
    MapSet.new([mirror(position1, position2),mirror(position2, position1)])
  end

  defp mirror(position1, position2)
  defp mirror({row1, column1}, {row2, column2}), do: {(row2 - row1) + row2, (column2 - column1) + column2}

# ---------------------------------------------

  def part2(args) do
    { _map, positions, antenas } = parse_input(args)

    antenas
    |> Map.values()
    |> Stream.map(&(antinodes2(&1, positions)))
    # |> Enum.to_list() |> IO.inspect()
    |> Stream.map(&(MapSet.intersection(&1, positions)))
    # |> Enum.to_list() |> IO.inspect()
    |> Enum.reduce(
      MapSet.new(),
      fn elem, acc -> MapSet.union(acc, elem) end
    )
    # |> IO.inspect()
    |> MapSet.size()
  end

  defp antinodes2(antenas, positions)
  defp antinodes2([head|tail], positions), do: antinodes2(head, tail, MapSet.new(), positions)
  defp antinodes2(current_antena, other_antenas, antinodes, positions)
  defp antinodes2(_current_antena, [], antinodes, _positions), do: antinodes # |> IO.inspect()
  defp antinodes2(current_antena, [other_head|other_tail] = other_antenas, antinodes, positions) do
    new_antidotes = other_antenas
      |> Enum.reduce(
        antinodes,
        fn other_antena, acc ->
          MapSet.union(acc, mirros2(current_antena, other_antena, positions))
        end
      )
    antinodes2(other_head, other_tail, new_antidotes, positions)
  end

  defp mirros2(antena1, antena2, positions) do
    MapSet.union(mirror2(antena1, antena2, positions),mirror2(antena2, antena1, positions))
  end

  # Replicate antinodes until out of the mat (and add antinode to the antenas itself)
  defp mirror2(antena1, antena2, positions), do: mirror2(antena1, antena2, positions, MapSet.new([antena1, antena2]))
  defp mirror2(antena1, antena2, positions, partial_response)
  defp mirror2({row1, column1}, {row2, column2} = antena2, positions, partial_response) do
    new_position = {(row2 - row1) + row2, (column2 - column1) + column2}
    # |> IO.inspect()
    case MapSet.member?(positions, new_position) do
      true -> mirror2(antena2, new_position, positions, MapSet.put(partial_response, new_position))
      false -> partial_response
    end
  end
end
