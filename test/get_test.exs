defmodule DALTest.Get do
  use DALTest.Case
  doctest DAL

  alias DALTest.Band

  describe "When a record exists" do
    setup [:create_band]

    test "get will return the record", %{band: band} do
      assert DAL.get(Band, band.id) == band
    end

    test "get_by will return the record", %{band: band} do
      assert DAL.get_by(Band, name: band.name) == band
    end

    test "get! will return the record", %{band: band} do
      assert DAL.get!(Band, band.id) == band
    end
  end

  describe "When a record is missing" do
    test "attempt to get the record will return nil" do
      refute DAL.get(Band, 100)
    end

    test "attempt to get! the record will raise an error" do
      assert_raise Ecto.NoResultsError, fn ->
        DAL.get!(Band, 100)
      end
    end

    test "attempt to call get_by! will raise an error" do
      assert_raise Ecto.NoResultsError, fn ->
        DAL.get_by!(Band, name: "Abba")
      end
    end
  end
end
