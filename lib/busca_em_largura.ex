defmodule BuscaEmLargura do
  @moduledoc """
  Algoritmo de busca em largura.

  A busca em largura consiste em encontrar um caminho de um ponto A um ponto B.
  Estrutura do algoritmo:
  * localizar o ponto de origem no grafo
  * adicionar os pontos vizinho da origem em uma fila para ser percorrida
  * percorrer a fila com os pontos vizinhos
  * caso o ponto vizinho seja o ponto procurado, sucesso e fim do algoritmo
  * caso o ponto vizinho não seja o ponto procurado, deve-se colocar os pontos vizinho do vizinho no final da fila e continuar a busca a partir do proximo ponto da fila

  """

  @doc """
  Cria o seguinte grafo para facilitar os testes de busca

  ## Examples

      iex> BuscaEmLargura.cria_grafo()
      %{
        "anji" => [],
        "bob" => ["peggy", "anji"],
        "peggy" => [],
        "benicinho" => ["alice", "bob", "claire"],
        "alice" => ["peggy"],
        "claire" => ["joonny", "thom"],
        "jonny" => [],
        "thom" => []
      }
  """
  def cria_grafo do
    %{
      "anji" => [],
      "bob" => ["peggy", "anji"],
      "peggy" => [],
      "benicinho" => ["alice", "bob", "claire"],
      "alice" => ["peggy"],
      "claire" => ["joonny", "thom"],
      "jonny" => [],
      "thom" => []
    }
  end

  @doc """
  Executa a busca em largura dado o grafo, a origem e o destino.
  Caso o destino seja encontrado, retorna :ok e uma lista dos pontos visitados.
  Caso o destino não seja encontrado, retorna :nok e uma lista vazia.

  ## Parameters

    - grafo: map formado pelos vértices como sendo as chaves e seus respectivos vizinhos como sendo os valores do map.
    - origem: string que representa um vértice
    - destino: string que representa um vértice

  ## Examples

      iex> grafo = BuscaEmLargura.cria_grafo
      iex> BuscaEmLargura.executa(grafo, "bob", "anji")
      {:ok, ["peggy", "anji"]}

      iex> grafo = BuscaEmLargura.cria_grafo
      iex> BuscaEmLargura.executa(grafo, "benicinho", "peggy")
      {:ok, ["alice", "bob", "claire", "peggy"]}

      iex> grafo = BuscaEmLargura.cria_grafo
      iex> BuscaEmLargura.executa(grafo, "peggy", "anji")
      {:nok, []}
  """
  def executa(grafo, origem, destino) do
    params = %{
      grafo: grafo,
      fila_de_pesquisa: grafo[origem],
      item_procurado: destino,
      itens_verificados: [],
      item_atual_verificado: false
    }

    busca_na_fila(params)
  end

  defp busca_na_fila(%{fila_de_pesquisa: []}), do: {:nok, []}
  defp busca_na_fila(%{fila_de_pesquisa: [_ | nil]}), do: {:nok, []}

  defp busca_na_fila(%{
         fila_de_pesquisa: [atual | _proximos],
         item_procurado: item_procurado,
         item_atual_verificado: false
       })
       when atual == item_procurado do
    {:ok, [atual]}
  end

  defp busca_na_fila(
         %{
           fila_de_pesquisa: [_atual | proximos],
           item_atual_verificado: true
         } = params
       ) do
    params
    |> Map.replace(:fila_de_pesquisa, proximos)
    |> Map.replace(:item_atual_verificado, false)
    |> busca_na_fila()
  end

  defp busca_na_fila(%{
         grafo: grafo,
         fila_de_pesquisa: [atual | proximos],
         item_procurado: item_procurado,
         itens_verificados: itens_verificados,
         item_atual_verificado: false
       }) do
    case busca_na_fila(%{
           grafo: grafo,
           fila_de_pesquisa: proximos ++ grafo[atual],
           item_procurado: item_procurado,
           itens_verificados: itens_verificados ++ [atual],
           item_atual_verificado:
             Enum.member?(itens_verificados ++ [atual], hd(proximos ++ grafo[atual]))
         }) do
      {:ok, tentativas} -> {:ok, [atual | tentativas]}
      nok -> nok
    end
  end
end
