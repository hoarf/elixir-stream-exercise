defmodule Main do
  require Logger

  @moduledoc """
  You need to call run/0 in order to initialize the cache.
  """

  @doc """

  Runs the code in the ideal world where everything goes well.
  Used for doing quick startup of the environment.

  1. Starts the cache process
  2. Build the BoundingBox cache
  3. Assigns the coordinates to the bounding box.

  """
  def happy_path() do
    run()
    pairs()
    coordinates()
  end

  @doc """
  Starts the cache in another process.

  Returns {:ok, pid} if successful or throws an error otherwise.
  """
  def run do
    Cache.start_link()
  end

  @doc """
  Reads the pairs.csv file and save the bounding boxes in the cache process.

  Will log errors as side effects.

  Returns :ok
  """
  def pairs(path \\ "data/pairs.csv") do
    path
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&Coordinate.cast/1)
    |> Stream.chunk_while([], &errors/2, &result/1)
    |> Stream.drop(-1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(&BoundingBox.from_coordinates/1)
    |> Stream.each(&Cache.save!(&1))
    |> Stream.run()
  end

  @doc """
  Reads the coordinates.csv file and find the matching bounding boxes in the
  cache process.

  Will log errors as side effects.

  Returns a Map whose keys are the coordinates that had a matching bounding box
  and the value is the the first matching bounding box in the cache.
  """
  def coordinates(path \\ "data/coordinates.csv") do
    path
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&Coordinate.cast/1)
    |> Stream.chunk_while([], &errors/2, &result/1)
    |> Stream.drop(-1)
    |> Stream.transform(%{}, &reduce/2)
    |> Enum.to_list()
  end

  @doc """
  Adds another bounding box to cache whose points are the origin and destination
  parameters.

  Returns a tuple whose elements are the BoundingBox associated with the origin
  and destination respectively if they are found, nil otherwise.
  """
  def add!(origin, destination)
      when tuple_size(origin) == 2 and tuple_size(destination) == 2 do
    with origin_bounding_box <- Cache.find(origin),
         dest_bounding_box <- Cache.find(destination) do
      Cache.save!(BoundingBox.from_coordinates([origin, destination]))
      {origin_bounding_box, dest_bounding_box}
    end
  end

  defp reduce(coordinate, acc) do
    case Cache.find(coordinate) do
      nil ->
        {[], acc}

      bounding_box ->
        {Map.merge(acc, %{coordinate => bounding_box}), acc}
    end
  end

  defp errors(item, acc) do
    case item do
      {:error, reason} ->
        Logger.warn(reason)
        {:cont, acc}

      {:ok, coordinate} ->
        {:cont, coordinate, [coordinate | acc]}
    end
  end

  defp result([]) do
    Logger.info("File does not contain any valid coordinate.")
    {:cont, []}
  end

  defp result(acc) do
    Logger.info("Found #{Enum.count(acc)} coordinate(s).")
    {:cont, & &1, acc}
  end
end
