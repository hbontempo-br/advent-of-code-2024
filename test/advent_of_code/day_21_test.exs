defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  import AdventOfCode.Day21

  test "part1" do
    input =
      """
      029A
      980A
      179A
      456A
      379A
      """
    times = 2
    expected_result = 126384
    result = execute(input, times)

    assert expected_result == result
  end
end
