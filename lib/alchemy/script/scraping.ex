
defmodule Alchemy.Script.Scraping do
  @moduledoc """
  Scraping.
  """

  def pages() do
    [
      %{name: "Programming", url: "http://blog.livedoor.jp/itsoku/archives/cat_886769.html", limit: 5},
      %{name: "Pixel", url: "http://blog.livedoor.jp/itsoku/search?q=Pixel", limit: 3},
    ]
  end

  def get_data() do
    pages()
      |> Enum.map(
        &%{
          name: &1.name,
          articles: HTTPoison.get!(&1.url).body |> parse_html() |> Enum.take(&1.limit)
        }
      )
      |> Jason.encode!()
      |> Jason.Formatter.pretty_print()
      |> IO.puts()
  end

  defp parse_html(html) do
    html
      |> Floki.parse_document!()
      |> Floki.find("h1.article-title")
      |> Enum.map(
        &%{
          title: Floki.text(&1),
          link: Floki.attribute(&1, "a", "href") |> hd()
        }
      )
  end

end
