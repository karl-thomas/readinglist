defmodule ReadinglistTest do
  use ExUnit.Case

  @book %{
    authors: ["Karl", "Toms"],
    title: "Karls adventure",
    publisher: "Penguin"
  }

  @default_content Poison.encode!(%{items: []})
  @custom_content Poison.encode!(%{items: [@book]})

  setup do
    dir_path = System.tmp_dir!()
    path = Path.join(dir_path, "readinglist_test.json")
    Application.put_env(:readinglist, :json_file, path)
    File.write(path, @default_content)

    {:ok, path: path}
  end

  describe "get_items/0" do
    test "retrieves any items stored in the supplied paths json file", %{path: path} do
      assert [] == Readinglist.get_items()
      File.write(path, @custom_content)
      assert [@book] == Readinglist.get_items()
    end

    test "works if the file does not exist when ran", %{path: path} do
      File.rm(path)
      assert [] == Readinglist.get_items()
    end
  end

  describe "add/1" do
    test "pushes an item into the items array of a given json file", %{path: path} do
      Readinglist.add(@book)
      assert [@book] == Readinglist.get_items()
    end
  end

  describe "ensure_file_exists/1" do
    test "creates a json file at the given path if it does not exist", %{path: path} do
      File.rm(path)
      Readinglist.ensure_file_exists(path)
      assert {:ok, @default_content} == File.read(path)
    end

    test "returns the contents of a file at the path if file exists", %{path: path} do
      File.write(path, @custom_content)
      assert {:ok, @custom_content} == Readinglist.ensure_file_exists(path)
    end
  end
end
