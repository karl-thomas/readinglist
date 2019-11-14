defmodule Readinglist.CLI do
  def main(args) do
    args |> parse |> execute_command
  end

  @commands %{
    "search" => "Uses Googles book api to find 5 books matching your search",
    "list" => "Displays your reading list created from saving books while searching"
  }

  @queries %{
    "intitle" => "Returns results where the text following this keyword is found in the title.",
    "inpublisher" =>
      "Returns results where the text following this keyword is found in the author.",
    "inauthor" =>
      "Returns results where the text following this keyword is listed in the category list of the volume.",
    "subject" =>
      "Returns results where the text following this keyword is listed in the category list of the volume.",
    "isbn" => "Returns results where the text following this keyword is the ISBN number.",
    "lccn" =>
      "Returns results where the text following this keyword is the Library of Congress Control Number.",
    "oclc" =>
      "Returns results where the text following this keyword is the Online Computer Library Center number."
  }

  @doc """
    Converts ARGV into more convenient data

    ## Examples with valid input
      iex> Readinglist.CLI.parse(["search", "--inauthor", "keyes"])
      {:search, [inauthor: "keyes"]}

      iex> Readinglist.CLI.parse(["list"])
      {:list}

    ## Examples with invalid input
      iex> Readinglist.CLI.parse(["search"])
      {:error, "Invalid input"}

      iex> Readinglist.CLI.parse(["notacommand"])
      {:error, "Invalid input"}
  """
  def parse(args) do
    options = [
      strict: [
        query: :string,
        intitle: :string,
        inpublisher: :string,
        inauthor: :string,
        subject: :string,
        isbn: :string,
        lccn: :string,
        oclc: :string
      ]
    ]

    case OptionParser.parse(args, options) do
      {search_terms, [command], _}
      when command == "search" and length(search_terms) > 0 ->
        {:search, search_terms}

      {_, [command], _} when command == "list" ->
        {:list}

      {terms, [command], _} when command == "search" and length(terms) == 0 ->
        {:error, "Invalid input"}

      _ ->
        {:error, "Invalid input"}
    end
  end

  @doc """
    Run a command or handle an error based on the input
  """
  @spec execute_command({:list} | {:error, any} | {:search, [tuple()]}) :: :ok
  def execute_command(args) do
    case args do
      {:search, search_terms} -> preform_search(search_terms)
      {:list} -> IO.puts("implement list")
      {:error, _message} -> print_help_message()
    end
  end

  def preform_search(args) do
    args
    |> BooksService.get()
    |> handle_search()
  end

  def handle_search({:ok, items}) do
    ListFormatter.print(items)
    |> get_item_selection()
    |> select_item(items)
  end

  def handle_search({:error, message}), do: IO.puts(message)

  def get_item_selection(_), do: get_item_selection()

  def get_item_selection do
    IO.puts("\n  Type in an item number and press enter to save that item to your reading list")
    IO.puts("\n  Or just press enter to skip saving")

    IO.gets("\n  What is your choice?: ")
    |> String.trim()
    |> case do
      "" ->
        leave()

      string ->
        Integer.parse(string)
        |> case do
          {int, _} when int > 5 -> :error
          {int, _} -> int - 1
          :error -> :error
        end
    end
  end

  def select_item(:error, _) do
    IO.puts("\n  !!! Invalid Input !!!")
    get_item_selection()
  end

  def select_item(index, items) do
    Enum.fetch!(items, index)
  end

  defp print_help_message do
    IO.puts("\nThis program supports following commands:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description} \n") end)

    IO.puts("\nThe search command must have one of the following parameters")

    @queries
    |> Enum.map(fn {query, description} -> IO.puts("  #{query} - #{description} \n") end)

    IO.puts("\n Examples:")

    IO.puts("\n Searching: ")

    IO.puts("\n $ [command to run script] search --inauthor=keyes")
    IO.puts("\n $ [command to run script] search --inpublisher=penguin --intitle=flowers")

    IO.puts("\n Listing \n $ [command to run script] listing")
  end

  defp leave do
    IO.puts("Goodbye")
    System.halt()
  end
end
