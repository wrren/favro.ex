defprotocol Favro.Serializable do
  @moduledoc """
  Describes a basic protocol for converting structs to and from maps
  """

  @doc """
  Convert a struct to a map suitable for JSON serialization
  """
  def to_map(struct)

  @doc """
  Convert a map into a struct
  """
  def from_map(struct, map)
end
