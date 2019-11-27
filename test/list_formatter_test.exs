defmodule ListFormatterTest do
  use ExUnit.Case
  doctest ListFormatter

  @book %{
    authors: ["Karl", "Toms"],
    title: "Karls adventure",
    publisher: "Penguin"
  }

  @book_from_google %{volumeInfo: @book}

  describe "template_string/2" do
    test "creates a string with relevant information to the book map passed to it" do
      template = ListFormatter.template_string(@book, 1)

      assert String.contains?(template, [
               "1",
               @book[:title],
               @book[:publisher]
             ])
    end

    test "applies defaults for when key book details are missing" do
      template = ListFormatter.template_string(%{}, 1)

      assert String.contains?(template, ["Author(s): N/A", "Title: N/A"])
    end
  end

  describe "print/1" do
    test "prints out information for a book from google passed to it" do
      ListFormatter.print([@book_from_google], FakeIO)
      string = ListFormatter.template_string(@book, 1)
      assert_received({:printing, ^string})
    end

    test "prints out information for a book passed to it" do
      ListFormatter.print([@book], FakeIO)
      string = ListFormatter.template_string(@book, 1)
      assert_received({:printing, ^string})
    end
  end
end
