defmodule ListFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
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
  end

  describe "print_string/1" do
    test "prints out information for a book from google passed to it" do
      execute = fn ->
        ListFormatter.print([@book_from_google])
      end

      assert capture_io(execute) =~ "Title: #{@book[:title]}"
    end

    test "prints out information for a book passed to it" do
      execute = fn ->
        ListFormatter.print([@book])
      end

      assert capture_io(execute) =~ "Title: #{@book[:title]}"
    end
  end
end
