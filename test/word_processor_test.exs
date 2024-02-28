defmodule WordProcessorTest do
  use ExUnit.Case

  describe "functionality tests" do
    setup do
      {:ok, pid} = WordProcessor.start_link("Hey there, How are you doing?")
      {:ok, %{pid: pid}}
    end

    test "get_state" do
      assert "Hey there, How are you doing?" == WordProcessor.state()
    end

    test "insert" do
      :ok = WordProcessor.insert(" John", 9)
      assert "Hey there John, How are you doing?" == WordProcessor.state()
    end

    test "delete" do
      :ok = WordProcessor.delete(0, 3)
      assert "there, How are you doing?" == WordProcessor.state()
    end

    test "replace" do
      :ok = WordProcessor.replace("there", "John")
      assert "Hey John, How are you doing?" == WordProcessor.state()
    end

    test "search" do
      assert "Hey there, How" == WordProcessor.search("there")
    end

    test "stop", %{pid: pid} do
      assert Process.alive?(pid)
      :ok = WordProcessor.stop()
      refute Process.alive?(pid)
    end
  end
end
