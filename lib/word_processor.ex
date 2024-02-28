defmodule WordProcessor do
  @moduledoc """
  WordProcessor Agent
  """
  use Agent

  @spec start_link(String.t()) :: {:ok, pid()} | {:error, {:already_started, pid()} | term()}
  def start_link(source_string) when is_binary(source_string) do
    Agent.start_link(fn -> source_string end, name: __MODULE__)
  end

  @spec state() :: String.t()
  def state, do: Agent.get(__MODULE__, & &1)

  @spec insert(String.t(), Integer.t()) :: :ok
  def insert(value, position) when is_binary(value) and is_integer(position) do
    Agent.update(__MODULE__, fn state ->
      {start, finish} = String.split_at(state, position)
      start <> value <> finish
    end)
  end

  @spec delete(Integer.t(), Integer.t()) :: :ok
  def delete(from, to) when is_integer(from) and is_integer(to) do
    Agent.update(__MODULE__, fn state ->
      String.slice(state, 0, from) <>
        String.slice(state, to + 1, String.length(state))
    end)
  end

  @spec delete(String.t(), String.t()) :: :ok
  def replace(pattern, substring) when is_binary(pattern) and is_binary(substring) do
    Agent.update(__MODULE__, fn state -> String.replace(state, pattern, substring) end)
  end

  @spec search(String.t()) :: String.t() | nil
  def search(substring) when is_binary(substring) do
    Agent.get(__MODULE__, fn state ->
      ~r/(?<match>#{substring})/
      |> Regex.named_captures(state, return: :index)
      |> case do
        %{"match" => {index, length}} ->
          start = if index < 5, do: 0, else: index - 5
          finish = index + length + 4
          String.slice(state, start..finish)

        nil ->
          "not found"
      end
    end)
  end

  @spec stop() :: :ok
  def stop, do: Agent.stop(__MODULE__)
end
