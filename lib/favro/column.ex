defmodule Favro.Column do
  @moduledoc """
  Represents a Favro Column within a Widget
  """

  defstruct id:                   nil,
            widget_id:            nil,
            name:                 "",
            position:             0,
            card_count:           0,
            time_sum:             0,
            estimation_sum:       0

  @doc """
  Get a list of all cards that satisfy the given query constraints
  """
  def list,
    do: list([])
  def list(opts) when is_list(opts),
    do: list(Favro.new(), opts)
  def list(%Favro{} = handle),
    do: list(handle, [])
  def list(%Favro{} = handle, opts) when is_list(opts),
    do: Favro.Request.list(handle, "/api/v1/columns" <> build_query(%{}, opts), %Favro.Column{})

  @doc """
  Create a new Favro column.
  """
  def create(%Favro{} = handle, %Favro.Column{} = column),
    do: Favro.Request.create(handle, "/api/v1/columns", column)

  @doc false
  defp build_query(params, [{:widget, id} | t]),
    do: build_query(Map.put(params, "widgetCommonId", id), t)
  defp build_query(params, []) when is_map(params) and map_size(params) == 0,
    do: ""
  defp build_query(params, []) when is_map(params) and map_size(params) > 0,
    do: "?" <> URI.encode_query(params)
  defp build_query(params, [_ | t]),
    do: build_query(params, t)

  defimpl Favro.Serializable, for: Favro.Column do
    def to_map(_widget),
      do: Map.new

    def from_map(%Favro.Column{} = column, map) do
      column
      |> Map.put(:id,             Map.get(map, "columnId", ""))
      |> Map.put(:widget_id,      Map.get(map, "widgetCommonId"))
      |> Map.put(:name,           Map.get(map, "name",  ""))
      |> Map.put(:position,       Map.get(map, "position",  ""))
      |> Map.put(:card_count,     Map.get(map, "cardCount", ""))
      |> Map.put(:time_sum,       Map.get(map, "timeSum", ""))
      |> Map.put(:estimation_sum, Map.get(map, "estimationSum", ""))
    end
  end

end
