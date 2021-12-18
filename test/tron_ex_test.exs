defmodule TronTest do
  use ExUnit.Case
  doctest Tron

  test "greets the world" do
    assert Tron.hello() == :world
  end
end
