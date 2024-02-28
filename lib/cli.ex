defmodule Cli do
  @moduledoc """
  Cli interface for WordProcessor
  """
  @actions ~w(get_state insert delete replace search)

  def start() do
    IO.puts("Hello there!")

    source_string =
      ExPrompt.string_required(
        "Please provide your document (ex.: Hey there, How are you doing?)!\s"
      )

    {:ok, _pid} = WordProcessor.start_link(source_string)

    correct? = ExPrompt.confirm("Was this your document: #{WordProcessor.state()}?")

    if correct? do
      choose_action()
    else
      WordProcessor.stop()
      IO.puts("\nPlease restart!")
    end
  end

  defp choose_action do
    "Choose an action to execute on your document!"
    |> ExPrompt.choose(@actions)
    |> validate_selection()
  end

  defp validate_selection(-1) do
    IO.puts("\nInvalid action!")
    choose_action()
  end

  defp validate_selection(index) do
    @actions
    |> Enum.at(index)
    |> execute_action
  end

  defp execute_action("get_state") do
    IO.puts("Here is your current document: #{WordProcessor.state()}")
    choose_action()
  end

  defp execute_action("insert") do
    value =
      ExPrompt.string_required("Please provide your new entry!\s")

    position =
      ExPrompt.string_required(
        "Please provide the position (0 based indexing!) for your new entry!\s"
      )

    WordProcessor.insert(value, String.to_integer(position))

    IO.puts("Success!")

    choose_action()
  end

  defp execute_action("delete") do
    from =
      ExPrompt.string_required(
        "Please provide the starting position (0 based indexing!) for deletion!\s"
      )

    to =
      ExPrompt.string_required(
        "Please provide the ending position (0 based indexing!) for deletion!\s"
      )

    WordProcessor.delete(String.to_integer(from), String.to_integer(to))

    IO.puts("Success!")

    choose_action()
  end

  defp execute_action("replace") do
    pattern =
      ExPrompt.string_required("Please provide the pattern you would like to replace!\s")

    substring =
      ExPrompt.string_required(
        "Please provide the substring you would like to replace the pattern with!\s"
      )

    WordProcessor.replace(pattern, substring)

    IO.puts("Success!")

    choose_action()
  end

  defp execute_action("search") do
    substring =
      ExPrompt.string_required("Please provide your search substring!\s")

    IO.puts("Here is your padded search result: #{WordProcessor.search(substring)}")

    choose_action()
  end
end
