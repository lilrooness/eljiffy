defmodule Eljiffy.MixProject do
  use Mix.Project

  def project do
    [
      app: :eljiffy,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:jiffy, github: "davisp/jiffy", tag: "0.15.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README", "LICENSE*"],
      maintainers: ["lilrooness"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/lilrooness/eljiffy"}
    ]
  end
end
