defmodule BooksService do
  @doc """
    Uses command line arguments and the google books api wrapper to search for books
  """
  def get(args) do
    args
    |> create_url
    |> GoogleBooks.get()
    |> response
  end

  defp response({
         :ok,
         %HTTPoison.Response{status_code: 200, body: %{totalItems: total, items: items}}
       })
       when total > 0,
       do: {:ok, items}

  defp response({:ok, %HTTPoison.Response{status_code: 200, body: %{totalItems: total}}})
       when total == 0,
       do: {:error, "No items found matching your search"}

  defp response({:ok, %HTTPoison.Response{status_code: 404}}),
    do: {:error, "No items found matching your search"}

  defp response({_, _}),
    do: {:error, "Something went wrong with the request, please try again"}

  @doc """
    Takes in the Keyword list into a query parameter that google books api understands.
  """
  def create_url(args),
    do: "?#{create_query_string(args)}&maxResults=#{books_limit()}&projection=lite"

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
  def create_query_string(keywords) do
    query = keywords[:query]

    Keyword.delete(keywords, :query)
    |> Enum.reduce("q=#{query}", &accumulate_books_options/2)
  end

  # helper for reducing the query string
  defp accumulate_books_options({key, value}, acc), do: "#{acc}+#{key}:#{value}"

  # get the books limit from app config
  defp books_limit, do: Application.get_env(:readinglist, :books_limit)
end
