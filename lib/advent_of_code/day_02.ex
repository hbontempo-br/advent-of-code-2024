defmodule AdventOfCode.Day02 do
  defp parse_reports(args) do
    args
      |> String.trim()
      |> String.split("\n")
      |> Stream.map(
        fn line ->
          line
          |> String.split()
          |> Enum.map(&String.to_integer/1)
        end
      )
      |> Enum.to_list()
  end

  defp check_safety(report) do
    {[first, second], tail} = Enum.split(report, 2)
    check_safety(first, dir(first, second), [second | tail])
  end
  defp check_safety(last_val, curr_dir, other_vals)
  defp check_safety(_last_val, _curr_dir, []), do: true
  defp check_safety(last_val, curr_dir, [other_head | other_tail]) do
    case {dir(last_val, other_head) == curr_dir, valid_step(last_val, other_head)} do
      {true, true} -> check_safety(other_head, curr_dir, other_tail)
      _ -> false
    end
  end

  defp dir(x1, x2)
  defp dir(x1, x2) when x1 < x2, do: :asc
  defp dir(x1, x2) when x1 > x2, do: :desc
  defp dir(x1, x2) when x1 == x2, do: nil

  defp step(x1, x2), do: Kernel.abs(x1 - x2)

  defp valid_step(x1, x2) do
    s = step(x1, x2)
    s <=  3 && s >= 1
  end

  defp report_variations(report) do
    report_size = Enum.count(report)
    Stream.map(0..report_size-1, &(new_report(report, &1)))
  end

  defp new_report(report, ignore_position) do
    {_, report_generated} = List.pop_at(report, ignore_position)
    report_generated
  end

  def part1(args) do
    args
    |> parse_reports()
    |> Stream.filter(&check_safety/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> parse_reports()
    |> Stream.filter(
      fn report ->
        all_possible_reports = Stream.concat([report], report_variations(report))
        Enum.any?(all_possible_reports, &check_safety/1)
      end
    )
    |> Enum.count()
  end
end
