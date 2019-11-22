defmodule Favro.Task do
  @moduledoc """
  Represents a single Task as part of a Task List
  """

  defstruct id:               nil,
            task_list_id:     nil,
            card_id:          nil,
            organization_id:  nil,
            name:             "",
            completed:        false,
            position:         0

  @doc """
  Get a list of all tasks that satisfy the given query constraints
  """
  def list,
    do: list([])
  def list(opts) when is_list(opts),
    do: list(Favro.new(), opts)
  def list(%Favro{} = handle),
    do: list(handle, [])
  def list(%Favro{} = handle, opts) when is_list(opts),
    do: Favro.Request.list(handle, "/api/v1/tasks" <> build_query(%{}, opts), %Favro.Task{})

  @doc """
  Create a new Favro task.
  """
  def create(%Favro{} = handle, %Favro.Task{} = task),
    do: Favro.Request.create(handle, "/api/v1/tasks", task)

  @doc false
  defp build_query(params, [{:card, id} | t]),
    do: build_query(Map.put(params, "cardCommonId", id), t)
  defp build_query(params, [{:task_list, id} | t]),
    do: build_query(Map.put(params, "taskListId", id), t)
  defp build_query(params, []) when is_map(params) and map_size(params) == 0,
    do: ""
  defp build_query(params, []) when is_map(params) and map_size(params) > 0,
    do: "?" <> URI.encode_query(params)
  defp build_query(params, [_ | t]),
    do: build_query(params, t)

  defimpl Favro.Serializable, for: Favro.Task do
    def to_map(%Favro.Task{task_list_id: nil, name: name, completed: completed}) do
      Map.new()
      |> Map.put("name",      name)
      |> Map.put("completed", completed)
    end
    def to_map(%Favro.Task{task_list_id: id, name: name, position: position, completed: completed}) do
      Map.new()
      |> Map.put("taskListId",  id)
      |> Map.put("name",        name)
      |> Map.put("position",    position)
      |> Map.put("completed",   completed)
    end

    def from_map(%Favro.Task{} = task, map) do
      task
      |> Map.put(:id,               Map.get(map, "taskId"))
      |> Map.put(:task_list_id,     Map.get(map, "taskListId"))
      |> Map.put(:card_id,          Map.get(map, "cardCommonId"))
      |> Map.put(:organization_id,  Map.get(map, "organizationId"))
      |> Map.put(:name,             Map.get(map, "name", ""))
      |> Map.put(:completed,        Map.get(map, "completed", false))
      |> Map.put(:position,         Map.get(map, "position", 0))
    end
  end
end
