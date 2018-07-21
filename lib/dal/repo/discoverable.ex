defprotocol DAL.Repo.Discoverable do
  @moduledoc """
  Protocol to determine what repo to use for a struct defined by `Ecto.Schema`.

  It defines a single callback, `repo/1` which should return an `Ecto.Repo` module.

  ## Examples
  
  In its most simple form, the protocol implementation might just return a Repo.

  ```
  defmodule Project do
    use Ecto.Schema

    defimpl DAL.Repo.Discoverable do
      def repo(_), do: Project.Repo
    end

    # ...schema definition
  end
  ```

  A Repo may be determined based on pattern matching of the target. For example,
  we may have projects that are for a company that has a separate repo to the main database.

  ```
  defmodule Project do
    use Ecto.Schema

    defimpl DAL.Repo.Discoverable do
      # In practice this would probably not be hard coded
      @cba_id 100

      def repo(%{company_id: @cba_id}), do: Repo.Private.CBA
      def repo(_), do: Project.Repo
    end

    # ...schema definition
  end
  ```

  ## Use in Schemas

  The DAL defines schemas as macros so that they can be shared across lots of contexts
  while minimising repetition. Consequently, the Discoverable protocol implementation should be
  defined in these macros rather than in the contexts themselves.

  ```
  defmodule DAL.Types.Project do
    defmacro __using__(_) do
      quote do
        use Ecto.Schema

        defimpl DAL.Repo.Discoverable do
          def repo(_), do: Project.Repo
        end

        # ...schema definition
      end
    end
  end
  ```
  """

  @doc "Return a repo where data is stored for the target schema"
  @spec repo(target :: Ecto.Schema.t) :: Ecto.Repo.t
  def repo(target)
end
