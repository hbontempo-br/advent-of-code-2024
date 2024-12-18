defmodule AdventOfCode.Day18 do
  def part1(input, dimensions \\ {70, 70}, elapsed_time \\ 1024) do
    grid = create_grid(dimensions)
    byte_list = parse(input)
    corrupted_grid = compute_corruption(grid, byte_list, elapsed_time)
    least_amout_of_steps(corrupted_grid, {0,0}, dimensions)
  end

  def part2(input, dimensions \\ {70, 70}, start \\ 1024) do
    byte_list = parse(input)
    find_unreachable(byte_list, dimensions, start)
  end

  defp find_unreachable(byte_list, dimensions, start) when is_number(start) do
    {first, second} = Enum.split(byte_list, start)
    find_unreachable(second, MapSet.new(first), dimensions)
  end
  defp find_unreachable([head|tail], corrupted_bytes, {columns, rows}=dimensions) when is_tuple(dimensions) do
    # If a chain of nodes extends from side-to-side of the map then there is no path from distinct corners
    nodes = connected_nodes(head, corrupted_bytes)
    column_0   = Enum.any?(nodes, fn {c,_} -> c == 0       end)
    column_max = Enum.any?(nodes, fn {c,_} -> c == columns end)
    row_0      = Enum.any?(nodes, fn {_,r} -> r == 0       end)
    row_max    = Enum.any?(nodes, fn {_,r} -> r == rows    end)
    case ((column_0 && column_max) || (row_0 && row_max)) do
      true -> head
      false -> find_unreachable(tail, MapSet.put(corrupted_bytes, head), dimensions)
    end
  end

  defp connected_nodes(node, node_list)
  defp connected_nodes(node, node_list) when is_tuple(node), do: connected_nodes([node], [], MapSet.new(node_list))
  defp connected_nodes([], visited_nodes, _not_visited_nodes), do: visited_nodes
  defp connected_nodes(to_analise_nodes, visited_nodes, not_visited_nodes) do
    new_visited_nodes = visited_nodes ++ to_analise_nodes
    {new_to_analise_nodes, new_not_visited_nodes} = to_analise_nodes
      |> Enum.flat_map_reduce(
        not_visited_nodes,
        fn position, acc ->
          extended_directions()
          |> Enum.flat_map_reduce(
            acc,
            fn direction, acc2 ->
              new_position = move(position, direction)
              case MapSet.member?(acc2, new_position) do
                false -> {[], acc2}
                true -> {[new_position], MapSet.delete(acc2, new_position)}
              end
            end
          )
        end
      )
    connected_nodes(new_to_analise_nodes, new_visited_nodes, new_not_visited_nodes)
  end


  defp least_amout_of_steps(grid, start_position, end_position) do
    least_amout_of_steps(
      grid,
      [start_position],
      end_position,
      0,
      MapSet.new()
    )
  end
  defp least_amout_of_steps(grid, current_positions, end_position, count, already_visited) do
    new_already_visited = MapSet.union(already_visited, MapSet.new(current_positions))
    new_count = count + 1
    new_current_positions = current_positions
      |> Stream.flat_map(
        fn current_position ->
          directions()
          |> Enum.map(&(move(current_position,&1)))
        end
      )
      |> Stream.uniq()
      |> Stream.filter(&(!MapSet.member?(new_already_visited,&1)))
      |> Stream.filter(&(Map.get(grid,&1)==:safe))

    case Enum.any?(new_current_positions, &(&1==end_position)) do
      true -> new_count
      false ->
        least_amout_of_steps(
          grid,
          new_current_positions,
          end_position,
          new_count,
          new_already_visited
        )
    end
  end

  defp compute_corruption(grid, byte_list, elapsed_time) do
    byte_list
    |> Enum.take(elapsed_time)
    |> Enum.reduce(
      grid,
      fn pos, acc -> Map.put(acc, pos, :corrupted) end
    )
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(
      fn line ->
        line
        |> String.trim()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end
    )
  end

  defp create_grid(dimensions)
  defp create_grid({columns, rows}=_dimensions) do
    for column <- 0..columns, row <- 0..rows, into: %{}, do: {{column, row},:safe}
  end

  defp move(position, direction)
  defp move({column, row}, :up        ), do: {column  , row-1}
  defp move({column, row}, :down      ), do: {column  , row+1}
  defp move({column, row}, :right     ), do: {column+1, row  }
  defp move({column, row}, :left      ), do: {column-1, row  }
  defp move({column, row}, :up_right  ), do: {column+1, row-1}
  defp move({column, row}, :up_left   ), do: {column-1, row-1}
  defp move({column, row}, :down_right), do: {column+1, row+1}
  defp move({column, row}, :down_left ), do: {column-1, row+1}

  defp directions(), do: [:up, :down, :right, :left]
  defp extended_directions(), do: [:up, :down, :right, :left, :up_right, :up_left, :down_right, :down_left]
end
