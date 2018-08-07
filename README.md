# DAL

![CircleCI](https://img.shields.io/circleci/project/github/expert360/dal.svg)
![Codecov](https://img.shields.io/codecov/c/github/expert360/dal.svg)
![Hex.pm](https://img.shields.io/hexpm/dt/dal.svg)
![Hex.pm](https://img.shields.io/hexpm/v/dal.svg)
[![Inline docs](http://inch-ci.org/github/expert360/dal.svg)](http://inch-ci.org/github/expert360/dal)

Global Data Access Layer to replace direct use of `Ecto.Repo` and other data services.

The DAL performs two core functions:

1. Provides an abstraction for other data repositories
2. Provides a set of macros representing all available data types that can be used in services

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dal, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dal](https://hexdocs.pm/dal).
