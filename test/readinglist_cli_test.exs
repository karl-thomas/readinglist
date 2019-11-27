defmodule ReadinglistCLITest do
  use ExUnit.Case
  doctest Readinglist.CLI

  @book %{
    authors: ["Karl", "Toms"],
    title: "Karls adventure",
    publisher: "Penguin"
  }

  @second_book %{
    authors: ["Karl"],
    title: "Karls 2nd adventure",
    publisher: "Penguins"
  }

  describe "get_item_selection/0" do
    test "asks you for input to select an item" do
      execute = fn ->
        Readinglist.CLI.get_item_selection(5)
      end

      assert capture_io("1", execute) =~ "What is your choice?"
    end

    test "outputs an error if input number is above 5" do
      execute = fn ->
        assert :error == Readinglist.CLI.get_item_selection(5)
      end

      capture_io([input: "40\n"], execute)
    end

    test "outputs an error if input does not contain a number" do
      execute = fn ->
        assert :error == Readinglist.CLI.get_item_selection(5)
      end

      capture_io([input: "no numbers here\n"], execute)
    end

    test "on valid input, returns the number the user inputs minus 1" do
      execute = fn ->
        assert 0 == Readinglist.CLI.get_item_selection(5)
      end

      capture_io([input: "1"], execute)
    end
  end

  describe "ensure_item_selected/0" do
    test "returns the output of get_item_selected/0 if valid" do
      execute = fn ->
        assert 0 == Readinglist.CLI.ensure_item_selected(5)
      end

      capture_io([input: "1"], execute)
    end
  end

  describe "select_item/1" do
    test "returns the item from the list the user wants" do
      list = [@book, @second_book]

      execute = fn ->
        assert @book == Readinglist.CLI.select_item({:ok, list})
      end

      capture_io("1", execute)
    end

    test "on recieving an error it out puts the error message" do
      message = "Problem!"

      execute = fn ->
        Readinglist.CLI.select_item({:error, message})
      end

      assert capture_io(execute) =~ message
    end
  end
end
