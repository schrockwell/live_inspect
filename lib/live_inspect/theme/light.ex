defmodule LiveInspect.Theme.Light do
  @behaviour LiveInspect.Theme

  @impl true
  def style do
    """
    .live-inspect-table {
      background: #fff;
      font-color: #000;
      font-size: 0.8rem;
    }

    .live-inspect-table td,
    .live-inspect-table th {
      vertical-align: top;
      border: 1px solid #999;
      border-collapse: collapse;
      padding: 0.25rem;
      text-align: left;
    }

    .live-inspect-table th {
      cursor: pointer;
      font-weight: bold;
      background-color: #ddd;
      user-select: none;
      -moz-user-select: none;
      -webkit-user-select: none;
      -ms-user-select: none;
    }

    .live-inspect-table th:hover {
      background-color: #bbb;
    }

    .live-inspect-number { color: #e00; }
    .live-inspect-binary { color: #00e; }
    .live-inspect-struct { color: #0aa; }
    .live-inspect-map { color: #0a0; }
    .live-inspect-list { color: #a0a; }
    .live-inspect-atom { color: #000; }
    .live-inspect-tuple { color: #aa0; }
    .live-inspect-pid { color: #000; }
    .live-inspect-other { color: #000; }
    """
  end

  @impl true
  def table_attrs do
    %{class: "live-inspect-table"}
  end

  @impl true
  def key_attrs(key, _value) do
    %{class: value_class(key)}
  end

  @impl true
  def value_attrs(_key, value) do
    %{class: value_class(value)}
  end

  defp value_class(number) when is_number(number), do: "live-inspect-number"
  defp value_class(binary) when is_binary(binary), do: "live-inspect-binary"
  defp value_class(struct) when is_struct(struct), do: "live-inspect-struct"
  defp value_class(map) when is_map(map), do: "live-inspect-map"
  defp value_class(list) when is_list(list), do: "live-inspect-list"
  defp value_class(atom) when is_atom(atom), do: "live-inspect-atom"
  defp value_class(tuple) when is_tuple(tuple), do: "live-inspect-tuple"
  defp value_class(pid) when is_pid(pid), do: "live-inspect-pid"
  defp value_class(_else), do: "live-inspect-other"
end
