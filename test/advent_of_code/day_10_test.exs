defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1" do
    input =
      """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """
    expected_result = 36
    result = part1(input)

    assert expected_result == result
  end

  test "part2" do
    input =
      """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """
    expected_result = 81
    result = part2(input)

    assert expected_result == result
  end
end
