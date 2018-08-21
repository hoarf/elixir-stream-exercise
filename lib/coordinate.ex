defmodule Coordinate do
  @moduledoc """
  A Coordinate is a tuple where the first element represents the latitude and the second element
  represents the longitude.
  """

  @doc """
  Parse a raw string coordinate into a tuple.


  ## Examples

  iex> Coordinate.cast("120.9931,14.7583")
  {:ok, {14.7583,120.9931}}

  """
  def cast(raw_point) when is_bitstring(raw_point) do
    with [raw_long, raw_lat] <- String.split(raw_point, ","),
         {:ok, lat} <- raw_lat |> String.trim() |> Float.parse() |> to_coordinate(:lat),
         {:ok, long} <- raw_long |> String.trim() |> Float.parse() |> to_coordinate(:long) do
      {:ok, {lat, long}}
    else
      {:error, reason} ->
        {:error, "#{reason}: '#{raw_point}'"}

      _ ->
        {:error, "Invalid coordinate: #{raw_point}"}
    end
  end

  defmacro is_valid_coordinate(number, type) do
    quote do
      (unquote(type) === :lat and -90 <= unquote(number) and unquote(number) <= 90) or
        (unquote(type) === :long and -180 <= unquote(number) and unquote(number) <= 180)
    end
  end

  defp to_coordinate({number, _}, type) when is_valid_coordinate(number, type), do: {:ok, number}

  defp to_coordinate({number, _}, type),
    do: {:error, "Coordinate #{number} is not in range for type #{type}"}

  defp to_coordinate(:error, _), do: {:error, "Not a valid number"}
end
