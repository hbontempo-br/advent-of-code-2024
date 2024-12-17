defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "part1 - small 1" do
    input =
    """
    Register A: 0
    Register B: 0
    Register C: 9

    Program: 2,6
    """
    expected_result = ""
    result = part1(input)

    assert expected_result == result
  end

  test "part1 - small 2" do
    input =
    """
    Register A: 10
    Register B: 0
    Register C: 0

    Program: 5,0,5,1,5,4
    """
    expected_result = "0,1,2"
    result = part1(input)

    assert expected_result == result
  end

  test "part1 - small 3" do
    input =
    """
    Register A: 2024
    Register B: 0
    Register C: 9

    Program: 0,1,5,4,3,0
    """
    expected_result = "4,2,5,6,7,7,7,7,3,1,0"
    result = part1(input)

    assert expected_result == result
  end

  test "part1 - full" do
    input =
    """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """
    expected_result = "4,6,3,5,6,3,5,2,1,0"
    result = part1(input)

    assert expected_result == result
  end

  @tag :skip
  test "part2" do
    input =
      """
      Register A: 2024
      Register B: 0
      Register C: 0

      Program: 0,3,5,4,3,0
      """
      expected_result = 117440
      result = part2(input)

      assert expected_result == result
  end
end
