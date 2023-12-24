defmodule Alchemy.TimeCard.Clock do
  import Ecto.Query, warn: false
  alias Alchemy.Repo
  alias Alchemy.TimeCard
  alias Alchemy.Utils.Time, as: TimeUtil

  def clock_in() do
    with date = TimeUtil.get_date(),
         start_time = TimeUtil.get_time(),
         weekday = TimeUtil.get_weekday()
    do
      record = %{date: date, start_time: start_time, weekday: weekday}
      save_time(:register, record)
    end
  end

  def clock_out() do
    with date = TimeUtil.get_date(),
         end_time = TimeUtil.get_time(),
         weekday = TimeUtil.get_weekday(),
         record = get_record_by_date(date)
    do
      if record do
        save_time(:update, record, %{end_time: end_time})
      else
        save_time(:register, %{date: date, end_time: end_time, weekday: weekday})
      end
    end
  end

  defp save_time(:register, attrs) do
    case register_time(attrs) do
      {:ok, timecard}  -> {:ok, "save time card: #{timecard.date}/#{timecard.start_time}/#{timecard.end_time}"}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset.errors}
    end
  end

  defp save_time(:update, timecard, attrs) do
    case update_time(timecard, attrs) do
      {:ok, _}  -> {:ok, "update time card: #{timecard.date}/#{timecard.start_time}/#{timecard.end_time}"}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset.errors}
    end
  end

  defp register_time(attrs) do
    %TimeCard{}
    |> TimeCard.changeset(attrs)
    |> Repo.insert()
  end

  defp update_time(%TimeCard{} = timecard, attrs) do
    timecard
    |> TimeCard.changeset(attrs)
    |> Repo.update()
  end

  defp get_record_by_date(date) do
    TimeCard
    |> where(date: ^date)
    |> Repo.one()
  end
end
