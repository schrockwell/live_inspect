defmodule LiveInspect.Inspector do
  @moduledoc """
  The LiveComponent to inspect values directly on the page.

  Typically, the `LiveInspect.live_inspect/1` convenience helper should be used instead.

  ## Example

      <.live_component
        module={LiveInspect.Inspector}
        id="live-inspect"
        value={%{my_assign: @my_assign, my_other_assign: @my_other_assign}}
      />

  ## Attributes

    - `:id` - required
    - `:value` - required; any term to inspect
    - `:root?` - optional; indicates that this inspector is rendered directly on the page, and is not nested; defaults to `true`
    - `:theme` - optional; the theme module; defaults to the configured theme
  """

  use Phoenix.LiveComponent

  defp theme do
    Application.get_env(:live_inspect, :theme, LiveInspect.Theme.Light)
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, root?: true, style: nil)}
  end

  @impl true
  def update(%{__toggle_expanded__: true}, socket) do
    {:ok, assign(socket, :expanded?, not socket.assigns.expanded?)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:theme, fn -> theme() end)
     |> assign_initial_expanded()}
  end

  @impl true
  def preload([first | rest]) do
    # Only inject CSS styles for the first invocation of this component
    first = Map.put(first, :style, theme().style)
    rest = for assigns <- rest, do: Map.put(assigns, :style, nil)
    [first | rest]
  end

  @impl true
  def handle_event("toggle-expanded", %{"id" => id}, socket) do
    send_update(__MODULE__, %{id: id, __toggle_expanded__: true})
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} {root_attrs(@root?, @theme)}>
      <%= if @root? && @style do %>
        <.style style={@style} />
      <% end %>
      <%= cond do %>
        <% not @expanded? -> %>
          <%= inspect_hidden(@value) %>
        <% enumerable?(@value) and not empty?(@value) -> %>
          <%= if is_struct(@value) do %>
            <div {@theme.value_attrs(@key, @value)}>
              <%= inspect_hidden(@value) %>
            </div>
          <% end %>

          <table {@theme.table_attrs()}>
            <%= for {index, key, value} <- enumerate(@value) do %>
              <tr>
                <th
                  phx-click="toggle-expanded"
                  phx-value-id={nested_id(@id, index)}
                  phx-target={@myself}
                  {@theme.key_attrs(key, value)}
                >
                  <%= inspect(key) %>
                </th>
                <td {@theme.value_attrs(key, value)}>
                  <.live_component
                    module={__MODULE__}
                    id={nested_id(@id, index)}
                    root?={false}
                    key={key}
                    value={value}
                  />
                </td>
              </tr>
            <% end %>
          </table>
        <% :else -> %>
          <%= inspect(@value) %>
      <% end %>
    </div>
    """
  end

  defp assign_initial_expanded(socket) do
    if changed?(socket, :root?) do
      assign(
        socket,
        :expanded?,
        socket.assigns.root? or short?(socket.assigns.value)
      )
    else
      socket
    end
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

  defp inspect_hidden(%struct{} = value)
       when struct in [DateTime, NaiveDateTime, Regex, Range, MapSet],
       do: inspect(value)

  defp inspect_hidden(%struct{}) do
    case to_string(struct) do
      "Elixir." <> module -> "%#{module}{}"
      other -> "%#{other}{}"
    end
  end

  defp inspect_hidden(map) when is_map(map) and map_size(map) == 1, do: "1 field"
  defp inspect_hidden(map) when is_map(map), do: "#{map_size(map)} fields"

  defp inspect_hidden(_else), do: "•••"

  defp root_attrs(false, _theme), do: %{}
  defp root_attrs(true, theme), do: theme.root_attrs()

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
