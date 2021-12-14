defmodule TronExTest do
  use ExUnit.Case
  doctest TronEx

  test "greets the world" do
    assert TronEx.hello() == :world
  end
end
