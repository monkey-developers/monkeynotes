defmodule Monkeynote.Repo.Migrations.NotesChangeColumnType do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      modify :body, :text
    end
  end
end
