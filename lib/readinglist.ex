defmodule Readinglist do
  @moduledoc """
    Helper functions to interact with the json file storing the users saved reading list.
  """

  # calls add/1 with the contents of volumeInfo for use with googl books api
  def add(%{volumeInfo: info}), do: add(info)

  @doc """
    Adds a book to the items array of a json file
  """
  def add(item) do
    items =
      get_items()
      |> Enum.concat([
        %{
          authors: item[:authors] || "N/A",
          title: item[:title] || "N/A",
          publisher: item[:publisher] || "N/A"
        }
      ])

    File.write(json_file(), Poison.encode!(%{items: items}))
  end

  @doc """
    Read items from the array "items" in the json file saving the reading list
  """
  def get_items do
    with {:ok, body} <- File.read(json_file()),
         {:ok, json} <- Poison.decode(body, keys: :atoms),
         do: Map.get(json, :items, [])
  end

  # retrieves the name of the json file saved in mix.exs
  defp json_file, do: Application.get_env(:readinglist, :json_file)
end
