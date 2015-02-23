defmodule Edgarex.Mixfile do
  use Mix.Project

  def project do
    [app: :edgarex,
     version: "0.0.1",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp package do
    [
      files: ["lib", "README.md", "config", "LICENSE", "mix.exs"],
      contributors: ["Chris Duranti"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/rozap/edgarex"
      }
    ]
  end

  defp description do
    """
      A set of utilities for fetching documents from the SEC EDGAR data portal, as 
      well as parsing them into simpler structures.
    """
  end


  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [ 
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"},
      {:httpotion, "~> 2.0.0"},
      {:exquery, "~> 0.0.6"}
    ]
  end
end
