defmodule DAL.Repo.Discovery do
  @moduledoc """
  A discovery mechanism for Repos with the DAL.

  This module is a wrapper to the `DAL.Repo.Discoverable` protocol
  that allows the DAL to determine which Repo is should use for a given struct.

  The `DAL.Repo.Discoverable` protocol should be defined for each struct while the `DAL.Repo.Discovery`
  wrapper module allows discovery to be done on `Ecto.Changeset` and `Ecto.Query` as well.
  """

  alias DAL.Repo.Discoverable

  @doc """
  Find the appropriate Repo (based on the `DAL.Repo.Discoverable` protocol)
  for the given `Ecto.Queryable` (a struct or a schema) or `Ecto.Changeset`.
  """
  @spec fetch(Ecto.Queryable.t() | Ecto.Changeset.t()) :: Ecto.Repo.t()
  def fetch(target) when is_atom(target) do
    target
    |> struct
    |> fetch
  end

  def fetch(%Ecto.Changeset{data: target}) do
    fetch(target)
  end

  def fetch(%Ecto.Query{from: %Ecto.Query.FromExpr{source: {_, target}}}) do
    fetch(target)
  end

  def fetch(target) do
    Discoverable.repo(target)
  end
end
