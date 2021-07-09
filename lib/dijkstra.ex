defmodule Dijkstra do
  def cria_grafo do
    %{
      "inicio" => %{"a" => 6, "b" => 2},
      "a" => %{"fim" => 1},
      "b" => %{"a" => 3, "fim" => 5},
      "fim" => nil
    }
  end

  @doc """
  Busca o menor custo

  ## Parameters

    - inicio: string que representa o vértice de partida
    - fim: string que representa o vértice de chegada
    - grafo: map formado pelos vértices como sendo as chaves e seus respectivos vizinhos com custo representados como mapas dentro de uma lista.

  ## Examples

      iex> grafo_ponderado = Dijkstra.cria_grafo
      iex> Dijkstra.menor_custo("inicio", "fim", grafo_ponderado)
      iex> {:ok, ["inicio", "b", "a", "fim"]
  """
  def menor_custo(inicio, fim, grafo) do
    grafo
    |> inicia_contexto(inicio, fim)
    |> busca_menor_custo
  end

  defp inicia_contexto(grafo, inicio, fim) do
    {
      grafo,
      %{
        inicio: inicio,
        fim: fim,
        nodo_atual: {inicio, 0},
        processados: [],
        custos: inicia_custos(grafo, inicio, fim),
        caminho: inicia_caminhos(grafo, inicio, fim)
      }
    }
  end

  defp inicia_custos(grafo, inicio, fim) do
    grafo[inicio] |> Map.put(fim, 9999)
  end

  defp inicia_caminhos(grafo, inicio, _) do
    grafo[inicio]
    |> Map.keys()
    |> Enum.map(fn k -> %{k => inicio} end)
    |> Enum.reduce(%{}, fn mapa, acc -> Map.merge(acc, mapa) end)
  end

  defp busca_menor_custo({grafo, contexto}) do
    nodo_menor_custo =
      {grafo, contexto}
      |> nodo_menor_custo()

    {_, %{nodo_atual: {nodo_chave, _}} = contexto} = nodo_menor_custo

    case grafo[nodo_chave] do
      nil -> monta_caminho(contexto, contexto[:fim])
      _ -> atualiza_contexto({grafo, contexto})
    end
  end

  defp monta_caminho(contexto, fim, resultado \\ [])

  defp monta_caminho(%{custos: custos, fim: fim}, nil, resultado) do
    {resultado, custos[fim]}
  end

  defp monta_caminho(%{caminho: caminho} = contexto, fim, resultado) do
    monta_caminho(contexto, caminho[fim], [fim | resultado])
  end

  defp atualiza_contexto({grafo, contexto}) do
    {grafo, contexto}
    |> encontra_custos_menores()
    |> atualiza_custos
    |> atualiza_caminho
    |> atualiza_processados
    |> busca_menor_custo
  end

  defp nodo_menor_custo(
         {grafo, %{nodo_atual: {nodo_chave, nodo_custo}, processados: processados} = contexto}
       ) do
    {nodo, custo} =
      grafo[nodo_chave]
      |> Map.drop(processados)
      |> Enum.min_by(fn {_, custo} -> custo end)

    {grafo, %{contexto | nodo_atual: {nodo, custo + nodo_custo}}}
  end

  defp encontra_custos_menores(
         {grafo, %{nodo_atual: {nodo_chave, nodo_valor}, custos: custos} = contexto}
       ) do
    custos_menores =
      grafo[nodo_chave]
      |> Enum.filter(fn {k, v} -> custos[k] > nodo_valor + v end)
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, nodo_valor + v) end)

    {grafo, contexto, custos_menores}
  end

  defp atualiza_custos({grafo, %{custos: custos} = contexto, custos_menores}) do
    {grafo, %{contexto | custos: Map.merge(custos, custos_menores)}, custos_menores}
  end

  defp atualiza_caminho(
         {grafo, %{caminho: caminho, nodo_atual: {nodo_chave, _}} = contexto, custos_menores}
       ) do
    novos_caminhos =
      custos_menores
      |> Enum.map(fn {k, _} -> %{k => nodo_chave} end)
      |> Enum.reduce(%{}, fn mapa, acc -> Map.merge(acc, mapa) end)

    {grafo, %{contexto | caminho: Map.merge(caminho, novos_caminhos)}, custos_menores}
  end

  defp atualiza_processados(
         {grafo, %{processados: processados, nodo_atual: {nodo_atual, _}} = contexto, _}
       ) do
    {grafo, %{contexto | processados: [nodo_atual | processados]}}
  end
end
