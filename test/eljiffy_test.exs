defmodule EljiffyTest do
  use ExUnit.Case
  doctest Eljiffy

  test "greets the world" do
    assert Eljiffy.hello() == :world
  end
end
