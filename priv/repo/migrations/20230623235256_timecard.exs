defmodule Script.Repo.Migrations.Timecard do
  use Ecto.Migration

  def change do
    create table(:timecard) do
      add :date, :date, null: false
      add :start_time, :time, default: nil
      add :end_time, :time, default: nil
      add :weekday, :smallint, null: false

      timestamps()
    end
  end
end
