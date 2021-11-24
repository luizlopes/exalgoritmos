defmodule Dijkstra.FindShortestPath do
  @moduledoc """
  Algorithm for finding the shortest paths between nodes in a graph
  """

  alias Dijkstra.Context

  def example_graph do
    %{
      "inicio" => %{"a" => 15, "b" => 2},
      "a" => %{"fim" => 1},
      "b" => %{"a" => 11, "c" => 5},
      "c" => %{"a" => 3, "fim" => 5},
      "fim" => %{}
    }
  end

  @doc """
  Finds the shortest path between nodes in a graph

  ## Parameters

    - starting_node: string that represents the starting node
    - target_node: string that represent the target node
    - graph: a map that represents the graph

  ## Examples

      iex> graph = Dijkstra.FindShortestPath.example_graph
      iex> Dijkstra.FindShortestPath("inicio", "fim", graph)
      {["inicio", "b", "c", "a", "fim"], 11}
  """
  def call(starting_node, target_node, graph) do
    context = Context.create(graph, starting_node, target_node)

    find_shortest_path({graph, context})
  end

  defp find_shortest_path({graph, context}) do
    case find_lowest_cost_node({graph, context}) do
      {:no_more_nodes, graph, context} ->
        {graph, context} |> update_performeds() |> Context.show_path()

      {:hasnt_neighbors, graph, context} ->
        {graph, context} |> update_performeds() |> find_shortest_path()

      {:has_neighbors, graph, context} ->
        {graph, context}
        |> update_costs()
        |> update_paths()
        |> update_performeds()
        |> find_shortest_path()
    end
  end

  defp find_lowest_cost_node(
         {graph,
          %{
            current_node: {node_name, _},
            performeds: performeds
          } = context}
       ) do
    neighbors = graph[node_name]

    case Enum.empty?(neighbors) do
      true ->
        {node_name, _node_cost} =
          lowest_cost_node =
          neighbors
          |> Map.drop(performeds)
          |> Enum.min_by(fn {_, node_cost} -> node_cost end)

        {current_node_has_neighbors({graph, node_name}), graph,
         Context.update_current_node(context, lowest_cost_node)}

      false ->
        {:no_more_nodes, graph, context}
    end
  end

  defp current_node_has_neighbors({graph, node_name}) do
    case is_map(graph[node_name]) do
      true -> :has_neighbors
      false -> :hasnt_neighbors
    end
  end

  defp update_costs({graph, %{current_node: {node_name, node_cost}, costs: costs} = context}) do
    new_costs =
      graph[node_name]
      |> Enum.filter(fn {name, value} -> costs[name] > node_cost + value end)
      |> Enum.reduce(%{}, fn {name, value}, acc -> Map.put(acc, name, node_cost + value) end)

    # to remember: into filter when costs[name] is nil, it's greater than any value on right side

    {graph, Context.update_costs(context, new_costs), new_costs}
  end

  defp update_paths({graph, %{current_node: {previous_node_name, _}} = context, new_costs}) do
    new_paths =
      new_costs
      |> Enum.map(fn {name, _} -> %{name => previous_node_name} end)
      |> list_to_map

    {graph, Context.update_paths(context, new_paths)}
  end

  defp update_performeds({graph, context}) do
    {graph, Context.update_performeds(context)}
  end

  defp list_to_map(list) do
    list |> Enum.reduce(%{}, fn mapa, acc -> Map.merge(acc, mapa) end)
  end
end
