defmodule LiveInspect.Theme do
  @moduledoc """
  Behavior to implement custom styling for the inspector.
  """

  @doc """
  Returns contents of the CSS <style> to render inline on the page.

  The styles will only be injected once within a given LiveView, immediately before the first invocation of the inspector on the page.

  Return `nil` to bypass this.
  """
  @callback style() :: String.t() | nil

  @doc """
  Returns a map of attributes to add to the root inspector <div>.
  """
  @callback root_attrs :: map

  @doc """
  Returns a map of attributes to add to <table> elements.
  """
  @callback table_attrs :: map

  @doc """
  Returns a map of attributes to add to the <th> elements that contain list indices and map keys.

  The `key` argument is the map key or integer list index (rendered here), and `value` is the inspected value.
  """
  @callback key_attrs(key :: any, value :: any) :: map

  @doc """
  Returns a map of attributes to add to the <td> elements that contain inspected values.

  The `key` argument is the map key or integer list index, and `value` is the inspected value (rendered here).
  """
  @callback value_attrs(key :: any, value :: any) :: map
end
