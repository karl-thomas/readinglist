defmodule ListFormatter do
  @defaults %{authors: ["N/A"], title: "N/A", publisher: "N/A"}

  # setting defaults in header style function
  @spec print(list(Book.t()) | {Book.t(), integer} | {GoogleBook.t(), integer}, any) :: any
  def print(data, io \\ IO)

  @doc """
    When the data passed to print is a list, it attaches the index to the item via creating a tuple
  """
  def print(data, io) when is_list(data),
    do: Stream.with_index(data, 1) |> Enum.map(&print(&1, io))

  @doc """
   Formats and prints the data passed to it
  """
  def print({%{volumeInfo: info}, index}, io), do: print({info, index}, io)

  def print({info, index}, io) do
    template_string(info, index)
    |> io.puts()
  end

  @doc """
   Creates a string based on the book information passed to it
  """
  @spec template_string(Book.t(), integer) :: String.t()
  def template_string(map, index) do
    %{authors: authors, title: title, publisher: publisher} = merge_defaults(map)
    authors = Enum.join(authors, ", ")

    "\n- Item number: #{index} \n" <>
      "  Title: #{title}\n" <>
      "  Author(s): #{authors}\n" <>
      "  Publisher: #{publisher}\n"
  end

  defp merge_defaults(map) do
    Map.merge(@defaults, map)
  end
end
