defmodule Readinglist do
  @moduledoc """
    Helper functions to interact with the json file storing the users saved reading list.
  """

  @default_content Poison.encode!(%{items: []})

  # calls add/1 with the contents of volumeInfo for use with googl books api
  @spec add(Book.t() | GoogleBook.t()) :: :ok | {:error, atom}
  def add(%{volumeInfo: info}), do: add(info)

  @doc """
    Adds a book to the items array of a json file
  """
  def add(item) do
    new_list =
      get_items()
      |> Enum.concat([
        %Book{
          authors: item.authors || "N/A",
          title: item.title || "N/A",
          publisher: item.publisher || "N/A"
        }
      ])

    File.write(json_file(), Poison.encode!(%{items: new_list}))
  end

  @doc """
    Read items from the array "items" in the json file saving the reading list
  """
  def get_items do
    with {:ok, body} <- ensure_file_exists(json_file()),
         {:ok, json} <- Poison.decode(body, keys: :atoms),
         do: Map.get(json, :items, [])
  end

  @doc """
    Make sure the file exists to write to
  """
  def ensure_file_exists(path) do
    File.read(path)
    |> case do
      {:error, :enoent} -> {File.write(json_file(), @default_content), @default_content}
      {:ok, content} -> {:ok, content}
    end
  end

  # retrieves the name of the json file saved in mix.exs
  defp json_file, do: Application.get_env(:readinglist, :json_file)
end
