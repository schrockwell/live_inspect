defmodule LiveInspect.Inspector do
  @moduledoc false

  #
  # Attributes
  #
  # - id
  # - opts
  # - term
  # - theme
  #

  use Phoenix.LiveComponent

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
     |> assign_initial_expanded()}
  end

  @impl true
  def preload([%{theme: theme} = first | rest]) do
    # Only inject CSS styles for the first invocation of this component
    first = Map.put(first, :style, theme.style())
    rest = for assigns <- rest, do: Map.put(assigns, :style, nil)
    [first | rest]
  end

  def preload(list_of_assigns), do: list_of_assigns

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
          <%= inspect_hidden(@term) %>
        <% enumerable?(@term) and not empty?(@term) -> %>
          <%= if is_struct(@term) do %>
            <div {@theme.value_attrs(@key, @term)}>
              <%= inspect_hidden(@term) %>
            </div>
          <% end %>

          <table {@theme.table_attrs()}>
            <%= for {index, key, value} <- enumerate(@term, @opts) do %>
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
                    opts={@opts}
                    id={nested_id(@id, index)}
                    key={key}
                    module={__MODULE__}
                    root?={false}
                    term={value}
                    theme={@theme}
                  />
                </td>
              </tr>
            <% end %>
          </table>
        <% :else -> %>
          <%= inspect(@term) %>
      <% end %>
    </div>
    """
  end

  defp assign_initial_expanded(socket) do
    if changed?(socket, :root?) do
      assign(
        socket,
        :expanded?,
        socket.assigns.root? or short?(socket.assigns.term)
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

  defp enumerate(list, _opts) when is_list(list) do
    for {value, index} <- Enum.with_index(list), do: {inspect(index), index, value}
  end

  defp enumerate(map, opts) when is_map(map) do
    case opts[:map_keys] do
      :all ->
        for {key, index} <- Enum.with_index(Map.keys(map)),
            key != :__struct__,
            do: {inspect(index), key, Map.fetch!(map, key)}

      _else ->
        for {key, index} <- Enum.with_index(Map.keys(map)),
            not (is_atom(key) and String.starts_with?(to_string(key), "_")),
            do: {inspect(index), key, Map.fetch!(map, key)}
    end
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
