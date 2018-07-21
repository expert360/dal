defmodule DALTest.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :name, :string
    end
  end
end
