defmodule Alchemy.Utils.Time do
  def get_date(), do: Timex.today("Asia/Tokyo")
  def get_time(), do: Timex.now("Asia/Tokyo") |> Timex.format!("%T%:z", :strftime)
  def get_weekday(), do: Timex.today("Asia/Tokyo") |> Timex.weekday()
  def get_day_name(weekday), do: Map.get(day_name(), weekday)
  defp day_name(), do: %{1 => "月", 2 => "火", 3 => "水", 4 => "木", 5 => "金", 6 => "土", 7 => "日"}
end
