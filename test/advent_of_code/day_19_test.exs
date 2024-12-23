defmodule AdventOfCode.Day19Test do
  use ExUnit.Case

  import AdventOfCode.Day19

  test "part1" do
    input =
      """
      r, wr, b, g, bwu, rb, gb, br

      brwrr
      bggr
      gbbr
      rrbgbr
      ubwu
      bwurrg
      brgr
      bbrgwb
      """
    expected_result = 6
    result = part1(input)

    assert expected_result == result
  end

  test "part2" do
    input =
      """
      r, wr, b, g, bwu, rb, gb, br

      brwrr
      bggr
      gbbr
      rrbgbr
      ubwu
      bwurrg
      brgr
      bbrgwb
      """
    expected_result = 16
    result = part2(input)

    assert expected_result == result
  end
end
