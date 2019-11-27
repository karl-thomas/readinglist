defmodule ReadinglistCLITest do
  use ExUnit.Case
  doctest Readinglist.CLI

  @books_limit 10
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

  def set_limit(limit) do
    Application.put_env(:readinglist, :books_limit, limit)
  end

  setup do
    set_limit(@books_limit)
  end

  describe "get_item_selection/2" do
    test "asks you for input to select an item" do
      start_supervised(FakeIO)
      FakeIO.set_response("1")

      Readinglist.CLI.get_item_selection(5, FakeIO)
      assert_received {:printing, "\n  What is your choice?: "}
      assert FakeIO.gets_call_count() === 1
    end

    test "outputs an error if input number is above the apps book limit" do
      start_supervised(FakeIO)
      FakeIO.set_response("20")

      assert :error == Readinglist.CLI.get_item_selection(5, FakeIO)
    end

    test "outputs an error if input does not contain a number" do
      start_supervised(FakeIO)
      FakeIO.set_response("no numbers here")

      assert :error == Readinglist.CLI.get_item_selection(5, FakeIO)
    end

    test "outputs an error if input is greater than the length passed to the function" do
      start_supervised(FakeIO)
      FakeIO.set_response("7")

      assert :error == Readinglist.CLI.get_item_selection(5, FakeIO)
    end

    test "on valid input, returns the number the user inputs minus 1" do
      start_supervised(FakeIO)
      FakeIO.set_response("2")

      assert 1 == Readinglist.CLI.get_item_selection(5, FakeIO)
    end
  end

  describe "ensure_item_selected/0" do
    test "returns the output of get_item_selected/0 if valid" do
      start_supervised(FakeIO)
      FakeIO.set_response("1")
      assert 0 == Readinglist.CLI.ensure_item_selected(5, FakeIO)
    end
  end

  describe "select_item/1" do
    test "returns the item from the list the user wants" do
      start_supervised(FakeIO)
      FakeIO.set_response("1")

      list = [@book, @second_book]

      assert @book == Readinglist.CLI.select_item({:ok, list}, FakeIO)
    end

    test "on recieving an error it IO.puts/1 the error message" do
      message = "Problem!"

      Readinglist.CLI.select_item({:error, message}, FakeIO)
      assert_received({:printing, message})
    end
  end
end
