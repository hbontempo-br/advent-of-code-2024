defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input =
      """
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
      """
    expected_result = 11
    result = part1(input)

    assert expected_result == result
  end

  test "part2" do
    input =
      """
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
      """
    expected_result = 31
    result = part2(input)

    assert expected_result == result
  end
end
