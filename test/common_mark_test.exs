defmodule CommonMarkTest do
  use ExUnit.Case
  doctest CommonMark

  test "greets the world" do
    assert CommonMark.hello() == :world
  end
end
