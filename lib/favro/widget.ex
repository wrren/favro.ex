defmodule Favro.Widget do
  @moduledoc """
  Represents a Favro Widget
  """

  defstruct id:                   nil,
            collection_ids:       [],
            archived:             false,
            name:                 "",
            type:                 "",
            color:                ""

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
    do: Favro.Request.list(handle, "/api/v1/widgets" <> build_query(%{}, opts), %Favro.Widget{})

  @doc """
  Create a new Favro widget.
  """
  def create(%Favro{} = handle, %Favro.Widget{} = widget),
    do: Favro.Request.create(handle, "/api/v1/widgets", widget)

  @doc false
  defp build_query(params, [{:collection, id} | t]),
    do: build_query(Map.put(params, "collectionId", id), t)
  defp build_query(params, []) when is_map(params) and map_size(params) == 0,
    do: ""
  defp build_query(params, []) when is_map(params) and map_size(params) > 0,
    do: "?" <> URI.encode_query(params)
  defp build_query(params, [_ | t]),
    do: build_query(params, t)

  defimpl Favro.Serializable, for: Favro.Widget do
    def to_map(_widget),
      do: Map.new

    def from_map(%Favro.Widget{} = widget, map) do
      widget
      |> Map.put(:id,             Map.get(map, "widgetCommonId", ""))
      |> Map.put(:collection_ids, Map.get(map, "collectionIds", []))
      |> Map.put(:name,           Map.get(map, "name",  ""))
      |> Map.put(:type,           Map.get(map, "type",  ""))
      |> Map.put(:color,          Map.get(map, "color", ""))
    end
  end

end
