# LiveInspect

[![Module Version](https://img.shields.io/hexpm/v/live_inspect.svg)](https://hex.pm/packages/live_inspect)
[![Hex Docs](https://img.shields.io/badge/hex-docs-purple.svg)](https://hexdocs.pm/live_inspect/)
[![License](https://img.shields.io/hexpm/l/live_inspect.svg)](https://github.com/schrockwell/live_inspect/blob/main/LICENSE)

Inspect LiveView assigns directly in the browser.

LiveView 0.17+ is currently supported.

## Example

```heex
<LiveInspect.live_inspect context={@context} my_alerts={@my_alerts} />
```

Maps and lists are collapsed by default, but can be clicked to expand and dig deeper.

![Example usage](assets/example.png)

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
