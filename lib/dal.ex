defmodule DAL do
  @moduledoc """
  Global Data Access Layer to replace direct use of `Ecto.Repo` and other data services.

  The DAL performs two core functions:

  1. Provides an abstraction for other data repositories
  1. Provides a set of macros representing all available data types that can be used in services

  ## Data Abstraction

  We use a number of different databases at Expert360. Right now all of them are SQL (either MySQL or PostgreSQL) and use `Ecto.Repo`
  but in the future they may also be other databases such as Redis or Elasticsearch.

  The DAL uses a discovery mechanism (see `DAL.Repo.Discovery`) which uses Elixir protocols to determine what Repo and
  attached database to use for a particular query. This way the caller does not need to know where to find the data - they
  just need to query the DAL.

  The DAL emulates the `Ecto.Repo` API so that it can be used in place of an actual Repo in most scenarios (for example in `ex_machina` factories).
  But be aware that it does not actually adhere to the `Ecto.Repo` behaviour as it does not define callbacks such as `start_link/1`.

  You can use the DAL in exactly the same way that you would a normal ecto repo:

  ```elixir
  DAL.get(Profiles.Project, 1)
  ```

  ## Schema Macros

  In the DAL architecture, services need to define their own schema models. However, to have multiple services
  that define schema fields would be cumbersome and error prone.

  Consequently, the DAL defines macros for each data type that it supports (including implementations for `DAL.Repo.Discoverable`)
  that can be used by services.

  For example, to create a project schema model in the `Profiles` service:

  ```
  defmodule Profiles.Project do
    use DAL.Types.Project
  end
  """

  @behaviour DAL.Behaviour

  alias DAL.Repo.Discovery
  alias Ecto.Multi
  import Ecto.Query

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.get/3`
  """
  @spec get(
          queryable :: Ecto.Queryable.t(),
          id :: term,
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | nil | no_return
  def get(queryable, id, opts \\ []) do
    execute(queryable, :get, [id, opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.get!/3`
  """
  @spec get!(
          queryable :: Ecto.Queryable.t(),
          id :: term,
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | nil | no_return
  def get!(queryable, id, opts \\ []) do
    execute(queryable, :get!, [id, opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.get_by/3`
  """
  @spec get_by(
          queryable :: Ecto.Queryable.t(),
          clauses :: Keyword.t() | map,
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | nil | no_return
  def get_by(queryable, params, opts \\ []) do
    execute(queryable, :get_by, [params, opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.get_by!/3`
  """
  @spec get_by!(
          queryable :: Ecto.Queryable.t(),
          clauses :: Keyword.t() | map,
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | nil | no_return
  def get_by!(queryable, params, opts \\ []) do
    execute(queryable, :get_by!, [params, opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.one!/2`
  """
  @spec one(
          queryable :: Ecto.Query.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | nil | no_return()
  def one(queryable, opts \\ []) do
    execute(queryable, :one, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.get_by!/2`
  """
  @spec all(queryable :: Ecto.Query.t(), opts :: Keyword.t()) :: [Ecto.Schema.t()] | no_return
  def all(queryable, opts \\ []) do
    execute(queryable, :all, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.aggregate/4`
  """
  @spec aggregate(
          queryable :: Ecto.Query.t(),
          aggregate :: :avg | :count | :max | :min | :sum,
          field :: atom(),
          opts :: Keyword.t()
        ) :: [Ecto.Schema.t()] | no_return
  def aggregate(queryable, aggregate, field, opts \\ []) do
    execute(queryable, :aggregate, [aggregate, field, opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  and then constrains the results to the given list of ids before passing to `all/2`.
  """
  @spec all_ids(
          queryable :: Ecto.Query.t(),
          id_list :: list(term),
          opts :: Keyword.t()
        ) :: [Ecto.Schema.t()] | no_return
  def all_ids(queryable, id_list, opts \\ []) do
    queryable
    |> where([q], q.id in ^id_list)
    |> all(opts)
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.insert/2`
  """
  @spec insert(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :insert, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.insert!/2`
  """
  @spec insert!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | no_return
  def insert!(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :insert!, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.insert_or_update/2`
  """
  @spec insert_or_update(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert_or_update(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :insert_or_update, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.insert_or_update!/2`
  """
  @spec insert_or_update!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert_or_update!(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :insert_or_update!, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.delete/2`
  """
  @spec delete(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :delete, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.delete_all/2`
  """
  @spec delete_all(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete_all(queryable, opts \\ []) do
    execute(queryable, :delete_all, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.delete!/2`
  """
  @spec delete!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | no_return
  def delete!(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :delete!, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.update/2`
  """
  @spec update(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :update, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.update!/2`
  """
  @spec update!(
          struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t(),
          opts :: Keyword.t()
        ) :: Ecto.Schema.t() | no_return
  def update!(struct_or_changeset, opts \\ []) do
    execute(struct_or_changeset, :update!, [opts])
  end

  @doc """
  Delegates to an appropriate repo determined by `DAL.Repo.Discoverable`
  then behaves just like `c:Ecto.Repo.stream/2`
  """
  @spec stream(queryable :: Ecto.Query.t(), opts :: Keyword.t()) :: Enum.t()
  def stream(queryable, opts \\ []) do
    execute(queryable, :stream, [opts])
  end

  @doc """
  Helper function that inserts a list of `Ecto.Changeset` via `Ecto.Multi`, wrapping it in a transaction.'
  """
  @spec insert_bulk(
          changesets :: [Ecto.Changeset.t()],
          opts: list()
        ) :: {:ok, [map()]} | {:error, Ecto.Changeset.t()}
  def insert_bulk(changesets, opts \\ []) do
    changesets
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {changeset, index}, multi ->
      Multi.insert(multi, Integer.to_string(index), changeset, opts)
    end)
    |> transaction(opts)
    |> case do
      {:ok, result} -> {:ok, Map.values(result)}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @spec insert_all(
          schema_or_source :: binary() | {binary(), Ecto.Schema.t()} | Ecto.Schema.t(),
          entries :: [map() | Keyword.t()],
          opts :: Keyword.t()
        ) :: {integer(), nil | [term()]} | no_return()
  def insert_all(schema_or_source, entries, opts \\ []) do
    execute(schema_or_source, :insert_all, [entries, opts])
  end

  @spec transaction(Multi.t() | Ecto.Query.t()) ::
          {:ok, any()}
          | {:error, any()}
          | {:error, Ecto.Multi.name(), any(), %{optional(Ecto.Multi.name()) => any()}}
  @doc """
  Wrapper over `Ecto.transaction` to handle `Ecto.Multi` and a standard `Ecto.Query`, built in repo discovery.
  """
  def transaction(queryable, opts \\ [])

  def transaction(%Multi{} = multi, opts) do
    multi
    |> Multi.to_list()
    |> Enum.reduce(nil, fn {_id, {_action, changeset, _opts}}, acc ->
      repo = discover(changeset)

      cond do
        acc == nil -> repo
        repo != acc -> raise "Multiple repos in transaction not allowed"
        repo == acc -> repo
      end
    end)
    |> apply(:transaction, [multi, opts])
  end

  def transaction(queryable, _opts) when is_function(queryable) do
    raise(ArgumentError, "Can't use DAL discovery with a function argument")
  end

  def transaction(queryable, opts) do
    queryable
    |> discover()
    |> apply(:transaction, [queryable, opts])
  end

  @doc """
  Convenience function for using repo discovery.
  """
  @spec discover(
          queryable ::
            nil | Ecto.Query.t() | Ecto.Changeset.t() | Ecto.Schema.t() | [Ecto.Schema.t()]
        ) :: Ecto.Repo.t()
  def discover(%Ecto.Changeset{data: data}) do
    discover(data)
  end

  def discover(structs) when is_list(structs) do
    structs |> Enum.find(& &1) |> discover()
  end

  def discover(nil), do: nil

  def discover(queryable) do
    Discovery.fetch(queryable)
  end

  def preload(struct_or_structs_or_nil, preloads, opts \\ []) do
    repo = discover(struct_or_structs_or_nil)
    Ecto.Repo.Preloader.preload(struct_or_structs_or_nil, repo, preloads, opts)
  end

  defp execute(target, function, args) do
    target
    |> discover()
    |> apply(function, [target | args])
  end
end
