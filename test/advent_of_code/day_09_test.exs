defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    input =  "2333133121414131402"
    expected_result = 1928
    result = part1(input)

    assert expected_result == result
  end

  test "part2" do
    input =  "2333133121414131402"
    expected_result = 2858
    result = part2(input)

    assert expected_result == result
  end
end
