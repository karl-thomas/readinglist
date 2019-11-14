defmodule ReadinglistTest do
  use ExUnit.Case

  @book %{
    authors: ["Karl", "Toms"],
    title: "Karls adventure",
    publisher: "Penguin"
  }

  setup do
    dir_path = System.tmp_dir!()
    path = Path.join(dir_path, "readinglist_test.json")
    Application.put_env(:readinglist, :json_file, path)
    File.write(path, Poison.encode!(%{items: []}))

    {:ok, path: path}
  end

  describe "get_items/1" do
    test "retrieves any items stored in the supplied paths json file", %{path: path} do
      assert [] == Readinglist.get_items()
      File.write(path, Poison.encode!(%{items: [@book]}))
      assert [@book] == Readinglist.get_items()
    end
  end

  describe "add/1" do
    test "pushes an item into the items array of a given json file", %{path: path} do
      Readinglist.add(@book)
      assert [@book] == Readinglist.get_items()
    end
  end
end
