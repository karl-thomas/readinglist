defmodule ReadinglistCLITest do
  use ExUnit.Case
  doctest Readinglist.CLI
  import ExUnit.CaptureIO

  describe "select_item/1" do
    test "with valid input, it uses the index to pull an item out of the list" do
      assert "second" == Readinglist.CLI.select_item(1, ["first", "second"])
    end

    test "on recieving an error, it outputs an error message" do
      execute = fn ->
        Readinglist.CLI.select_item(:error, [])
      end

      assert capture_io([input: "1"], execute) =~ "Invalid Input"
    end

    test "on recieving an error, it outputs asks for input again" do
      execute = fn ->
        Readinglist.CLI.select_item(:error, [])
      end

      assert capture_io([input: "1"], execute) =~ "What is your choice?"
    end
  end

  describe "get_item_selection/0" do
    test "asks you for input to select an item" do
      execute = fn ->
        Readinglist.CLI.get_item_selection()
      end

      assert capture_io("1", execute) =~ "What is your choice?"
    end

    test "outputs an error if input number is above 5" do
      execute = fn ->
        assert :error == Readinglist.CLI.get_item_selection()
      end

      capture_io([input: "40\n"], execute)
    end

    test "outputs an error to the console if input does not contain a number" do
      execute = fn ->
        assert :error == Readinglist.CLI.get_item_selection()
      end

      capture_io([input: "no numbers here\n"], execute)
    end

    test "on valid input, returns the number minus 1" do
      execute = fn ->
        assert 0 == Readinglist.CLI.get_item_selection()
      end

      capture_io([input: "1"], execute)
    end
  end

  describe "handle_search/1" do
    test "on recieving an error it out puts the error message" do
      message = "Problem!"

      execute = fn ->
        Readinglist.CLI.handle_search({:error, message})
      end

      assert capture_io(execute) =~ message
    end
  end
end
