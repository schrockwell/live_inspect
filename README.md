# LiveInspect

Inspect LiveView assigns directly in the browser.

## Example

```heex
<LiveInspect.live_inspect context={@context} my_alerts={@my_alerts} />
```

Maps and lists are collapsed by default, but can be clicked to expand and dig deeper.

![Example usage](priv/example.png)

## Installation

LiveInspect is a developer tool that should _never_ be used in a production environment, so be sure
to specify the `:only` option when adding it to your deps in `mix.exs`:

```elixir
def deps do
  [
    # IMPORTANT: Only in :dev environment!
    {:live_inspect, "~> 0.1.0", only: :dev}
  ]
end
```
