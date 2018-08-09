defmodule DALTest.Case do
  use ExUnit.CaseTemplate

  require DALTest.Genre
  alias DALTest.{
    Album,
    Band,
    Genre,
    Repo
  }
  alias DALTest.Migrations.{
    CreateAlbums,
    CreateBands,
    CreateGenres
  }

  defmacro __using__(_) do
    quote do
      use ExUnit.Case, async: false
      @migrations [
        CreateAlbums,
        CreateBands,
        CreateGenres
      ]

      @schemas [
        Album,
        Band,
        Genre
      ]

      import unquote(__MODULE__)

      setup_all do
        run_migrations(:up)

        on_exit fn ->
          run_migrations(:down)
        end
      end

      setup do
        on_exit fn ->
          Enum.each(@schemas, &Repo.delete_all/1)
        end
      end

      defp run_migrations(dir) do
        @migrations
        |> Enum.with_index
        |> Enum.each(fn {migration, index} ->
          do_migrate(dir, Repo, index, migration)
        end)
      end

      defp do_migrate(dir, repo, index, migration) do
        case dir do
          :up ->
            Ecto.Migrator.up(repo, index, migration, log: false)
          :down ->
            Ecto.Migrator.down(repo, index, migration, log: false)
        end
      end
    end
  end

  def create_band(_) do
    {:ok, band} =
      %Band{name: "Metallica"}
      |> Repo.insert

    %{band: band}
  end

  def create_many_bands(%{genre: %{id: genre_id}}) do
    {2, bands} =
      Band
      |> Repo.insert_all([
        %{name: "Metallica", genre_id: genre_id},
        %{name: "Anthrax", genre_id: genre_id},
      ], returning: true)

    %{bands: bands}
  end
  def create_many_bands(%{genres: [g1, g2]}) do
    {2, bands} =
      Band
      |> Repo.insert_all([
        %{name: "Metallica", genre_id: g1.id},
        %{name: "Abba", genre_id: g2.id},
      ], returning: true)

    %{bands: bands}
  end

  def create_many_albums(%{band: %{id: band_id}}) do
    {2, albums} =
      Album
      |> Repo.insert_all([
        %{name: "Kill 'Em All", band_id: band_id},
        %{name: "Load", band_id: band_id},
      ], returning: true)

    %{albums: albums}
  end

  def create_genre(_) do
    {:ok, genre} =
      %Genre{name: "Thrash"}
      |> Repo.insert

    %{genre: genre}
  end

  def create_many_genres(_) do
    {2, genres} =
      Genre
      |> Repo.insert_all([
        %{name: "Thrash"},
        %{name: "Pop"},
      ], returning: true)

    %{genres: genres}
  end
end
