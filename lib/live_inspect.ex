defmodule LiveInspect do
  @moduledoc """
  Inspect LiveView assigns directly in the browser.

  ## Installation

  LiveInspect is a developer tool that should _never_ be used in a production environment, so be sure
  to specify the `:only` option when adding it to your deps in `mix.exs`:

      def deps do
        [
          {:live_inspect, "~> 0.1.0", only: :dev}
        ]
      end


  Then, import `LiveInspect.live_inspect/1` into the generated Phoenix helpers:

      # lib/my_app_web.ex
      defmodule MyAppWeb do
        def live_view do
          quote do
            # ...generated code...

            unquote(live_inspect())
          end
        end

        def live_component do
          quote do
            # ...generated code...

            unquote(live_inspect())
          end
        end

        defp live_inspect do
          if Mix.env() == :dev do
            quote do
              import LiveInspect, only: [live_inspect: 1]
            end
          end
        end
      end

  ## Usage

  Just call the `live_inspect/1` function component with any values to examine.

      <.live_inspect my_assign={@my_assign} my_other_assign={@my_other_assign} />

  All assigns can be inspected at once, e.g.

      <.live_inspect {assigns} />

  ## Configuration

      # Default configuration
      config :live_inspect, theme: LiveInspect.Theme.Light

  ### Themes

  The styling of the inspector is controlled via themes. Two themes are provided with the library:

    - `LiveInspect.Theme.Light` (default)
    - `LiveInspect.Theme.Dark`

  See `LiveInspect.Theme` to implement a custom theme.
  """

  use Phoenix.Component

  @doc """
  Function component wrapper for the `LiveInspect.Inspector` component.

  ## Example

      <.live_inspect my_assign={@my_assign} my_other_assign={@my_other_assign} />

  ## Attributes

    - `__id__` - optional; the `id` of the `LiveInspect.Inspector` component; defaults to `"live-inspect"`

  All other assigns are put into a map and passed as the `value` attribute to `LiveInspect.Inspector`.
  """
  def live_inspect(assigns) do
    assigns =
      assigns
      |> assign_new(:__id__, fn -> "live-inspect" end)
      |> assign_new(:__value__, fn -> Map.drop(assigns, [:__id__, :__changed__]) end)

    ~H"""
    <.live_component module={LiveInspect.Inspector} id={@__id__} value={@__value__} />
    """
  end
end
