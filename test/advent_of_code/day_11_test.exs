defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1" do
    input = "125 17"
    expected_result = 55312
    result = part1(input)

    assert expected_result == result
  end

  test "part2" do
    input = "125 17"
    expected_result = 65601038650482
    result = part2(input)

    assert expected_result == result
  end
end
