defmodule BooksServiceTest do
  use ExUnit.Case
  doctest BooksService

  @item %{"title" => "Karl"}
  @item_atom_key %{title: "Karl"}
  @get_response %{"items" => [@item], "totalItems" => 1}
  @get_response_json Poison.encode!(@get_response)
  @no_items Poison.encode!(%{"totalItems" => 0})

  setup do
    bypass = Bypass.open()
    Application.put_env(:readinglist, :books_endpoint, "http://localhost:#{bypass.port}/")

    {:ok, bypass: bypass}
  end

  describe "get/1" do
    test "parses the query parameters properly and sends them with the request", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "GET" == conn.method
        assert "q=+inauthor:keyes&maxResults=5&projection=lite" == conn.query_string
        Plug.Conn.resp(conn, 200, @get_response_json)
      end)

      BooksService.get(inauthor: "keyes")
    end

    test "on a successful request it only returns elements from the items property", %{
      bypass: bypass
    } do
      Bypass.expect(bypass, &Plug.Conn.resp(&1, 200, @get_response_json))

      assert {:ok, [@item_atom_key]} = BooksService.get(inauthor: "keyes")
    end

    test "when api returns a 404, returns a message", %{bypass: bypass} do
      Bypass.expect(bypass, &Plug.Conn.resp(&1, 404, @no_items))
      assert {:error, "No items found matching your search"} = BooksService.get(inauthor: "keyes")
    end

    test "when api finds no items, returns a message", %{bypass: bypass} do
      Bypass.expect(bypass, &Plug.Conn.resp(&1, 200, @no_items))
      assert {:error, "No items found matching your search"} = BooksService.get(inauthor: "keyes")
    end
  end
end
