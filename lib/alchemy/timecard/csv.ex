defmodule Alchemy.TimeCard.CSV do
  import Ecto.Query, warn: false
  alias Alchemy.Repo
  alias Alchemy.TimeCard
  alias Alchemy.Utils.File, as: FileUtil
  alias Alchemy.Utils.Time, as: TimeUtil

  def export() do
    with {:ok, file} <- file_name() |> FileUtil.open(),
         start_date = TimeUtil.get_date() |> Date.beginning_of_month(),
         end_date = TimeUtil.get_date() |> Date.end_of_month(),
         record_list = get_record_list(start_date, end_date)
    do
      write_csv(file, record_list)
    end
  end

  defp file_name() do
    file_name = TimeUtil.get_date() |> Timex.format!("{YYYY}{M}")
    "#{file_name}.csv"
  end

  defp headers, do: [:"日付", :"曜日", :"開始時刻", :"終了時刻"]

  defp write_csv(file, record_list) do
    record_list
    |> Enum.map(
      &%{
        "日付": &1.date,
        "曜日": TimeUtil.get_day_name(&1.weekday),
        "開始時刻": &1.start_time,
        "終了時刻": &1.end_time,
      }
    )
    |> CSV.encode(headers: headers())
    |> Enum.each(&IO.write(file, &1))
  end

  defp fields, do: [:date, :weekday, :start_time, :end_time]

  defp get_record_list(start_date, end_date) do
    query = from t in TimeCard, select: map(t, ^fields()), where: t.date >= ^start_date, where: t.date <= ^end_date, order_by: [asc: t.date]
    Repo.all(query)
  end

end
