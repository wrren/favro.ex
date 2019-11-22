defmodule Favro.Request do

  @doc """
  List entities of the given type
  """
  def list(%Favro{organization: org} = handle, path, struct) do
    with  {:ok, %{body: body}}  <- request(handle, :get, path, [organizationId: org]),
          {:ok, response}       <- decode_json(body),
          {:ok, entities}       <- traverse_result_pages(handle, response, path, struct, []) do
      {:ok, entities}
    end
  end

  @doc """
  Make a request against the Favro API
  """
  def request(%Favro{mock: mock, hostname: hostname, username: username, password: password}, method, path, headers, body \\ %{}) do
    with  {:mock, nil}        <- {:mock, Map.get(mock, path)},
          headers             <- [{"Content-Type", "application/json"} | headers],
          opts                <- [hackney: [basic_auth: {username, password}]],
          {:ok, response}     <- HTTPoison.request(method, URI.merge(hostname, path), encode_json!(body), headers, opts),
          {:status, _, status} when status >= 200 and status <= 300 <- {:status, response, response.status_code} do
      {:ok, response}
    else
      {:mock, response} ->
        {:ok, response}
      {:error, reason} ->
        {:error, reason}
      {:status, response, status} ->
        {:error, "Server responded with status code #{status}: #{inspect response}"}
    end
  end

  @doc """
  Create an entity
  """
  def create(%Favro{organization: org} = handle, path, entity) do
    with  {:ok, %{body: body}}  <- request(handle, :post, path, [organizationId: org], Favro.Serializable.to_map(entity)),
          {:ok, map}            <- decode_json(body),
          result                <- Favro.Serializable.from_map(entity, map) do
      {:ok, result}
    end
  end

  @doc false
  defp traverse_result_pages(%Favro{}, %{"entities" => entities, "page" => page, "pages" => page}, _path, struct, out),
    do: {:ok, Enum.concat(out, Enum.map(entities, fn e -> Favro.Serializable.from_map(struct, e) end))}
  defp traverse_result_pages(%Favro{organization: org} = handle, %{"entities" => entities, "page" => page, "pages" => _, "requestId" => id}, path, struct, out) do
    with  out                   <- Enum.concat(out, Enum.map(entities, fn e -> Favro.Serializable.from_map(struct, e) end)),
          {:ok, %{body: body}}  <- request(handle, :get, add_query_params(path, %{"page" => page + 1, "requestId" => id}), [organizationId: org]),
          {:ok, response}       <- decode_json(body) do
      traverse_result_pages(handle, response, path, struct, out)
    end
  end

  @doc false
  defp add_query_params(path, params) do
    case String.split(path, "?") do
      [path] ->
        path <> "?" <> URI.encode_query(params)
      [path, query] ->
        path <> "?" <> URI.encode_query(Map.merge(URI.decode_query(query), params))
    end
  end

  @doc """
  Mock the response for a specific path
  """
  def mock(%Favro{mock: mock} = handle, path, response),
    do: %{handle | mock: Map.put(mock, path, response)}

  @doc """
  Decode a datetime field into a NaiveDateTime struct
  """
  def decode_datetime(nil),
    do: nil
  def decode_datetime(""),
    do: nil
  def decode_datetime(bin) do
    case NaiveDateTime.from_iso8601(bin) do
      {:ok, dt} -> dt
      _         -> nil
    end
  end

  @doc """
  Decode a JSON payload using the JSON decoder module set in the Application config, defaults to
  the Jason decoder.
  """
  def decode_json(payload),
    do: Keyword.get(Application.get_all_env(:favro), :json_decode, Jason).decode(payload)
  def decode_json!(payload),
    do: Keyword.get(Application.get_all_env(:favro), :json_decode, Jason).decode!(payload)

  @doc """
  Encode a JSON payload using the JSON encoder module set in the Application config, defaults to
  the Jason encoder.
  """
  def encode_json(payload),
    do: Keyword.get(Application.get_all_env(:favro), :json_decode, Jason).encode(payload)
  def encode_json!(payload),
    do: Keyword.get(Application.get_all_env(:favro), :json_decode, Jason).encode!(payload)

  @doc """
  Filters nil values from the given map
  """
  def filter_nil(map) when is_map(map) do
    map
    |> Enum.filter(fn {_, nil} -> false; _ -> true end)
    |> Map.new
  end
end
