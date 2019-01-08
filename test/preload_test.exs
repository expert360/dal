defmodule DALTest.Preload do
  use DALTest.Case
  doctest DAL

  alias DALTest.Band

  describe "Preloading for nil" do
    test "it returns nil" do
      assert DAL.preload(nil, :something) == nil
    end
  end

  describe "Preloading belongs_to for single parent" do
    setup [
      :create_genre,
      :create_many_bands
    ]

    test "loads an associated record", %{bands: [band | _], genre: genre} do
      %{genre: loaded} =
        Band
        |> DAL.get(band.id)
        |> IO.inspect()
        |> DAL.preload(:genre)

      assert loaded == genre
    end

    test "loads all associated records", %{genre: genre} do
      loaded =
        Band
        |> DAL.all()
        |> DAL.preload(:genre)
        |> Enum.map(fn band ->
          band.genre
        end)

      assert loaded == [genre, genre]
    end
  end

  describe "Preloading belongs_to for unique parents" do
    setup [
      :create_many_genres,
      :create_many_bands
    ]

    test "loads all associated records", %{genres: genres} do
      loaded =
        Band
        |> DAL.all()
        |> DAL.preload(:genre)
        |> Enum.map(fn band ->
          band.genre
        end)

      assert loaded == genres
    end
  end

  describe "Preloading a has_many within the same database" do
    setup [
      :create_band,
      :create_many_albums
    ]

    test "loads the associated records for the band",
         %{band: band, albums: albums} do
      %{albums: loaded} =
        Band
        |> DAL.get(band.id)
        |> DAL.preload(:albums)

      assert loaded == albums
    end
  end
end
