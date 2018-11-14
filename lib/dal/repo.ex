defmodule DAL.Repo do
  @moduledoc """
  Helpers for introspecting on schemas and repos related to DAL usage
  """

  @doc """
  Given an `app_name`, returns a unique list of repos that all schema
  implementations point to. `app_name` is the same one would pass for your
  `app:` key under your `project` definition in ones `mix.exs`. e.g.

      defmodule MyProject.Mixfile do
        def project do
          [
            app: my_project
            <...snip...>
          ]
        end
        <...snip...>
      end

  with a repo

      defmodule MyProject.Repo.MyRepo do
        use Ecto.Repo, otp_app: :my_project

        <...snip...>
      end

  and an implementation

      defmodule MyProject.Schema.MySchema do
        <...snip...>

        defimpl DAL.Repo.Discoverable do
          def repo(_), do: MyProject.Repo.MyRepo
        end
      end

  can be used as:

      iex> DAL.Repo.repos(:my_project)
      [MyProject.Repo.MyRepo]


  This is particularly useful for tests where one may call

      setup_all do
        :ok = DAL.Sandbox.checkout_all_as_shared(DAL.Repo.repos(:my_project))
      edn

  """
  def repos!(app_name) do
    {:ok, rs} = repos(app_name)
    rs
  end

  def repos(app_name) when is_atom(app_name) and not is_nil(app_name) do
    with {:ok, ss} <- schemas(app_name) do
      rs =
        ss
        |> Enum.map(fn s -> DAL.Repo.Discoverable.repo(struct(s)) end)
        |> Enum.uniq

       {:ok, rs}
    else
      err ->
        err
    end
  end
  def repos(_) do
    {:error, "Invalid arguments passed to '#{__ENV__.function |> elem(0)}'"}
  end

  def schemas(app_name) when is_atom(app_name) and not is_nil(app_name) do
    with path when is_list(path) <- :code.lib_dir(app_name, :ebin) do
      ss =
        DAL.Repo.Discoverable
        |> Protocol.extract_impls([path])
        |> Enum.uniq()

      {:ok, ss}
    else
      {:error, :bad_name} ->
        {:error, "No application found by the name '#{app_name}'"}
      err ->
        {:error, "An unknown error occured: #{inspect err}"}
    end
  end
  def schemas(_) do
    {:error, "Invalid arguments passed to '#{__ENV__.function |> elem(0)}'"}
  end
end
