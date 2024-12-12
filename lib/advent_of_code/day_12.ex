defmodule AdventOfCode.Day12 do
  def part1(args) do
    args
    |> parse_input()
    |> compute_regions()
    |> Enum.map(&individual_price/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> compute_regions()
    |> Enum.map(&bulk_price/1)
    |> Enum.sum()
  end

  defp bulk_price(region) do
    sides(region) * area(region)
  end

  defp individual_price(region) do
    perimeter(region) * area(region)
  end

  # the number of sides is the same as number of corder
  defp sides(region), do: corners(region)

  defp corners(region) do
    region
    |> MapSet.to_list()
    |> Enum.reduce(
      0,
      fn position, acc ->
        [
          {[:up,   :right], [             ]},
          {[:up,   :left ], [             ]},
          {[:down, :right], [             ]},
          {[:down, :left ], [             ]},
          {[:up_right    ], [:up,   :right]},
          {[:up_left     ], [:up,   :left ]},
          {[:down_right  ], [:down, :right]},
          {[:down_left   ], [:down, :left ]},
        ]
        |> Stream.filter(
          fn {not_members, members} ->
            validation1 = not_members
              |> Enum.all?(
                fn dir ->
                  next_position = next(position, dir)
                  !MapSet.member?(region, next_position)
                end
              )
            validation2 = members
              |> Enum.all?(
                fn dir ->
                  next_position = next(position, dir)
                  MapSet.member?(region, next_position)
                end
              )
            validation1 && validation2
          end
        )
        |> Enum.count()
        |> Kernel.+(acc)
      end
    )
  end

  defp perimeter(region) do
    region
    |> MapSet.to_list()
    |> Enum.reduce(
      0,
      fn position, acc ->
        [:up, :down, :left, :right]
        |> Stream.filter(
          fn dir ->
            next_position = next(position, dir)
            !MapSet.member?(region, next_position)
          end
        )
        |> Enum.count()
        |> Kernel.+(acc)
      end
    )
  end

  defp area(region), do: MapSet.size(region)

  defp compute_regions(map), do: compute_regions(map, [], all_positions(map))
  defp compute_regions(map, regions, positions) do
    case MapSet.size(positions) == 0 do
      true -> regions
      false ->
        position = Enum.random(positions)
        new_region = region(position, map)

        new_regions = [new_region|regions]
        new_positions = MapSet.difference(positions, new_region)

        compute_regions(map, new_regions, new_positions)
    end
  end

  defp region(position, map)
  defp region(position, map), do: region(position, Map.get(map, position), map, MapSet.new())
  defp region(position, value, map, region) do
    case MapSet.member?(region, position) do
      true -> region
      false ->
        case Map.get(map, position) == value do
          false -> region
          true ->
            new_region = MapSet.put(region, position)

            [:up, :down, :left, :right]
            |> Enum.reduce(
              new_region,
              fn dir, acc ->
                next_position = next(position, dir)
                region(next_position, value, map, acc)
              end
            )
        end
    end
  end



  defp next(position, direction)
  defp next({ x, y }, :up),         do: { x-1, y   }
  defp next({ x, y }, :down),       do: { x+1, y   }
  defp next({ x, y }, :left),       do: { x  , y-1 }
  defp next({ x, y }, :right),      do: { x  , y+1 }
  defp next({ x, y }, :up_right),   do: { x-1, y+1 }
  defp next({ x, y }, :up_left),    do: { x-1, y-1 }
  defp next({ x, y }, :down_right), do: { x+1, y+1 }
  defp next({ x, y }, :down_left),  do: { x+1, y-1 }

  defp all_positions(map), do: map |> Map.keys() |> MapSet.new()

  defp parse_input(text) do
    text
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
  end
end
