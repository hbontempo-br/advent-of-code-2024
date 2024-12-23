defmodule AdventOfCode.Day23Test do
  use ExUnit.Case

  import AdventOfCode.Day23

  test "part1" do
    input =
      """
      kh-tc
      qp-kh
      de-cg
      ka-co
      yn-aq
      qp-ub
      cg-tb
      vc-aq
      tb-ka
      wh-tc
      yn-cg
      kh-ub
      ta-co
      de-co
      tc-td
      tb-wq
      wh-td
      ta-ka
      td-qp
      aq-cg
      wq-ub
      ub-vc
      de-ta
      wq-aq
      wq-vc
      wh-yn
      ka-de
      kh-ta
      co-tc
      wh-qp
      tb-vc
      td-yn
      """
    expected_result = 7
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
