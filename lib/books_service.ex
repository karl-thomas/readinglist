defmodule BooksService do
  def get(args) do
    _url = endpoint() <> create_query_string(args) <> get_query_params()
  end

  @doc """
    Returns the endpoint for the books service saved in the application env

    ## Example
    iex> BooksService.endpoint()
    "https://www.googleapis.com/books/v1"
  """
  @spec endpoint :: String.t()

  @doc """
    Turns the Keyword list into a query parameter that google books api understands

    ## Examples
    iex> BooksService.create_query_string([inauthor: "keyes", query: "flowers"])
    "q=flowers+inauthor:keyes"

    iex> BooksService.create_query_string([inauthor: "keyes", intitle: "hello", query: "flowers"])
    "q=flowers+inauthor:keyes+intitle:hello"

    iex> BooksService.create_query_string([inauthor: "keyes"])
    "q=+inauthor:keyes"
  """
  @spec create_query_string([tuple()]) :: {[any], any}
  def create_query_string(map) do
    query = map[:query]

    Keyword.delete(map, :query)
    |> Enum.reduce("q=#{query}", &accumulate_books_options/2)
  end

  @doc """
    Reads the books_endpoint from from the application env
  """
  def endpoint, do: Application.get_env(:readinglist, :books_endpoint)

  defp accumulate_books_options({key, value}, acc), do: "#{acc}+#{key}:#{value}"

  defp get_query_params,
    do: "&maxResults=5&projection=lite&key=" <> System.get_env("GOOGLE_API_KEY")
end
