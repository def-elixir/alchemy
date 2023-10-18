defmodule Alchemy.File do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Alchemy.Repo

  schema "files" do
    field :name, :string
    field :contents, :string
    belongs_to :directory, Alchemy.Directory
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(file, attrs) do
    file
      |> cast(attrs, [:name])
      |> validate_required([:name])
      |> validate_length([:name], max: 2)
      |> validate_filename_unique([:name])
      |> unique_constraint(:name, name: :files_name_directory_id_index)
  end

  def validate_filename_unique(changeset, field) do
    case Repo.one(from f in Alchemy.File, where: f.name == ^field and is_nil(f.directory_id)) do
      nil ->
        changeset
      _ ->
        add_error(changeset, field, "this file name already exists")
    end
  end

end

# alias Alchemy.{Repo, File, Directory}
