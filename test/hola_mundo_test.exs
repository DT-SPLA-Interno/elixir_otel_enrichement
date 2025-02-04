defmodule HolaMundoTest do
  use ExUnit.Case
  doctest HolaMundo

  test "greets the world" do
    assert HolaMundo.hello() == :world
  end
end
