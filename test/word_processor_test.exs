defmodule WordProcessorTest do
  use ExUnit.Case

  describe "functionality tests" do
    setup do
      {:ok, pid} = WordProcessor.start_link("test,comma,separated,words")
      {:ok, %{pid: pid}}
    end

    test "get_state" do
      assert ["test", "comma", "separated", "words"] == WordProcessor.state()
    end

    test "insert" do
      :ok = WordProcessor.insert("new word", 2)
      assert ["test", "comma", "new word", "separated", "words"] == WordProcessor.state()
    end

    test "delete" do
      :ok = WordProcessor.delete(0, 2)
      assert ["words"] == WordProcessor.state()
    end

    test "replace" do
      :ok = WordProcessor.replace("mm", "xx")
      assert ["test", "coxxa", "separated", "words"] == WordProcessor.state()
    end

    test "search" do
      assert "comma" == WordProcessor.search("o")
    end

    test "stop", %{pid: pid} do
      assert Process.alive?(pid)
      :ok = WordProcessor.stop()
      refute Process.alive?(pid)
    end
  end
end
