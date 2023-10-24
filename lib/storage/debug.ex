defmodule Alchemy.Storage.Debug do

  def print(root_directory_name) do
    case get_directory_tree_(root_directory_name) do
      {:ok, %{columns: columns, rows: rows}} ->
        rows
          |> Enum.map(fn row -> Enum.zip(columns, row) |> Map.new() end)
      {:error, message} ->
        IO.puts("#{message}")
    end
  end

  def get_directory_tree_(name) do
    query =
    "WITH RECURSIVE r AS ( \
        SELECT root.id AS directory_id, \
               root.name AS directory_name, \
               root.parent_id AS parent_id, \
               root.name AS path \
        FROM directories as root \
        WHERE root.name = $1 AND root.parent_id IS NULL \
        UNION ALL \
        SELECT sub.id AS sub_id, \
               sub.name AS sub_name, \
               sub.parent_id AS sub_parent_id, \
               (r.path || '/' || sub.name)::character varying(255) AS path \
        FROM directories AS sub \
        INNER JOIN r ON r.directory_id = sub.parent_id
    ) \
    SELECT r.directory_id, \
           r.directory_name, \
           r.parent_id, \
           r.path, \
           NULL AS file_id, \
           NULL AS file_name, \
           NULL AS file_contents, \
           NULL AS file_directory_id \
    FROM r \
    UNION \
    SELECT \
          r.directory_id, \
          r.directory_name, \
          NULL AS parent_id, \
          (r.path || '/' || f.name)::character varying(255) AS path,
          f.id AS file_id, \
          f.name AS file_name, \
          f.contents AS file_contents, \
          f.directory_id AS file_directory_id \
    FROM r \
    INNER JOIN files AS f ON r.directory_id = f.directory_id
    ORDER BY directory_id ASC;"
    params = [name]
    Ecto.Adapters.SQL.query(Alchemy.Repo, query, params)
  end

end
