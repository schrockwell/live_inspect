defmodule LiveDumpTest do
  use ExUnit.Case
  doctest LiveDump

  test "greets the world" do
    assert LiveDump.hello() == :world
  end
end
