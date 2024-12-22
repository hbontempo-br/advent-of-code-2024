defmodule AdventOfCode.Day21 do
  # Logic:
  #   1. Precompute what inputs are required to push to move from any button to any button
  #   2. For each code
  #     2.1 Get inputs required for pushing the code into the numeric keypad
  #       - Using the values from step q
  #     2.2 Do N (number of proxy doors) times:
  #       - Using the precomputed values from step 1 compute the new input
  #       - Do it 2.2 again
  #     2.3 Get lenght of the final input
  #     2.4 Retrieve the numeric part of the code
  #     2.5 Compute complexity
  #  3. Sum all

  @paths %{
    {"A", "0"} => "<A",
    {"0", "A"} => ">A",
    {"A", "1"} => "^<<A",
    {"1", "A"} => ">>vA",
    {"A", "2"} => "<^A",
    {"2", "A"} => "v>A",
    {"A", "3"} => "^A",
    {"3", "A"} => "vA",
    {"A", "4"} => "^^<<A",
    {"4", "A"} => ">>vvA",
    {"A", "5"} => "<^^A",
    {"5", "A"} => "vv>A",
    {"A", "6"} => "^^A",
    {"6", "A"} => "vvA",
    {"A", "7"} => "^^^<<A",
    {"7", "A"} => ">>vvvA",
    {"A", "8"} => "<^^^A",
    {"8", "A"} => "vvv>A",
    {"A", "9"} => "^^^A",
    {"9", "A"} => "vvvA",
    {"0", "1"} => "^<A",
    {"1", "0"} => ">vA",
    {"0", "2"} => "^A",
    {"2", "0"} => "vA",
    {"0", "3"} => "^>A",
    {"3", "0"} => "<vA",
    {"0", "4"} => "^<^A",
    {"4", "0"} => ">vvA",
    {"0", "5"} => "^^A",
    {"5", "0"} => "vvA",
    {"0", "6"} => "^^>A",
    {"6", "0"} => "<vvA",
    {"0", "7"} => "^^^<A",
    {"7", "0"} => ">vvvA",
    {"0", "8"} => "^^^A",
    {"8", "0"} => "vvvA",
    {"0", "9"} => "^^^>A",
    {"9", "0"} => "<vvvA",
    {"1", "2"} => ">A",
    {"2", "1"} => "<A",
    {"1", "3"} => ">>A",
    {"3", "1"} => "<<A",
    {"1", "4"} => "^A",
    {"4", "1"} => "vA",
    {"1", "5"} => "^>A",
    {"5", "1"} => "<vA",
    {"1", "6"} => "^>>A",
    {"6", "1"} => "<<vA",
    {"1", "7"} => "^^A",
    {"7", "1"} => "vvA",
    {"1", "8"} => "^^>A",
    {"8", "1"} => "<vvA",
    {"1", "9"} => "^^>>A",
    {"9", "1"} => "<<vvA",
    {"2", "3"} => ">A",
    {"3", "2"} => "<A",
    {"2", "4"} => "<^A",
    {"4", "2"} => "v>A",
    {"2", "5"} => "^A",
    {"5", "2"} => "vA",
    {"2", "6"} => "^>A",
    {"6", "2"} => "<vA",
    {"2", "7"} => "<^^A",
    {"7", "2"} => "vv>A",
    {"2", "8"} => "^^A",
    {"8", "2"} => "vvA",
    {"2", "9"} => "^^>A",
    {"9", "2"} => "<vvA",
    {"3", "4"} => "<<^A",
    {"4", "3"} => "v>>A",
    {"3", "5"} => "<^A",
    {"5", "3"} => "v>A",
    {"3", "6"} => "^A",
    {"6", "3"} => "vA",
    {"3", "7"} => "<<^^A",
    {"7", "3"} => "vv>>A",
    {"3", "8"} => "<^^A",
    {"8", "3"} => "vv>A",
    {"3", "9"} => "^^A",
    {"9", "3"} => "vvA",
    {"4", "5"} => ">A",
    {"5", "4"} => "<A",
    {"4", "6"} => ">>A",
    {"6", "4"} => "<<A",
    {"4", "7"} => "^A",
    {"7", "4"} => "vA",
    {"4", "8"} => "^>A",
    {"8", "4"} => "<vA",
    {"4", "9"} => "^>>A",
    {"9", "4"} => "<<vA",
    {"5", "6"} => ">A",
    {"6", "5"} => "<A",
    {"5", "7"} => "<^A",
    {"7", "5"} => "v>A",
    {"5", "8"} => "^A",
    {"8", "5"} => "vA",
    {"5", "9"} => "^>A",
    {"9", "5"} => "<vA",
    {"6", "7"} => "<<^A",
    {"7", "6"} => "v>>A",
    {"6", "8"} => "<^A",
    {"8", "6"} => "v>A",
    {"6", "9"} => "^A",
    {"9", "6"} => "vA",
    {"7", "8"} => ">A",
    {"8", "7"} => "<A",
    {"7", "9"} => ">>A",
    {"9", "7"} => "<<A",
    {"8", "9"} => ">A",
    {"9", "8"} => "<A",
    {"<", "^"} => ">^A",
    {"^", "<"} => "v<A",
    {"<", "v"} => ">A",
    {"v", "<"} => "<A",
    {"<", ">"} => ">>A",
    {">", "<"} => "<<A",
    {"<", "A"} => ">>^A",
    {"A", "<"} => "v<<A",
    {"^", "v"} => "vA",
    {"v", "^"} => "^A",
    {"^", ">"} => "v>A",
    {">", "^"} => "<^A",
    {"^", "A"} => ">A",
    {"A", "^"} => "<A",
    {"v", ">"} => ">A",
    {">", "v"} => "<A",
    {"v", "A"} => "^>A",
    {"A", "v"} => "<vA",
    {">", "A"} => "^A",
    {"A", ">"} => "vA",
    {"A", "A"} => "A",
    {"1", "1"} => "A",
    {"2", "2"} => "A",
    {"3", "3"} => "A",
    {"4", "4"} => "A",
    {"5", "5"} => "A",
    {"6", "6"} => "A",
    {"7", "7"} => "A",
    {"8", "8"} => "A",
    {"9", "9"} => "A",
    {"0", "0"} => "A",
    {"<", "<"} => "A",
    {">", ">"} => "A",
    {"^", "^"} => "A",
    {"v", "v"} => "A"
  }

  def part1(args), do: execute(args, 2)

  def part2(args), do: execute(args, 25)

  def execute(input, times) do
    codes = input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)

    final_inputs = codes
      |> Enum.map(
        fn code ->
          1..(times+1)
          |> Enum.reduce(
            code,
            fn _, code -> iterate(code) end
          )
        end
      )

    lengths = final_inputs |> Enum.map(&String.length/1)

    numeric_values = codes
      |> Enum.map(&numeric_value/1)

    Enum.zip(lengths, numeric_values)
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()


  end

  defp iterate(code) do
    code
    |> String.codepoints()
    |> Enum.map_reduce(
      "A",
      fn current, previous ->
        { {previous, current}, current }
      end
    )
    |> then(&(elem(&1, 0)))
    |> Stream.map(&(@paths[&1]))
    |> Enum.join()
  end

  defp numeric_value(code) do
    code
    |> String.slice(0..2)
    |> String.to_integer()
  end
end
