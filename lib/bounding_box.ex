defmodule BoundingBox do
  @moduledoc """
  Struct used to hold the pair of coordinates that define a bounding box.
  """

  defstruct [:p1, :p2]

  def from_coordinate([p1, p2]) do
    %__MODULE__{p1: p1, p2: p2}
  end


  def find(bounding_boxes, coordinate) do
    Enum.find(bounding_boxes, fn b -> contains?(b, coordinate) end)
  end

  def contains?(bounding_box, {c1, c2}) do
    {x1, y1} = bounding_box.p1
    {x2, y2} = bounding_box.p2

    ((x1 <= c1 and c1 <= x2) or (x2 <= c1 and c1 <= x1)) and
      ((y1 <= c2 and c2 <= y2) or (y2 <= c2 and c2 <= y1))
  end
end
