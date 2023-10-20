defmodule Alchemy.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do

    create table(:directories) do
      add :name, :string, null: false
      add :parent_id, references(:directories, on_delete: :delete_all), default: nil
      timestamps()
    end

    create unique_index(:directories, [:name, :parent_id], name: :directories_name_parent_id_index)

    create table(:files) do
      add :name, :string, null: false
      add :contents, :text, default: nil
      add :directory_id, references(:directories, on_delete: :delete_all), default: nil
      timestamps()
    end

    create unique_index(:files, [:name, :directory_id], name: :files_name_directory_id_index)

  end
end
