defmodule Alchemy.Directory do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Alchemy.Repo

  schema "directories" do
    field :name, :string
    field :parent_id, :integer
    has_many :subdirectories, Alchemy.Directory, foreign_key: :parent_id
    has_many :files, Alchemy.File
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(directory, attrs) do
    directory
      |> cast(attrs, [:name, :parent_id])
      |> validate_required([:name])
      |> validate_length(:name, max: 100)
      |> validate_directory_name()
      |> unique_constraint(:name, name: :directories_name_parent_id_index)
  end

  def validate_directory_name(changeset) do
    name = get_field(changeset, :name)
    if is_nil(name) do
      changeset
    else
      case check_duplicate_root_directory_name(name) do
        nil -> changeset
        {:ok, directory} -> add_error(changeset, :name, "directory name '#{directory.name}' already exists")
      end
    end
  end

  defp check_duplicate_root_directory_name(name) do
    query = from d in Alchemy.Directory, where: d.name == ^name and is_nil(d.parent_id), limit: 1
    case Repo.one(query) do
      %Alchemy.Directory{} = directory -> {:ok, directory}
      nil -> nil
    end
  end
end
