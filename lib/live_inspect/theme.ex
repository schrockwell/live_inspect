defmodule LiveInspect.Theme do
  @callback style() :: String.t() | nil
  @callback table_attrs :: map
  @callback key_attrs(key :: any, value :: any) :: map
  @callback value_attrs(key :: any, value :: any) :: map
end
