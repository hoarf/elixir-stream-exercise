defmodule CoordinatesTest do
  use ExUnit.Case
  doctest Coordinate

  test "correctly casts valid coordinates" do
    assert {:ok, {90.0, -127.554334}} = Coordinate.cast("-127.554334, +90.0")
    assert {:ok, {45.0, 180.0}} = Coordinate.cast("180 , 45 ")
    assert {:ok, {-90.0, -180.0}} = Coordinate.cast("-180, -90")
    assert {:ok, {-90.0, -180.0}} = Coordinate.cast("-180.0000, -90.0000")
    assert {:ok, {+90.0, +180.0}} = Coordinate.cast("+180, +90.0000")
    assert {:ok, {47.1231231, 179.99999999}} = Coordinate.cast("179.99999999, 47.1231231")
  end

  test "generates an error with invalid coordinates" do
    assert {:error, _} = Coordinate.cast("-180.0,-91.0")
    assert {:error, _} = Coordinate.cast("-280.0,-90.0")
    assert {:error, _} = Coordinate.cast("-280.0,-190.0")
    assert {:error, _} = Coordinate.cast("")
    assert {:error, _} = Coordinate.cast("    ")
    assert {:error, _} = Coordinate.cast("  notanumber, not  ")
  end
end
