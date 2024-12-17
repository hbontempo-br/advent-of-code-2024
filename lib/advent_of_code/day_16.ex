defmodule AdventOfCode.Day16 do
  def part1(args) do
    {start_position, end_position, map} = parse_input(args)
    {score, _visited} = find_score({start_position, :right}, end_position, map)
    score
  end

  def part2(args) do
    {start_position, end_position, map} = parse_input(args)
    {_score, visited} = find_score({start_position, :right}, end_position, map)
    paths = get_paths(visited, end_position, {start_position, :right})
    seats = best_seats(paths)
    Enum.count(seats)
  end

  defp best_seats(paths) do
    paths |> Enum.reduce([], &(&1++&2)) |> Enum.uniq()
  end

  defp get_paths(visited, end_position, start_state) do
    visited
    |> Map.keys()
    |> Enum.filter(&(elem(&1, 0) == end_position))
    |> Enum.flat_map(&get_paths(&1, visited, start_state, [[]]))
    |> Enum.map(fn path ->
      path
      |> Enum.map(&elem(&1, 0))
      |> Enum.uniq()
    end)
    |> Enum.uniq()
  end

  defp get_paths(state, _visited, until_state, paths) when state == until_state, do: paths

  defp get_paths(state, visited, until_state, paths) do
    visited
    |> Map.get(state)
    |> elem(1)
    |> Enum.flat_map(fn new_state ->
      paths
      |> Enum.flat_map(fn path ->
        get_paths(new_state, visited, until_state, [[state | path]])
      end)
    end)
  end

  defp update_computations(state, score, estimates, visited, map) do
    current_state_estimate = Map.get(estimates, state)
    new_visited = Map.put(visited, state, current_state_estimate)
    initial_estimates = Map.delete(estimates, state)

    new_estimates =
      [
        {rotate(state, :counterclockwise), score + 1000},
        {rotate(state, :clockwise), score + 1000},
        {rotate(state, :inverse), score + 2000},
        {next(state), score + 1}
      ]
      |> Enum.filter(fn {new_state, _} -> !Map.has_key?(new_visited, new_state) end)
      |> Enum.filter(fn {new_state, _} -> valid?(new_state, map) end)
      |> Enum.reduce(
        initial_estimates,
        fn {new_state, new_score}, acc ->
          Map.update(
            acc,
            new_state,
            {new_score, [state]},
            fn
              {current_score, _previous_states} = current_estimate
              when new_score > current_score ->
                current_estimate

              {current_score, _previous_states} = _current_estimate
              when new_score < current_score ->
                {new_score, [state]}

              {current_score, previous_states} = _current_estimate
              when new_score == current_score ->
                {current_score, [state | previous_states]}
            end
          )
        end
      )

    {new_estimates, new_visited}
  end

  defp next_state(estimates) do
    estimates
    |> Map.to_list()
    |> Enum.min_by(fn {_state, {score, _previous_states}} -> score end)
    |> then(fn {state, {score, _previous_states}} -> {state, score} end)
  end

  defp find_score(initial_state, end_position, map) do
    find_score(initial_state, 0, Map.new([{initial_state, []}]), Map.new(), end_position, map)
  end

  defp find_score(state, score, estimates, visited, end_position, map)

  defp find_score(
         {position, _direction} = _state,
         score,
         estimates,
         visited,
         end_position,
         _map
       )
       when position == end_position do
    estimates
    |> Map.to_list()
    |> Enum.filter(fn {{estimate_position, _estimate_direction} = _estimate_state,
                       {estimate_score, _previous_states}} ->
      estimate_position == end_position && estimate_score == score
    end)
    |> Enum.reduce(
      visited,
      fn {estimate_state, estimate_state_estimate}, acc ->
        Map.put(acc, estimate_state, estimate_state_estimate)
      end
    )
    |> then(&{score, &1})
  end

  defp find_score(state, score, estimates, visited, end_position, map) do
    {new_estimates, new_visited} = update_computations(state, score, estimates, visited, map)
    {new_state, new_score} = next_state(new_estimates)
    find_score(new_state, new_score, new_estimates, new_visited, end_position, map)
  end

  defp valid?(state, map) do
    {position, _} = state

    case Map.get(map, position) do
      :road -> true
      _ -> false
    end
  end

  defp next(states)
  defp next({{x, y}, :up}), do: {{x - 1, y}, :up}
  defp next({{x, y}, :down}), do: {{x + 1, y}, :down}
  defp next({{x, y}, :left}), do: {{x, y - 1}, :left}
  defp next({{x, y}, :right}), do: {{x, y + 1}, :right}

  defp rotate(state, direction)
  defp rotate({position, :up}, :counterclockwise), do: {position, :left}
  defp rotate({position, :left}, :counterclockwise), do: {position, :down}
  defp rotate({position, :down}, :counterclockwise), do: {position, :right}
  defp rotate({position, :right}, :counterclockwise), do: {position, :up}
  defp rotate({position, :up}, :clockwise), do: {position, :right}
  defp rotate({position, :right}, :clockwise), do: {position, :down}
  defp rotate({position, :down}, :clockwise), do: {position, :left}
  defp rotate({position, :left}, :clockwise), do: {position, :up}
  defp rotate({position, :up}, :inverse), do: {position, :down}
  defp rotate({position, :right}, :inverse), do: {position, :left}
  defp rotate({position, :down}, :inverse), do: {position, :up}
  defp rotate({position, :left}, :inverse), do: {position, :right}

  defp parse_input(text) do
    map = parse_map(text)

    start_position =
      map
      |> Map.to_list()
      |> Enum.find(&(elem(&1, 1) == :start))
      |> elem(0)

    end_position =
      map
      |> Map.to_list()
      |> Enum.find(&(elem(&1, 1) == :end))
      |> elem(0)

    new_map =
      map
      |> Map.put(start_position, :road)
      |> Map.put(end_position, :road)

    {start_position, end_position, new_map}
  end

  defp parse_map(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, row} ->
      line
      |> String.trim()
      |> String.codepoints()
      |> Stream.with_index()
      |> Enum.map(fn {val, column} ->
        {{row, column}, parse_object(val)}
      end)
    end)
    |> Map.new()
  end

  defp parse_object(str)
  defp parse_object("#"), do: :wall
  defp parse_object("S"), do: :start
  defp parse_object("E"), do: :end
  defp parse_object("."), do: :road
  defp parse_object(_), do: nil
end
