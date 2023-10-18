defmodule Alchemy.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :name, :string
    has_many :directories, Alchemy.Directory
    has_many :file, Alchemy.File
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(directory, attrs) do
    directory
      |> cast(attrs, [:name])
      |> validate_required([:name])
      |> validate_length([:name], max: 100)
      |> unique_constraint(:name, name: :directories_name_parent_id_index)
  end

end
