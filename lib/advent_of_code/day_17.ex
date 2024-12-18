defmodule AdventOfCode.Day17 do
  def part1(args) do
    { register, program } = args
      |> parse_input()
    output = run_program(register, program)
    Enum.join(output, ",")
  end

  def part2(args) do
    # Analysing at the specific program of the input it became apparent:
    #   - The program is a simple loop (starts, do stuff, output and loop)
    #   - Register B and C are "reset" every iteration and depends only on the current A value
    #   - Looks like only the first 3 bits or 6 are important for the output of the loop
    #
    # A bit of mesing arround and it became clear a patter:
    #   - Input (in base 8): ABCDE...
    #   - Output: ..., f(E,D), f(D,C), f(C,B), f(B,A), f(A)
    #
    # With this the strategy for finding the input that gives the output is to construct it
    # digit by digit (base8).
    # Idea:
    #   1. Start with a sing digit (base8) input and get all that result in the last digit of the program.
    #   2. With digits that passed step1, add another digit to the input and check if the last 2 digits of the output matchs the program
    #   3. Keep the loop until all the program is mached with the output

    { register, program } = parse_input(args)
    solutions = find_solutions(register, program)
    Enum.min(solutions)
  end

  defp find_solutions(register, program, response \\ "") do
    reverse_program = Enum.reverse(program)
    0..7
    |> Enum.flat_map(
      fn x ->
        input_str = response <> Integer.to_string(x, 8)
        input = String.to_integer(input_str, 8)
        updated_register = %{register | a: input}
        output = run_program(updated_register, program)
        reverse_output = Enum.reverse(output)

        case reverse_output == reverse_program do
          true -> [input]
          false ->
            partial_equal = Enum.zip(reverse_output, reverse_program)
              |> Enum.all?(&(elem(&1,0)==elem(&1,1)))
            case partial_equal do
              false -> []
              true -> find_solutions(register, program, input_str)
            end
        end
      end
    )
  end

  defp run_program(register,  program)
  defp run_program(register,  program), do: run_program(register, program, Enum.count(program), 0, [])
  defp run_program(register,  program,  program_length, pointer, output)
  defp run_program(_register, _program, program_length, pointer, output) when pointer >= program_length, do: Enum.reverse(output)
  defp run_program(register,  program,  program_length, pointer, output) do
    opcode = Enum.at(program, pointer)
    operand = Enum.at(program, pointer+1)
    {new_output, new_pointer, new_register} = execute_command(opcode, operand, register)
    run_program(
      new_register,
      program,
      program_length,
      (if is_nil(new_pointer), do: pointer+2, else: new_pointer),
      (if is_nil(new_output), do: output, else: [new_output|output])
    )
  end

  defp execute_command(opcode, operand, register)
  defp execute_command(0, operand, register) do
    # adv
    numerator = register[:a]
    denominator = Integer.pow(2, combo_operand(operand, register))
    div = Integer.floor_div(numerator, denominator)
    new_register = %{ register | a: div}
    {nil, nil, new_register}
  end
  defp execute_command(1, operand, register) do
    # bxl
    left = register[:b]
    right = operand
    xor = Bitwise.bxor(left, right)
    new_register = %{ register | b: xor}
    {nil, nil, new_register}
  end
  defp execute_command(2, operand, register) do
    # bst
    new_register = %{ register | b: rem(combo_operand(operand, register), 8)}
    {nil, nil, new_register}
  end
  defp execute_command(3, operand, register) do
    # jnz
    case register[:a] do
      0 -> {nil, nil, register}
      _ -> {nil, operand, register}
    end

  end
  defp execute_command(4, _operand, register) do
    # bxc
    left = register[:b]
    right = register[:c]
    xor = Bitwise.bxor(left, right)
    new_register = %{ register | b: xor}
    {nil, nil, new_register}
  end
  defp execute_command(5, operand, register) do
    # out
    {rem(combo_operand(operand, register), 8), nil, register}
  end
  defp execute_command(6, operand, register) do
    # bdv
    numerator = register[:a]
    denominator = Integer.pow(2, combo_operand(operand, register))
    div = Integer.floor_div(numerator, denominator)
    new_register = %{ register | b: div}
    {nil, nil, new_register}
  end
  defp execute_command(7, operand, register) do
    # cdv
    numerator = register[:a]
    denominator = Integer.pow(2, combo_operand(operand, register))
    div = Integer.floor_div(numerator, denominator)
    new_register = %{ register | c: div}
    {nil, nil, new_register}
  end

  defp combo_operand(operand, register)
  defp combo_operand(0, _register), do: 0
  defp combo_operand(1, _register), do: 1
  defp combo_operand(2, _register), do: 2
  defp combo_operand(3, _register), do: 3
  defp combo_operand(4, register ), do: register[:a]
  defp combo_operand(5, register ), do: register[:b]
  defp combo_operand(6, register ), do: register[:c]

  defp parse_input(input) do
    [register_str, program_str] = input
      |> String.trim()
      |> String.split("\n\n")

    register = parse_register(register_str)
    program = parse_program(program_str)

    { register, program }
  end

  defp parse_program(program_str) do
    [_, value_str] = program_str
      |> String.trim()
      |> String.split(": ")

    value_str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_register(register_str) do
    [a, b, c] = register_str
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse_register_line/1)
    %{a: a, b: b, c: c}
  end

  defp parse_register_line(register_line) do
    [_, value_str] = register_line
      |> String.trim()
      |> String.split(": ")
    String.to_integer(value_str)
  end
end
