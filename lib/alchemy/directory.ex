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

  @spec changeset(any(), any()) :: none()
  def changeset(directory, attrs) do
    directory
      |> cast(attrs, [:name, :parent_id])
      |> validate_required([:name])
      |> validate_length(:name, max: 100)
      |> validate_directory_name_unique()
      |> unique_constraint(:name, name: :directories_name_parent_id_index)
  end

  @spec validate_directory_name_unique(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_directory_name_unique(changeset) do
    name = get_field(changeset, :name)
    case Repo.one(from d in Alchemy.Directory, where: d.name == ^name and is_nil(d.parent_id)) do
      nil ->
        changeset
      _ ->
        add_error(changeset, :name, "directory name '#{name}' already exists")
    end
  end

end
