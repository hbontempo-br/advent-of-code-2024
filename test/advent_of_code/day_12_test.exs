defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1 - example 1" do
    input =
      """
      AAAA
      BBCD
      BBCC
      EEEC
      """
    expected_result = 140
    result = part1(input)

    assert expected_result == result
  end

  test "part1 - example 2" do
    input =
      """
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
      """
    expected_result = 772
    result = part1(input)

    assert expected_result == result
  end

  test "part1 - example 3" do
    input =
      """
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
      """
    expected_result = 1930
    result = part1(input)

    assert expected_result == result
  end

  test "part2 - example 1" do
    input =
      """
      AAAA
      BBCD
      BBCC
      EEEC
      """
    expected_result = 80
    result = part2(input)

    assert expected_result == result
  end

  test "part2 - example 2" do
    input =
      """
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
      """
    expected_result = 436
    result = part2(input)

    assert expected_result == result
  end

  test "part2 - example 3" do
    input =
      """
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
      """
    expected_result = 236
    result = part2(input)

    assert expected_result == result
  end


  test "part2 - example 4" do
    input =
      """
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
      """
    expected_result = 368
    result = part2(input)

    assert expected_result == result
  end



  test "part2 - example 5" do
    input =
      """
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
      """
    expected_result = 1206
    result = part2(input)

    assert expected_result == result
  end
end
