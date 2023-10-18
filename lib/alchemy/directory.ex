defmodule Alchemy.Directory do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Alchemy.Repo

  schema "directories" do
    field :name, :string
    field :parent_id, :integer
    has_many :directories, Alchemy.Directory
    has_many :file, Alchemy.File
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(directory, attrs) do
    directory
      |> cast(attrs, [:name])
      |> validate_required([:name])
      |> validate_length([:name], max: 100)
      |> validate_directory_name_unique([:name])
      |> unique_constraint(:name, name: :directories_name_parent_id_index)
  end

  def validate_directory_name_unique(changeset, field) do
    case Repo.one(from d in Alchemy.Directory, where: d.name == ^field and is_nil(d.parent_id)) do
      nil ->
        changeset
      _ ->
        add_error(changeset, field, "this directory name already exists")
    end
  end

end
