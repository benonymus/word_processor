defmodule WordProcessorTest do
  use ExUnit.Case
  doctest WordProcessor

  test "greets the world" do
    assert WordProcessor.hello() == :world
  end
end
