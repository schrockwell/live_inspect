defmodule LiveInspect.Theme.Light do
  @moduledoc """
  The default theme, for designs with light backgrounds.

  ## Configuration

      config :live_inspect, theme: LiveInspect.Theme.Light
  """
  use LiveInspect.Theme.Base

  @impl true
  def style do
    """
    .live-inspect-root {
      font-size: 0.9rem;
      font-family: monospace;
    }

    .live-inspect-table td,
    .live-inspect-table th {
      border-collapse: collapse;
      border: 1px solid #999;
      padding: 0.25rem;
      text-align: left;
      vertical-align: top;
    }

    .live-inspect-table th {
      -moz-user-select: none;
      -ms-user-select: none;
      -webkit-user-select: none;
      background-color: #ddd;
      cursor: pointer;
      font-weight: bold;
      user-select: none;
    }

    .live-inspect-table td {
      background-color: #fff;
    }

    .live-inspect-table th:hover {
      background-color: #bbb;
    }

    .live-inspect-atom { color: #000; }
    .live-inspect-binary { color: #00e; }
    .live-inspect-list { color: #a0a; }
    .live-inspect-map { color: #0a0; }
    .live-inspect-number { color: #e00; }
    .live-inspect-other { color: #000; }
    .live-inspect-pid { color: #000; }
    .live-inspect-struct { color: #0aa; }
    .live-inspect-tuple { color: #aa0; }
    """
  end
end
