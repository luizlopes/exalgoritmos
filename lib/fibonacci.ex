defmodule Fibonacci do
  @moduledoc """
  O algoritmo calcula a sequencia de Fibonacci onde cada termo subsequente corresponde à soma dos dois termos anteriores.
  """

  def calc(0), do: %{:val => 0, :list => [0]}
  def calc(1), do: %{:val => 1, :list => [1, 0]}

  @doc """
  Calcula a sequencia para o número passado.

  ## Parameters

    - n: numero para o qual a sequência deve ser calculada

  ## Examples

    iex> Fibonacci.calc(0)
    %{list: [0], val: 0}

    iex> Fibonacci.calc(1)
    %{list: [1, 0], val: 1}

    iex> Fibonacci.calc(10)
    %{list: [55, 34, 21, 13, 8, 5, 3, 2, 1, 1, 0], val: 55}
  """
  def calc(n) do
    f1 = calc(n - 1)
    f2 = calc(n - 2)
    val = f1.val + f2.val
    %{:val => val, :list => [val | f1.list]}
  end
end
