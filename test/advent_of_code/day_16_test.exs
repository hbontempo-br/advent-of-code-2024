defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  test "part1 - example 1" do
    input =
      """
      ###############
      #.......#....E#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #S..#.....#...#
      ###############
      """
    expected_result = 7036
    result = part1(input)

    assert expected_result == result
  end

  test "part1 - example 2" do
    input =
      """
      #################
      #...#...#...#..E#
      #.#.#.#.#.#.#.#.#
      #.#.#.#...#...#.#
      #.#.#.#.###.#.#.#
      #...#.#.#.....#.#
      #.#.#.#.#.#####.#
      #.#...#.#.#.....#
      #.#.#####.#.###.#
      #.#.#.......#...#
      #.#.###.#####.###
      #.#.#...#.....#.#
      #.#.#.#####.###.#
      #.#.#.........#.#
      #.#.#.#########.#
      #S#.............#
      #################
      """
    expected_result = 11048
    result = part1(input)

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
