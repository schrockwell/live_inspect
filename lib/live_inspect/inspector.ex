defmodule LiveInspect.Inspector do
  @moduledoc """
  TODO
  """
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, __root__: true, __theme__: theme())}
  end

  def update(%{__toggle_expanded__: true}, socket) do
    {:ok, assign(socket, :__expanded__, not socket.assigns.__expanded__)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_initial_expanded()}
  end

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <%= if @__root__ && @__theme__.style do %>
        <.style style={@__theme__.style} />
      <% end %>
      <%= cond do %>
        <% not @__expanded__ -> %>
          <%= inspect_hidden(@__value__) %>
        <% enumerable?(@__value__) and not empty?(@__value__) -> %>
          <%= if is_struct(@__value__) do %>
            <div {@__theme__.value_attrs(@__key__, @__value__)}>
              <%= inspect_hidden(@__value__) %>
            </div>
          <% end %>

          <table {@__theme__.table_attrs()}>
            <%= for {index, key, value} <- enumerate(@__value__) do %>
              <tr>
                <th
                  phx-click="toggle-expanded"
                  phx-value-id={nested_id(@id, index)}
                  phx-target={@myself}
                  {@__theme__.key_attrs(key, value)}
                >
                  <%= inspect(key) %>
                </th>
                <td {@__theme__.value_attrs(key, value)}>
                  <.live_component
                    module={__MODULE__}
                    id={nested_id(@id, index)}
                    __root__={false}
                    __key__={key}
                    __value__={value}
                  />
                </td>
              </tr>
            <% end %>
          </table>
        <% :else -> %>
          <%= inspect(@__value__) %>
      <% end %>
    </div>
    """
  end

  def handle_event("toggle-expanded", %{"id" => id}, socket) do
    send_update(__MODULE__, %{id: id, __toggle_expanded__: true})
    {:noreply, socket}
  end

  defp assign_initial_expanded(socket) do
    if changed?(socket, :__root__) do
      assign(
        socket,
        :__expanded__,
        socket.assigns.__root__ or short?(socket.assigns.__value__)
      )
    else
      socket
    end
  end

  defp theme do
    Application.get_env(:live_inspect, :theme, LiveInspect.Theme.Default)
  end

  defp short?(value) do
    not enumerable?(value) or value == [] or value == %{}
  end

  defp empty?(value) do
    value == [] or value == %{}
  end

  defp enumerable?(value) do
    is_list(value) or is_map(value)
  end

  defp enumerate(list) when is_list(list) do
    for {value, index} <- Enum.with_index(list), do: {inspect(index), index, value}
  end

  defp enumerate(map) when is_map(map) do
    for {key, index} <- Enum.with_index(Map.keys(map)),
        key != :__struct__,
        do: {inspect(index), key, Map.fetch!(map, key)}
  end

  defp nested_id(id, index) do
    "#{to_string(id)}-#{to_string(index)}"
  end

  defp inspect_hidden([_]), do: "1 item"
  defp inspect_hidden(list) when is_list(list), do: "#{length(list)} items"

  defp inspect_hidden(%struct{} = value) when struct in [DateTime, NaiveDateTime],
    do: inspect(value)

  defp inspect_hidden(%struct{}), do: "%#{struct}{}"

  defp inspect_hidden(map) when is_map(map) and map_size(map) == 1, do: "1 field"
  defp inspect_hidden(map) when is_map(map), do: "#{map_size(map)} fields"

  defp inspect_hidden(_else), do: "…"

  # This messes up VS Code syntax highlighting, so let's chuck it at the bottom in a function
  # component so it won't screw up the rest of the file
  defp style(assigns) do
    ~H"""
    <style>
      <%= @style %>
    </style>
    """
  end
end
