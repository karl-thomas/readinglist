defmodule GoogleBooksTest do
  use ExUnit.Case
  doctest GoogleBooks

  setup do
    Application.put_env(:readinglist, :books_endpoint, "https://www.googleapis.com/books/v1")
  end

  test "endpoint returns google books api saved in application env" do
    assert GoogleBooks.endpoint() == "https://www.googleapis.com/books/v1"
  end
end
