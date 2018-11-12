defmodule DAL.Sandbox do
  @moduledoc """
  Helper module for dealing with Repo Sanboxes in tests.
  """

  alias Ecto.Adapters.SQL.Sandbox

  @doc """
  Checkout all provided repos in `:shared` mode.

  ```
  setup do
    :ok = DAL.Sandbox.checkout_all_as_shared([A, B, C])
  end
  ```
  """
  def checkout_all_as_shared(repos) when is_list(repos) do
    Enum.each(repos, fn repo ->
      with :ok <- Sandbox.checkout(repo),
           :ok <- Sandbox.mode(repo, {:shared, self()}) do
        :ok
      else
        _ -> :error
      end
    end)
  end
end
