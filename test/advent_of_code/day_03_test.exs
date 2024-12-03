defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    expected_result = 161
    result = part1(input)

    assert expected_result == result, "Expected: #{expected_result} / Got: #{result}"
  end

  test "part2" do
    input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    expected_result = 48
    result = part2(input)

    assert expected_result == result, "Expected: #{expected_result} / Got: #{result}"
  end
end
