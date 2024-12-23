defmodule AdventOfCode.Day23 do
  def part1(args) do
    args
    |> parse()
    |> find_networks()
    |> Enum.count()
  end

  def part2(_args) do
  end

  defp find_networks(network_map) do
    initial_networks = network_map
      |> Map.to_list()
      |> Enum.filter(&(String.starts_with?(elem(&1,0), "t")))
      |> Enum.map(
        fn {computer, connected_computers} ->
          {MapSet.new([computer]), connected_computers}
        end
      )

    initial_networks
    |> grow_networks(network_map)
    |> grow_networks(network_map)
  end

  defp grow_networks(networks, network_map) do
    networks
    |> Enum.flat_map(&(grow_network(&1,network_map)))
    |> Enum.uniq()
  end

  defp grow_network(network, network_map)
  defp grow_network({current_network, connected_computers}, network_map) do
    connected_computers
    |> Enum.to_list()
    |> Enum.map(
      fn connected_computer ->
        new_network = MapSet.put(current_network, connected_computer)
        connected_computer_connections = Map.get(network_map, connected_computer)
        new_connected_computers = MapSet.intersection(connected_computers, connected_computer_connections)
        {new_network, new_connected_computers}
      end
    )
  end




  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.flat_map(
      fn line ->
        [computer1, computer2] = String.split(line, "-")
        [{computer1, computer2}, {computer2, computer1}]
      end
    )
    |> Enum.reduce(
      Map.new(),
      fn {computer1, computer2}, acc ->
        Map.update(acc, computer1, MapSet.new([computer2]), &(MapSet.put(&1,computer2)))
      end
    )
  end
end
