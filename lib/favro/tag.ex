defmodule Favro.Tag do
  @moduledoc """
  Represents an organization-level tag
  """
  defstruct id:               nil,
            organization_id:  nil,
            name:             "",
            color:            ""

  @doc """
  Get a list of all tags that satisfy the given query constraints
  """
  def list,
    do: list([])
  def list(opts) when is_list(opts),
    do: list(Favro.new(), opts)
  def list(%Favro{} = handle),
    do: list(handle, [])
  def list(%Favro{} = handle, opts) when is_list(opts),
    do: Favro.Request.list(handle, "/api/v1/tags" <> build_query(%{}, opts), %Favro.Tag{})

  @doc """
  Create a new Favro task list.
  """
  def create(%Favro{} = handle, %Favro.Tag{} = task),
    do: Favro.Request.create(handle, "/api/v1/tags", task)

  @doc false
  defp build_query(params, [{:name, name} | t]),
    do: build_query(Map.put(params, "name", name), t)
  defp build_query(params, []) when is_map(params) and map_size(params) == 0,
    do: ""
  defp build_query(params, []) when is_map(params) and map_size(params) > 0,
    do: "?" <> URI.encode_query(params)
  defp build_query(params, [_ | t]),
    do: build_query(params, t)

  defimpl Favro.Serializable, for: Favro.Tag do
    def to_map(%Favro.Tag{name: name, color: color}) do
      %{"name" => name, "color" => color}
    end

    def from_map(%Favro.Tag{} = tag, id) when is_binary(id),
      do: %{tag | id: id}
    def from_map(%Favro.Tag{} = tag, %{"tagId" => id, "organizationId" => org, "name" => name, "color" => color}) do
      %{tag | id: id, organization_id: org, name: name, color: color}
    end
  end
end
