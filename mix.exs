defmodule Favro.MixProject do
  use Mix.Project

  def project do
    [
      app: :favro,
      version: "0.2.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison,  "~> 1.6.2"},
      {:jason,      "~> 1.1"}
    ]
  end

  def description do
    "Favro API Client Library"
  end

  def package do
    [
      name: "favro",
      maintainers: ["Warren Kenny"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/wrren/favro.ex"}
    ]
  end
end
