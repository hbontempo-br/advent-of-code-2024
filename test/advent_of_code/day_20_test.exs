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
    max_distance = 2
    expected_result = 1
    result = execute(input, expected_savings, max_distance)

    assert expected_result == result
  end

  test "part2" do
    input = """
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
      expected_savings = 75
      max_distance = 20
      expected_result = 3
      result = execute(input, expected_savings, max_distance)

    assert expected_result == result
  end
end
