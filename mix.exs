defmodule Eljiffy.MixProject do
  use Mix.Project

  def project do
    [
      app: :eljiffy,
      description: "An Elixir wrapper around the erlang json nifs library, Jiffy (github.com/davisp/jiffy)",
      version: "1.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:jiffy, "~> 0.15.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["lilrooness"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/lilrooness/eljiffy"}
    ]
  end
end
