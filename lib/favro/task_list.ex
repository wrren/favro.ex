defmodule Favro.TaskList do
  @doc """
  Represents a single Task List that's part of a card
  """
  defstruct id:               nil,
            card_id:          nil,
            organization_id:  nil,
            name:             "",
            position:         0,
            tasks:            []

  @doc """
  Get a list of all task lists that satisfy the given query constraints
  """
  def list,
    do: list([])
  def list(opts) when is_list(opts),
    do: list(Favro.new(), opts)
  def list(%Favro{} = handle),
    do: list(handle, [])
  def list(%Favro{} = handle, opts) when is_list(opts),
    do: Favro.Request.list(handle, "/api/v1/tasklists" <> build_query(%{}, opts), %Favro.TaskList{})

  @doc """
  Create a new Favro task list.
  """
  def create(%Favro{} = handle, %Favro.TaskList{} = task),
    do: Favro.Request.create(handle, "/api/v1/tasklists", task)

  @doc false
  defp build_query(params, [{:card, id} | t]),
    do: build_query(Map.put(params, "cardCommonId", id), t)
  defp build_query(params, []) when is_map(params) and map_size(params) == 0,
    do: ""
  defp build_query(params, []) when is_map(params) and map_size(params) > 0,
    do: "?" <> URI.encode_query(params)
  defp build_query(params, [_ | t]),
    do: build_query(params, t)

  defimpl Favro.Serializable, for: Favro.TaskList do
    def to_map(%Favro.TaskList{card_id: nil, name: name, tasks: tasks}) do
      Map.new()
      |> Map.put("name",          name)
      |> Map.put("tasks",         Enum.map(tasks, &Favro.Serializable.to_map/1))
    end
    def to_map(%Favro.TaskList{card_id: card, name: name, position: position}) do
      Map.new()
      |> Map.put("cardCommonId",  card)
      |> Map.put("name",          name)
      |> Map.put("position",      position)
    end
    def from_map(%Favro.TaskList{} = list, map) do
      list
      |> Map.put(:id,                 Map.get(map, "taskListId"))
      |> Map.put(:card_id,            Map.get(map, "cardCommonId"))
      |> Map.put(:organization_id,    Map.get(map, "organizationId"))
      |> Map.put(:name,               Map.get(map, "description",   ""))
      |> Map.put(:position,           Map.get(map, "position", 0))
    end
  end
end
