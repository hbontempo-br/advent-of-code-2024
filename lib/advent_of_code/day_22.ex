defmodule AdventOfCode.Day22 do

  def part1(args, times \\ 2000) do
    args
    |> parse()
    |> Stream.map(&(secret_number(&1, times)))
    |> Enum.sum()
  end

  def part2(args, times \\ 2000) do
    args
    |> parse()
    |> Stream.map(&(generate_data(&1, times)))
    |> Enum.map(&(generate_price_map(&1)))
    |> merge_prices()
    |> best_deal()
  end

  defp best_deal(merged_prices) do
    merged_prices
    |> Map.values()
    |> Enum.max()
  end

  defp merge_prices(price_maps) do
    price_maps
    |> Enum.reduce(
      Map.new(),
      fn price_map, merged_price_maps ->
        Map.merge(
          price_map,
          merged_price_maps,
          fn _key, value1, value2 -> value1 + value2 end
        )
      end
    )
  end

  defp generate_price_map(data) do
    data
    |> Enum.reduce(
      Map.new(),
      fn {_number, price, _delta, price_key}, acc ->
        Map.update(acc, price_key, price, &(&1))
      end
    )
  end

  defp generate_data(secret, size) do
    secret
    |> secret_number_list(size)
    |> add_diffs()
    |> add_price_key()
  end

  defp add_price_key(secret_numbers)
  defp add_price_key(secret_numbers) do
    {p1, p2} = Enum.split(secret_numbers, 3)
    queue_items = [nil|Enum.map(p1, &(elem(&1,2)))]
    queue = :queue.from_list(queue_items)
    add_price_key(p2, queue, [])
  end
  defp add_price_key(secret_numbers, queue, partial_response)
  defp add_price_key([], _queue, partial_response) do
    partial_response
    |> Stream.map(
      fn {number, price, delta, price_key} ->
        {number, price, delta, :queue.to_list(price_key)}
      end
    )
    |> Enum.reverse()
  end
  defp add_price_key([{_number, _price, diff}=head|tail], queue, partial_response) do
    new_queue = diff
      |> :queue.in(queue)
      |> :queue.drop()
    new_partial_response = [Tuple.append(head,new_queue)|partial_response]
    add_price_key(tail, new_queue, new_partial_response)
  end

  defp add_diffs(secret_numbers)
  defp add_diffs(secret_numbers) do
    [{_, price}|tail] = secret_numbers
    add_diffs(tail, price, [])
  end
  defp add_diffs(secret_numbers, previous_price, partial_response)
  defp add_diffs([], _previous_price, partial_response), do: Enum.reverse(partial_response)
  defp add_diffs([{_, price}=head|tail]=_secret_numbers, previous_price, partial_response) do
    diff_value = price - previous_price
    new_partial_response = [Tuple.append(head, diff_value)|partial_response]
    add_diffs(tail, price, new_partial_response)
  end

  defp secret_number_list(current, size), do: secret_number_list(current, size, [{current, price(current)}])
  defp secret_number_list(current, size, partial_response)
  defp secret_number_list(_current, 0, partial_response), do: Enum.reverse(partial_response)
  defp secret_number_list(current, size, partial_response) do
    new_secret_number = next_secret_number(current)
    new_price = price(new_secret_number)
    response_item = { new_secret_number, new_price }
    secret_number_list(new_secret_number, size-1, [response_item|partial_response])
  end

  defp price(current), do: rem(current, 10)

  defp secret_number(current, times)
  defp secret_number(current, 0), do: current
  defp secret_number(current, times) do
    next = next_secret_number(current)
    secret_number(next, times-1)
  end

  defp next_secret_number(current) do
    current
    |> process1()
    |> process2()
    |> process3()
  end

  defp process1(secret_number) do
    secret_number * 64
    |> mix(secret_number)
    |> prune()
  end

  defp process2(secret_number) do
    secret_number / 32
    |> Kernel.trunc()
    |> mix(secret_number)
    |> prune()
  end

  defp process3(secret_number) do
    secret_number * 2048
    |> mix(secret_number)
    |> prune()
  end

  defp mix(val, secret_number), do: Bitwise.bxor(val, secret_number)

  defp prune(val), do: rem(val, 16777216)

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
