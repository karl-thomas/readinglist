defmodule Book do
  defstruct authors: "N/A", title: "N/A", publisher: "N/A"

  @type t(author, title, publisher) :: %__MODULE__{
          authors: author,
          title: title,
          publisher: publisher
        }

  @type t :: %__MODULE__{authors: list(String.t()), title: String.t(), publisher: String.t()}
end

defmodule GoogleBook do
  defstruct [:volumeInfo]

  @type t :: %__MODULE__{
          volumeInfo: Book.t()
        }
end
