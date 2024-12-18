defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  test "part1" do
    input =
      """
      5,4
      4,2
      4,5
      3,0
      2,1
      6,3
      2,4
      1,5
      0,6
      3,3
      2,6
      5,1
      1,2
      5,5
      2,5
      6,5
      1,4
      0,4
      6,4
      1,1
      6,1
      1,0
      0,5
      1,6
      2,0
      """
    dimensions = {6, 6}
    elapsed_time = 12
    expected_result = 22
    result = part1(input, dimensions, elapsed_time)

    assert expected_result == result
  end

  test "part2" do
    input =
      """
      5,4
      4,2
      4,5
      3,0
      2,1
      6,3
      2,4
      1,5
      0,6
      3,3
      2,6
      5,1
      1,2
      5,5
      2,5
      6,5
      1,4
      0,4
      6,4
      1,1
      6,1
      1,0
      0,5
      1,6
      2,0
      """
    dimensions = {6, 6}
    start = 12
    expected_result = {6,1}
    result = part2(input, dimensions, start)

    assert expected_result == result
  end
end
