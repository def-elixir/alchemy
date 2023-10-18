defmodule Alchemy.File do
  use Ecto.Schema
  import Ecto.Changeset

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
      |> validate_length([:name], max: 100)
      |> unique_constraint(:name, name: :files_name_directory_id_index)
  end

end
