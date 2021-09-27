defmodule Gmail.Mixfile do
  use Mix.Project

  def project do
    [app: :gmail,
     version: "0.1.20",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test],
     description: "A simple Gmail REST API client for Elixir",
     package: package()]
  end

  def application do
    [extra_applications: [:logger],
      mod: {Gmail, []}]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:earmark, ">= 1.4.15"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:bypass, "~> 2.1", only: :test},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      maintainers: ["Craig Paterson"],
      links: %{"Github" => "https://github.com/craigp/elixir-gmail"}
    ]
  end
end
