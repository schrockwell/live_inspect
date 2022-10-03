defmodule LiveInspect do
  @moduledoc """
  Inspect LiveView assigns directly in the browser.

  ## Installation

  LiveInspect is a developer tool that should _never_ be used in a production environment, so be sure
  to specify the `:only` option when adding it to your deps in `mix.exs`:

      def deps do
        [
          {:live_inspect, "~> 0.2", only: :dev}
        ]
      end


  Then, import `LiveInspect.live_inspect/1` into the generated Phoenix helpers, again being careful
  to only import it in the `:dev` environment:

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

  See `live_inspect/1` for examples.

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
  Inspect a value directly in the browser.

  ## Examples

  ```heex
  <.live_inspect term={assigns} />
  <.live_inspect term={@my_assign} />
  <.live_inspect term={%{my_assign: @my_assign, my_other_assign: @my_other_assign}} />
  ```

  ## Required Attributes

    - `term` - the value to inspect

  ## Optional Attributes

    - `opts` - a keyword list of options (see below); defaults to `[]`
    - `theme` - the theme module; defaults to the configured theme
    - `unique` - a string-encodable value to ensure uniqueness of the LiveComponent `id` within the LiveView

  ### Options (`opts` attribute)

    - `:map_keys` - specify `:all` to render all map fields; defaults to `:default`, which excludes
      atom keys beginning with an underscore

  """
  @spec live_inspect(Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def live_inspect(assigns) do
    assigns =
      assigns
      |> assign_new(:id, &default_id/1)
      |> assign_new(:theme, fn -> default_theme() end)
      |> assign_new(:opts, fn -> [] end)

    ~H"""
    <.live_component module={LiveInspect.Inspector} opts={@opts} id={@id} term={@term} theme={@theme} />
    """
  end

  defp default_id(assigns) do
    case Map.fetch(assigns, :unique) do
      {:ok, suffix} -> "live-inspect-#{suffix}"
      :error -> "live-inspect"
    end
  end

  defp default_theme do
    Application.get_env(:live_inspect, :theme, LiveInspect.Theme.Light)
  end
end
