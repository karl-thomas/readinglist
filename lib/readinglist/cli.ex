defmodule Readinglist.CLI do
  def main(args) do
    args |> parse |> execute_command
  end

  @commands %{
    "search" => "Uses Googles book api to find 5 books matching your search",
    "list" => "Displays your reading list created from saving books while searching"
  }

  @queries %{
    "query" => "A search term that can be anything",
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
      {:search, search_terms} ->
        search_terms
        |> BooksService.get()
        |> select_item()
        |> Readinglist.add()

      {:list} ->
        Readinglist.get_items() |> ListFormatter.print()

      {:error, _message} ->
        print_help_message()
    end
  end

  @doc """
    Prints the list, asks the user if they'd like to save a book, and returns the book they want to save
  """
  @spec select_item({:error, String.t()}, any) :: :ok
  @spec select_item({:ok, list(Book.t())}, any) :: Book.t()
  def select_item(input, io \\ IO)

  def select_item({:ok, items}, io) do
    ListFormatter.print(items, io)

    length(items)
    |> ensure_item_selected(io)
    |> (&Enum.fetch!(items, &1)).()
  end

  def select_item({:error, message}, io), do: io.puts(message)

  @doc """
    Keeps asking the user for input until the input is valid
  """
  @spec ensure_item_selected(integer, any) :: integer
  def ensure_item_selected(length, io \\ IO) do
    output = get_item_selection(length, io)

    if output == :error do
      io.puts("\n !!! Invalid Input!!!\n")
      ensure_item_selected(length)
    else
      output
    end
  end

  @doc """
    Asks the user for input and validates that input against an integer passed to it
  """
  @spec get_item_selection(integer, any) :: integer | :error
  def get_item_selection(length, io \\ IO) do
    io.puts("\n  Type in an item number and press enter to save that item to your reading list")
    io.puts("\n  Or just press enter to skip saving")

    io.gets("\n  What is your choice?: ")
    |> validate_selection(length)
    |> case do
      :leave -> leave()
      other -> other
    end
  end

  @doc """
    Validates a string representing a count of items against the length of a list
    If input string is does not contain any characters or digits, return :leave
    if input string isgreater than the list length, or does not contain a number return :error
    if input string contains a valid number, return that number minus one representing the index

    ## Examples
      iex> Readinglist.CLI.validate_selection("2", 3)
      1

      iex> Readinglist.CLI.validate_selection("4", 5)
      3

      iex> Readinglist.CLI.validate_selection("", 5)
      :leave

      iex> Readinglist.CLI.validate_selection("\\n\\n\\n\\n", 5)
      :leave

      iex> Readinglist.CLI.validate_selection("4", 3)
      :error

      iex> Readinglist.CLI.validate_selection("0", 3)
      :error

      iex> Readinglist.CLI.validate_selection("nope, not a number in sight", 40)
      :error
  """
  @spec ensure_item_selected(String.t(), integer) :: integer
  def validate_selection(string, list_length) do
    string
    |> String.trim()
    |> case do
      "" ->
        :leave

      string ->
        Integer.parse(string)
        |> case do
          {int, _} when int <= 0 -> :error
          {int, _} when int > list_length -> :error
          {int, _} -> int - 1
          :error -> :error
        end
    end
  end

  defp print_help_message(io \\ IO) do
    io.puts("\n  This program supports following commands:\n")

    @commands
    |> Enum.map(fn {command, description} -> io.puts("  #{command} - #{description} \n") end)

    io.puts("\n  The search command must have one of the following parameters")

    @queries
    |> Enum.map(fn {query, description} -> io.puts("  #{query} - #{description} \n") end)

    io.puts("\n  Examples:")

    io.puts("\n  Searching: ")

    io.puts("\n    $ ./readinglist search --inauthor=keyes")
    io.puts("\n    $ ./readinglist search --inpublisher=penguin --intitle=flowers")

    io.pusts("\n Listing \n    $ ./readinglist list")
  end

  defp leave() do
    IO.puts("\n  Goodbye")
    System.halt()
  end
end
