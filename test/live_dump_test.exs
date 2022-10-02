defmodule LiveDumpTest do
  use ExUnit.Case
  doctest LiveInspect

  test "greets the world" do
    assert LiveInspect.hello() == :world
  end
end
