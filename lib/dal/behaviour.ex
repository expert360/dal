defmodule DAL.Behaviour do
  @moduledoc """
  Useful for defining mocks with [Mox](https://hexdocs.pm/mox/Mox.html)
  """

  @callback get(
              queryable :: Ecto.Queryable.t(),
              id :: term,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil | no_return

  @callback get!(
              queryable :: Ecto.Queryable.t(),
              id :: term,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil | no_return

  @callback get_by(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil | no_return

  @callback get_by!(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil | no_return

  @callback one(
          queryable :: Ecto.Query.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | nil | no_return()

  @callback all(queryable :: Ecto.Query.t(), opts :: Keyword.t()) :: [Ecto.Schema.t()] | no_return

  @callback aggregate(
          queryable :: Ecto.Query.t(),
          aggregate :: :avg | :count | :max | :min | :sum,
          field :: atom(),
          opts :: Keyword.t()
        ) :: [Ecto.Schema.t()] | no_return

  @callback all_ids(
          queryable :: Ecto.Query.t(),
          id_list :: list(term),
          opts :: Keyword.t()
        ) :: [Ecto.Schema.t()] | no_return

  @callback insert(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback insert!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | no_return

  @callback insert_or_update(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback insert_or_update!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback delete(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback delete_all(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback delete!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | no_return

  @callback update(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback update!(
    struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
    opts :: Keyword.t()
  ) :: Ecto.Schema.t() | no_return

  @callback stream(queryable :: Ecto.Query.t(), opts :: Keyword.t()) :: Enum.t()

  @callback insert_bulk(
    changesets :: [Ecto.Changeset.t()],
    opts: list()
  ) :: {:ok, [map()]} | {:error, Ecto.Changeset.t()}

  @callback insert_all(
          schema_or_source :: binary() | {binary(), Ecto.Schema.t()} | Ecto.Schema.t(),
          entries :: [map() | Keyword.t()],
          opts :: Keyword.t()
        ) :: {integer(), nil | [term()]} | no_return()

  @callback transaction(Multi.t() | Ecto.Query.t()) ::
          {:ok, any()}
          | {:error, any()}
          | {:error, Ecto.Multi.name(), any(), %{optional(Ecto.Multi.name()) => any()}}
end
