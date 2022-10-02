defmodule LiveInspect do
  use Phoenix.Component

  def live_inspect(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "live-inspect" end)
      |> assign_new(:value, fn -> Map.drop(assigns, [:id, :__changed__]) end)

    ~H"""
    <.live_component id={@id} module={LiveInspect.Inspector} root?={true} value={@value} />
    """
  end
end
