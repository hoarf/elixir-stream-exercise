defmodule BoundingBoxTest do
  use ExUnit.Case
  doctest BoundingBox

  test "find returns the correct bounding box on every quadrant" do
    b1 = %BoundingBox{p1: {0, 0}, p2: {1, 1}}
    b2 = %BoundingBox{p1: {0, 0}, p2: {1, -1}}
    b3 = %BoundingBox{p1: {0, 0}, p2: {-1, 1}}
    b4 = %BoundingBox{p1: {0, 0}, p2: {-1, -1}}

    assert b1 == BoundingBox.find([b1, b2, b3, b4], {0.5, 0.5})
    assert b2 == BoundingBox.find([b1, b2, b3, b4], {0.5, -0.5})
    assert b3 == BoundingBox.find([b1, b2, b3, b4], {-0.5, 0.5})
    assert b4 == BoundingBox.find([b1, b2, b3, b4], {-0.5, -0.5})
    refute BoundingBox.find([b1, b2, b3, b4], {2, 2})
    refute BoundingBox.find([], {2, 2})
  end
end
