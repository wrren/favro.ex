# Favro

Favro client library for Elixir. Simplifies interactions with the Favro API and automatically
traverses paginated results in order to retrieve all requested data.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `favro` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:favro, "~> 0.1.0"}
  ]
end
```

## Usage

Initialize a new handle using `Favro.new/4`:

```elixir
handle = Favro.new("my_username", "my_api_key", "my_organization_id")
```

Alternatively, set the Application configuration variables corresponding to your organization
ID and credentials:

```elixir
# config.exs

config :favro, [
  username: "my_username",
  password: "my_api_key",
  organization: "my_organization_id"
]
```

All `Favro` module functions accept a handle, or will use a default handle based on the application config.

```elixir
# List Cards
{:ok, cards} = Favro.list_cards(collection: "collection")

# List Archived Cards
{:ok, cards} = Favro.list_cards(collection: "collection", archived: true)

# Create a Card
{:ok, card} = Favro.create_card(%Favro.Card{name: "Card Name", collection_id: "collection"})
```



Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/favro](https://hexdocs.pm/favro).

