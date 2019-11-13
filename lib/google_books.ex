defmodule GoogleBooks do
  use HTTPoison.Base

  def process_url(url) do
    endpoint() <> url
  end

  @doc """
    converts the body of the response into maps, with atoms for keys

    ## Examples
    iex> GoogleBooks.process_response_body("{\\"items\\":[{\\"title\\":\\"Karl\\"}]}")
    %{items: [%{title: "Karl"}]}
  """
  def process_response_body(body) do
    body
    |> Poison.decode!(keys: :atoms)
  end

  @doc """
    Reads the books_endpoint from from the application env
  """
  def endpoint, do: Application.get_env(:readinglist, :books_endpoint)
end
