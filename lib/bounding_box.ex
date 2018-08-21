defmodule BoundingBox do
  @moduledoc """
  A Bounding Box is a rectangle defined by two points: the top left and the
  bottom right.

  """
  defstruct [:p1, :p2]

  @doc """
  p1 and p2 are coordinates (tuples)

  Returns a %BoundingBox{}

  ## Examples

  iex> BoundingBox.from_coordinates([{0, 1}, {2, 3}])
  %BoundingBox{p1: {0, 1}, p2: {2, 3}}

  """
  def from_coordinates([p1, p2]) do
    %__MODULE__{p1: p1, p2: p2}
  end

  @doc """
  bounding_boxes: List of %BoundingBox{}
  coordinate: Tuple of floats {n1, n2}

  ### WARNING

  This is just an approximation. It does not take into account Earth's
  curvature.

  In the real world I would use here a library like geo to do this calculations
  for me. But I figured that having someone's else library doing it would defeat
  the purpose of this challenge.

  ## Examples

  iex> BoundingBox.find([%BoundingBox{p1: {0,0}, p2: {1,1}}], {0.5, 0.5})
  %BoundingBox{p1: {0,0}, p2: {1,1}}
  """
  def find(bounding_boxes, coordinate) do
    Enum.find(bounding_boxes, &contains?(&1, coordinate))
  end

  defp contains?(%BoundingBox{p1: {x1, y1}, p2: {x2, y2}}, {c1, c2}) do
    ((x1 <= c1 and c1 <= x2) or (x2 <= c1 and c1 <= x1)) and
      ((y1 <= c2 and c2 <= y2) or (y2 <= c2 and c2 <= y1))
  end
end
