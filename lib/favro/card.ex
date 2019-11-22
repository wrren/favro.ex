defmodule Favro.Card do
  @moduledoc """
  Represents a Favro Card within a collection
  """

  defstruct id:                   nil,
            widget_id:            nil,
            column_id:            nil,
            archived:             false,
            name:                 "",
            description:          "",
            task_lists:           [],
            tags:                 [],
            start_date:           nil,
            due_date:             nil,
            time_on_board:        0,
            time_on_columns:      %{},
            custom:               []

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
    do: Favro.Request.list(handle, "/api/v1/cards" <> build_query(%{}, opts), %Favro.Card{})

  @doc """
  Create a new Favro card. The card must include a valid widget ID specifying the widget to which it will be attached
  """
  def create(%Favro{} = handle, %Favro.Card{} = card),
    do: Favro.Request.create(handle, "/api/v1/cards", card)

  @doc false
  defp build_query(params, [{:collection, id} | t]),
    do: build_query(Map.put(params, "collectionId", id), t)
  defp build_query(params, [{:archived, id} | t]),
    do: build_query(Map.put(params, "archived", id), t)
  defp build_query(params, []) when is_map(params) and map_size(params) == 0,
    do: ""
  defp build_query(params, []) when is_map(params) and map_size(params) > 0,
    do: "?" <> URI.encode_query(params)
  defp build_query(params, [_ | t]),
    do: build_query(params, t)

  defimpl Favro.Serializable, for: Favro.Card do
    def to_map(%Favro.Card{tags: tags, task_lists: tasks, widget_id: widget} = card) when widget != nil do
      Map.new
      |> Map.put("widgetCommonId",        widget)
      |> Map.put("columnId",              Map.get(card,   :column_id,     nil))
      |> Map.put("name",                  Map.get(card,   :name,          ""))
      |> Map.put("detailedDescription",   Map.get(card,   :description,   ""))
      |> Map.put("tags",                  Enum.map(tags,  &Favro.Serializable.to_map/1))
      |> Map.put("tasklists",             Enum.map(tasks, &Favro.Serializable.to_map/1))
      |> Map.put("startDate",             Map.get(card, :start_date, nil))
      |> Map.put("dueDate",               Map.get(card, :due_date, nil))
      |> Favro.Request.filter_nil()
    end

    def from_map(%Favro.Card{} = card, map) do
      card
      |> Map.put(:id,               Map.get(map, "cardId"))
      |> Map.put(:widget_id,        Map.get(map, "widgetCommonId"))
      |> Map.put(:column_id,        Map.get(map, "columnId"))
      |> Map.put(:name,             Map.get(map, "name",                ""))
      |> Map.put(:description,      Map.get(map, "detailedDescription", ""))
      |> Map.put(:tags,             Enum.map(Map.get(map, "tags", []), fn tag ->
        Favro.Serializable.from_map(%Favro.Tag{}, tag)
      end))
      |> Map.put(:start_date,       Favro.Request.decode_datetime(Map.get(map, "startDate", "")))
      |> Map.put(:due_date,         Favro.Request.decode_datetime(Map.get(map, "dueDate", "")))
      |> Map.put(:time_on_board,    Map.get(map, "timeOnBoard", 0))
      |> Map.put(:time_on_columns,  Map.get(map, "timeOnColumns", %{}))
      |> Map.put(:custom,           Map.get(map, "customFields", []))
    end
  end

end
