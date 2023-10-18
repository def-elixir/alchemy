
defmodule Alchemy.Script.Scrape do
  @moduledoc """
  Scraping.
  """

  def pages() do
    [
      %{name: "Programming", url: "http://blog.livedoor.jp/itsoku/archives/cat_886769.html", limit: 5},
      %{name: "Pixel", url: "http://blog.livedoor.jp/itsoku/search?q=Pixel", limit: 3},
    ]
  end

  def main() do
    pages()
      |> Enum.map(
        &%{
          name: &1.name,
          articles: HTTPoison.get!(&1.url).body |> scraping() |> Enum.take(&1.limit)
        }
      )
      |> Jason.encode!()
      |> Jason.Formatter.pretty_print()
      |> IO.puts()
  end

  defp scraping(html) do
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
