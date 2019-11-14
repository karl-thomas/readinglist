defmodule Readinglist.MixProject do
  use Mix.Project

  def project do
    [
      app: :readinglist,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Readinglist.CLI],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [
        books_endpoint: "https://www.googleapis.com/books/v1/volumes/",
        json_file: "data/reading_list.json"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:bypass, "~> 1.0", only: :test}
    ]
  end
end
