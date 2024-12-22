defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  test "part1 - small" do
    input =
      """
      123
      """
    times = 1
    expected_result = 15887950
    result = part1(input, times)

    assert expected_result == result
  end

  test "part1 - medium" do
    input =
      """
      1
      10
      100
      2024
      """
    expected_result = 37327623
    result = part1(input)

    assert expected_result == result
  end

  test "part2 - small" do
    input =
      """
      123
      """
    times = 10
    expected_result = 6
    result = part2(input, times)

    assert expected_result == result
  end

  test "part2 - medium" do
    input =
      """
      1
      2
      3
      2024
      """
    expected_result = 23
    result = part2(input)

    assert expected_result == result
  end
end
