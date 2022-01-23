defmodule Data.Repo.Migrations.CreateCanvasTable do
  use Ecto.Migration

  def change do
    create table(:canvas) do
      add :charlist, {:array, :integer}
      add :width, :integer
      timestamps()
    end
  end
end
