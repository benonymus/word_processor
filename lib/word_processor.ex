defmodule WordProcessor do
  @moduledoc """
  WordProcessor Agent
  """
  use Agent

  @spec start_link(List.t()) :: {:ok, pid()} | {:error, {:already_started, pid()} | term()}
  def start_link(source_string) when is_binary(source_string) do
    Agent.start_link(fn -> String.split(source_string, ",", trim: true) end, name: __MODULE__)
  end

  @spec state() :: String.t() | nil
  def state, do: Agent.get(__MODULE__, & &1)

  @spec insert(String.t(), Integer.t()) :: :ok
  def insert(value, position) when is_binary(value) and is_integer(position) do
    Agent.update(__MODULE__, fn state -> List.insert_at(state, position, value) end)
  end

  @spec delete(Integer.t(), Integer.t()) :: :ok
  def delete(from, to) when is_integer(from) and is_integer(to) do
    Agent.update(__MODULE__, fn state ->
      state
      |> Stream.with_index()
      |> Stream.reject(fn {_value, index} -> from <= index and index <= to end)
      |> Enum.map(fn {value, _index} -> value end)
    end)
  end

  @spec delete(String.t(), String.t()) :: :ok
  def replace(pattern, substring) when is_binary(pattern) and is_binary(substring) do
    Agent.update(__MODULE__, fn state ->
      Enum.map(state, fn value ->
        String.replace(
          String.downcase(value),
          String.downcase(pattern),
          String.downcase(substring)
        )
      end)
    end)
  end

  @spec search(String.t()) :: String.t() | nil
  def search(substring) when is_binary(substring) do
    Agent.get(__MODULE__, fn state ->
      Enum.find(state, fn value ->
        String.contains?(String.downcase(value), String.downcase(substring))
      end)
    end)
  end
end
