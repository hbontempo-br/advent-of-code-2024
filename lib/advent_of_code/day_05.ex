defmodule AdventOfCode.Day05 do
  def part1(args) do
    { rules, prints } = parse_input(args)
    prints
    |> Enum.filter(&(valid_print?(&1, rules)))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  def part2(args) do
    { rules, prints } = parse_input(args)
    prints
    |> Enum.filter(&(!valid_print?(&1, rules)))
    |> Enum.map(&(fix_print(&1, rules)))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  defp fix_print(print, rules)
  defp fix_print([head | tail], rules), do: fix_print(head, tail, rules, [])
  defp fix_print(current_page, other_pages, rules, answer)
  defp fix_print(_current_page, [], _rules, answer), do: Enum.reverse(answer)
  defp fix_print(current_page, [other_head|other_tail]=other_pages, rules, current_answer) do
    possible_next_pages = Map.get(rules, current_page, MapSet.new())
    case MapSet.subset?(MapSet.new(other_pages), possible_next_pages) do
      true -> fix_print(other_head, other_tail, rules, [ current_page | current_answer ])
      false -> fix_print(other_head, List.insert_at(other_tail, -1, current_page), rules, current_answer)
    end
  end

  defp valid_print?(print, rules)
  defp valid_print?([head | tail], rules), do: valid_print?(head, tail, rules)
  defp valid_print?(current_page, other_pages, rules)
  defp valid_print?(_current_page, [], _rules), do: true
  defp valid_print?(current_page, [other_head|other_tail]=other_pages, rules) do
    possible_next_pages = Map.get(rules, current_page, MapSet.new())
    case MapSet.subset?(MapSet.new(other_pages), possible_next_pages) do
      true -> valid_print?(other_head, other_tail, rules)
      false -> false
    end
  end


  defp middle_page(print) do
    count = Enum.count(print)
    middle = Integer.floor_div(count, 2)
    Enum.at(print, middle)
  end

  defp parse_input(text) do
    lines = text
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)

    break = Enum.find_index(lines, &(&1==""))

    rules_lines = Enum.slice(lines, 0..(break-1)//1)
    print_lines = Enum.slice(lines, (break+1)..-1//1)

    {
      parse_rules(rules_lines),
      parse_print(print_lines)
    }
  end

  defp parse_print(print_lines) do
    print_lines
    |> Enum.map(&parse_print_line/1)
  end

  defp parse_print_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_rules(rules_lines) do
    rules_lines
    |> Enum.map(
      fn line ->
        line
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
      end
    )
    |> Enum.reduce(
      Map.new(),
      fn [key, val], acc ->
        current_set = Map.get(acc, key, MapSet.new())
        new_set = MapSet.put(current_set, val)
        Map.put(acc, key, new_set)
      end
    )
  end
end
