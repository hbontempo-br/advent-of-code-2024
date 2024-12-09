defmodule AdventOfCode.Day09 do
  def part1(args) do
    args
    |> parse
    |> compact()
    |> checksum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> parse([], 0, nil)
  end
  defp parse(input, output, current, next)
  defp parse([], output, _current, _next), do: Enum.reverse(output)
  defp parse([input_head|input_tail], output, current, next) do
    new_input = input_tail
    new_output = Enum.reduce(1..input_head//1, output, fn _, acc -> [current|acc] end)
    new_current = next
    new_next = case next do
      nil -> current + 1
      _ -> nil
    end
    parse(new_input, new_output, new_current, new_next)
  end

  defp compact(data)
  defp compact(data), do: compact(:queue.from_list(data), [])
  defp compact(data, result) do
    case :queue.is_empty(data) do
      true -> Enum.reverse(result)
      false ->
        case :queue.out(data) do
          { {:value, nil}, new_data} ->
            { {:value, back}, new_new_data } = :queue.out_r(new_data)
            new_new_new_data = :queue.in_r(back, new_new_data)
            compact(new_new_new_data, result)
          { {:value, front}, new_data } ->
            compact(new_data, [front|result])
        end
    end
  end

  defp checksum(data) do
    data
    |> Stream.with_index()
    |> Stream.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  # ----------

  def part2(args) do
    args
    |> parse2()
    |> compact2()
    |> checksum2()

  end

  defp parse2(input) do
    input
      |> String.trim()
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> parse2([], 0, nil)
    end
    defp parse2(input, output, current, next)
    defp parse2([], output, _current, _next), do: Enum.reverse(output)
    defp parse2([input_head|input_tail], output, current, next) do
      new_input = input_tail
      new_output = [{input_head, current}|output]
      new_current = next
      new_next = case next do
        nil -> current + 1
        _ -> nil
      end
      parse2(new_input, new_output, new_current, new_next)
    end

    defp compact2(data)
    defp compact2(data) do
      to_optmize = data
        |> Stream.filter(
          fn
            {_, nil} -> false
            _ -> true
          end
          )
        |> Enum.reverse()
      compact2(data, to_optmize)
    end
    defp compact2(data,to_optimize)
    defp compact2(data, []), do: data
    defp compact2(data, [{head_size,_}=head|tail]) do
      {new_data, _} = data
        |> Enum.flat_map_reduce(
          false,
          fn
            item, true when item == head -> {[{head_size, nil}], true}
            item, true -> {[item], true}
            item, false when item == head  -> {[head], true}
            {_, val} = item, false when not is_nil(val) -> {[item], false}
            {size, nil} = item, false when size < head_size -> {[item], false}
            {size, nil} = _item, false when size == head_size -> {[head], true}
            {size, nil} = _item, false when size > head_size -> {[head, {size - head_size, nil}], true}
          end
        )
      compact2(new_data, tail)
    end

    defp checksum2(data) do
      data
      |> Stream.flat_map(
        fn {size, val} ->
          actual_val = case val do
            nil -> 0
            x -> x
          end
          Enum.map(1..size//1, fn _ -> actual_val end)
        end
      )
      |> checksum()
    end
end
