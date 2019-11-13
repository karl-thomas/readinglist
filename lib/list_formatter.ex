defmodule ListFormatter do
  @defaults %{authors: ["N/A"], title: "N/A", publisher: "N/A"}

  @doc """
    When the data passed to print is a list, it attaches the index to the item via creating a tuple
  """
  def print(data) when is_list(data),
    do: Stream.with_index(data, 1) |> Enum.map(&print/1)

  @doc """
   Formats and prints the data passed to it
  """
  def print({%{volumeInfo: info}, index}), do: print({info, index})

  def print({info, index}) do
    IO.inspect(info[:authors], label: "authors")
    IO.inspect(info[:publisher], label: "publish")
    IO.inspect(index, label: "index")

    template_string(info, index)
    |> IO.puts()
  end

  @doc """
   Creates a string based on the book information passed to it
  """
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
