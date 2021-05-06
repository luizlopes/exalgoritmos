defmodule Fatorial do
  @moduledoc """
  Algoritmo de cálculo de fatorial

  O cálculo de fatorial consiste em multiplicar um numero dado pelo seu antecessor de maneira recursiva.
  A implementação é uma simples recursão da multiplicação de n por n-1, onde o caso base é n igual a 1 que retorna 1.
  """

  def calcula(0), do: 1
  def calcula(1), do: 1

  @doc """
  Calcula o número fatorial de n

  ## Parameters

    - n: número inteiro

  ## Examples
  iex> Fatorial.calcula(0)
  1

  iex> Fatorial.calcula(1)
  1

  iex> Fatorial.calcula(5)
  120

  """
  def calcula(n), do: n * calcula(n - 1)
end
