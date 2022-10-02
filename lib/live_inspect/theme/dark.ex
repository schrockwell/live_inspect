defmodule LiveInspect.Theme.Dark do
  @moduledoc """
  An alternative theme, for designs with dark backgrounds.

  ## Configuration

      config :live_inspect, theme: LiveInspect.Theme.Dark
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
      border: 1px solid #555;
      padding: 0.25rem;
      text-align: left;
      vertical-align: top;
    }

    .live-inspect-table th {
      -moz-user-select: none;
      -ms-user-select: none;
      -webkit-user-select: none;
      background-color: #000;
      cursor: pointer;
      font-weight: bold;
      user-select: none;
    }

    .live-inspect-table td {
      background-color: #333;
    }

    .live-inspect-table th:hover {
      background-color: #222;
    }

    .live-inspect-atom { color: #ccc; }
    .live-inspect-binary { color: #4FC1FF; }
    .live-inspect-list { color: #f0f; }
    .live-inspect-map { color: #0a0; }
    .live-inspect-number { color: #f33; }
    .live-inspect-other { color: #ccc; }
    .live-inspect-pid { color: #ccc; }
    .live-inspect-struct { color: #0bb; }
    .live-inspect-tuple { color: #bb0; }
    """
  end
end
