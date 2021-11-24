defmodule Dijkstra.Context do
  @moduledoc """
  Module to handle the context of each dijkstra's algorithm step
  """

  @doc """
  Creates a map that represents the context

  ## Parameters

    - starting_node: string that represents the starting node
    - target_node: string that represent the target node
    - graph: a map that represents the graph
  """
  def create(graph, starting_node, target_node) do
    %{
      starting_node: starting_node,
      target_node: target_node,
      current_node: {starting_node, 0},
      performeds: [],
      costs: start_costs(graph, starting_node),
      paths: start_paths(graph, starting_node),
      has_neighbors?: is_map(graph[starting_node])
    }
  end

  defp start_costs(graph, starting_node) do
    graph[starting_node]
  end

  defp start_paths(graph, starting_node) do
    graph[starting_node]
    |> Map.keys()
    |> Enum.map(fn k -> %{k => starting_node} end)
    |> Enum.reduce(%{}, fn mapa, acc -> Map.merge(acc, mapa) end)
  end

  def update_current_node(
        %{current_node: {_, previous_node_cost}} = context,
        {node_name, node_cost}
      ) do
    Map.merge(context, %{
      current_node: {node_name, node_cost + previous_node_cost}
    })
  end

  def update_costs(%{costs: costs} = context, new_costs) do
    %{context | costs: Map.merge(costs, new_costs)}
  end

  def update_paths(%{paths: paths} = context, new_paths) do
    %{context | paths: Map.merge(paths, new_paths)}
  end

  def update_performeds(%{performeds: performeds, current_node: {node_name, _}} = context) do
    %{context | performeds: [node_name | performeds]}
  end

  def show_path({_, context}) do
    build_path(context[:paths], context[:target_node], [], context[:costs][context[:target_node]])
  end

  defp build_path(_, nil, result, cost) do
    {result, cost}
  end

  defp build_path(paths, node_name, result, cost) do
    build_path(paths, paths[node_name], [node_name | result], cost)
  end
end
