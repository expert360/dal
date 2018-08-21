defmodule Dal.MixProject do
  use Mix.Project

  def project do
    [
      app: :dal,
      name: "DAL",
      version: "0.1.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      consolidate_protocols: false,
      test_coverage: [tool: ExCoveralls],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "Ecto proxy to simplify querying across multiple separate databases"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:ex_doc, "~> 0.18.4", only: :dev, runtime: false},
      {:postgrex, "~> 0.13.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.6.0", only: :dev, runtime: false},
      {:inch_ex, only: :docs},
      {:excoveralls, "~> 0.9.1", only: :test}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE.md),
      links: %{"GitHub" => "https://github.com/expert360/dal"},
      licenses: ["Apache 2.0"],
      maintainers: ["Dan Draper"],
    ]
  end
end
