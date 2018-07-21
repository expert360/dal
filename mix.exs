defmodule Dal.MixProject do
  use Mix.Project

  def project do
    [
      app: :dal,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      consolidate_protocols: Mix.env != :test
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
      {:ecto, "~> 2.2"},
      {:ex_doc, "~> 0.18.4", only: :dev, runtime: false},
      {:postgrex, "~> 0.13.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.6.0", only: :dev, runtime: false},
      {:inch_ex, only: :docs},
    ]
  end
end
