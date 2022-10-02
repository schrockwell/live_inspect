defmodule LiveInspect.Theme.Base do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @behaviour LiveInspect.Theme

      @impl true
      def root_attrs do
        %{class: "live-inspect-root"}
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
  end
end
