defmodule LiveInspect.Theme.Light do
  @behaviour LiveInspect.Theme

  @impl true
  def style do
    """
    .live-dump-table {
      background: #ffffff;
      font-color: #000000;
      font-size: 0.8rem;
    }

    .live-dump-table td,
    .live-dump-table th {
      vertical-align: top;
      border: 1px solid #999;
      border-collapse: collapse;
      padding: 0.25rem;
      text-align: left;
    }

    .live-dump-table th {
      cursor: pointer;
      font-weight: bold;
      background-color: #dddddd;
      user-select: none;
      -moz-user-select: none;
      -webkit-user-select: none;
      -ms-user-select: none;
    }

    .live-dump-table th:hover {
      background-color: #bbbbbb;
    }

    .live-dump-number { color: #e00; }
    .live-dump-binary { color: #00e; }
    .live-dump-struct { color: #0aa; }
    .live-dump-map { color: #0a0; }
    .live-dump-list { color: #a0a; }
    .live-dump-atom { color: #000; }
    .live-dump-tuple { color: #aa0; }
    .live-dump-other { color: #000; }
    """
  end

  @impl true
  def table_attrs do
    %{class: "live-dump-table"}
  end

  @impl true
  def key_attrs(key, _value) do
    %{class: value_class(key)}
  end

  @impl true
  def value_attrs(_key, value) do
    %{class: value_class(value)}
  end

  defp value_class(number) when is_number(number), do: "live-dump-number"
  defp value_class(binary) when is_binary(binary), do: "live-dump-binary"
  defp value_class(struct) when is_struct(struct), do: "live-dump-struct"
  defp value_class(map) when is_map(map), do: "live-dump-map"
  defp value_class(list) when is_list(list), do: "live-dump-list"
  defp value_class(atom) when is_atom(atom), do: "live-dump-atom"
  defp value_class(tuple) when is_tuple(tuple), do: "live-dump-tuple"
  defp value_class(_else), do: "live-dump-other"
end
