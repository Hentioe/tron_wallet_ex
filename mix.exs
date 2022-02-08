defmodule Tron.MixProject do
  use Mix.Project

  def project do
    [
      app: :tron,
      version: "0.1.0",
      elixir: "~> 1.13",
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
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:exbase58, "~> 1.0"},
      {:ex_sha3, "~> 0.1.1"},
      {:libsecp256k1, "~> 0.1.10"}
    ]
  end
end
