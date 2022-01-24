defmodule Canvex.Repo.Migrations.CreateCanvas do
  use Ecto.Migration

  def change do
    create table(:canvas, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :charlist, {:array, :integer}
      add :height, :integer
      add :width, :integer
      add :user_id, :uuid

      timestamps()
    end
  end
end
