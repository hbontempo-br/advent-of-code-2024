defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  test "execute" do
    input =
      """
      123
      """
    times = 1
    expected_result = 15887950
    result = part1(input, times)

    assert expected_result == result
  end

  test "part1" do
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

  @tag :skip
  test "part2" do
    input = nil
    expected_result = nil
    result = part2(input)

    assert expected_result == result
  end
end
