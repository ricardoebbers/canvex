defmodule Canvex.Draw.StrokeTest do
  use ExUnit.Case

  alias Canvex.Draw.Stroke

  describe "ascii_printable/1" do
    test "should return ascii printable char for valid chars" do
      for char <- [97, ?a, 'a', "a", "A", "0", '0'] do
        valid = Stroke.ascii_printable(char)
        assert List.ascii_printable?(valid)
      end
    end

    test "should return error for invalid chars" do
      for char <- [0, nil, 'abc', 'ã', "abc", "ã"] do
        assert {:error, _reason} = Stroke.ascii_printable(char)
      end
    end
  end
end
