defmodule AdventOfCode.Day20Test do
  use ExUnit.Case

  import AdventOfCode.Day20

  test "part1" do
    input =
      """
      ###############
      #...#...#.....#
      #.#.#.#.#.###.#
      #S#...#.#.#...#
      #######.#.#.###
      #######.#.#...#
      #######.#.###.#
      ###..E#...#...#
      ###.#######.###
      #...###...#...#
      #.#####.#.###.#
      #.#...#.#.#...#
      #.#.#.#.#.#.###
      #...#...#...###
      ###############
      """
    expected_savings = 50
    expected_result = 1
    result = part1(input, expected_savings)

    assert expected_result == result
  end

  @tag :skip
  test "part2" do
    input = nil
    expected_result = nil
    result = part2(input)

    assert expected_result == result
  end
end
