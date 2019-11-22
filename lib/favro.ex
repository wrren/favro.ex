defmodule Favro do
  @moduledoc """
  Provides functions for querying the Favro API
  """
  alias Favro.{
    Card,
    Column,
    Widget,
    Task,
    TaskList,
    Tag
  }

  defstruct username:     "",
            password:     "",
            hostname:     "",
            organization: "",
            mock:         Map.new()

  @default_host "https://favro.com/"

  @doc """
  Create a new Favro handle
  """
  def new do
    config = Application.get_all_env(:favro)
    new(
      config[:username]     || "",
      config[:password]     || "",
      config[:organization] || "",
      config[:hostname]     || @default_host
    )
  end
  def new(username, password, organization, hostname \\ @default_host) do
    %Favro{username: username, password: password, organization: organization, hostname: hostname}
  end

  @doc """
  List Favro widgets, optionally filtering using a set of query options.

  ## Options

      * `:collection` - Return only widgets from the collection with the specified ID
  """
  defdelegate list_widgets,
    to: Widget, as: :list
  defdelegate list_widgets(handle_or_opts),
    to: Widget, as: :list
  defdelegate list_widgets(handle, opts),
    to: Widget, as: :list

  @doc """
  Create a new widget
  """
  def create_widget(widget),
    do: Widget.create(new(), widget)
  defdelegate create_widget(handle, widget),
    to: Widget, as: :create

  @doc """
  List Favro cards, optionally filtering using a set of query options.

  ## Options

    * `:collection` - Return only cards from the collection with the specified ID

    * `:widget` - Return only cards from the widget with the specified ID

    * `:column` - Return only cards from the column with the specified ID

    * `:archived` - If true, only returns cards that have been archived

    * `:unique` - If true, only returns unique cards
  """
  defdelegate list_cards,
    to: Card, as: :list
  defdelegate list_cards(handle_or_opts),
    to: Card, as: :list
  defdelegate list_cards(handle, opts),
    to: Card, as: :list

  @doc """
  Create a new Card
  """
  def create_card(card),
    do: Card.create(new(), card)
  defdelegate create_card(handle, card),
    to: Card, as: :create

  @doc """
  List Favro columns, optionally filtering using a set of query options.

  ## Options

    * `:widget` - Return only columns from the widget with the specified ID
  """
  defdelegate list_columns,
    to: Column, as: :list
  defdelegate list_columns(handle_or_opts),
    to: Column, as: :list
  defdelegate list_columns(handle, opts),
    to: Column, as: :list

  @doc """
  Create a new column
  """
  def create_column(column),
    do: Column.create(new(), column)
  defdelegate create_column(handle, column),
    to: Column, as: :create

  @doc """
  List Favro tags, optionally filtering using a set of query options.

  ## Options

    * `:name` - Return only tags with this name
  """
  defdelegate list_tags,
    to: Tag, as: :list
  defdelegate list_tags(handle_or_opts),
    to: Tag, as: :list
  defdelegate list_tags(handle, opts),
    to: Tag, as: :list

  @doc """
  Create a new Tag
  """
  def create_tag(tag),
    do: Tag.create(new(), tag)
  defdelegate create_tag(handle, tag),
    to: Tag, as: :create

  @doc """
  List Favro tasks, optionally filtering using a set of query options.

  ## Options

    * `:card` - Return only tasks from the card with the given ID

    * `:task_list` - Return only tasks from the task list with the given ID
  """
  defdelegate list_tasks,
    to: Task, as: :list
  defdelegate list_tasks(handle_or_opts),
    to: Task, as: :list
  defdelegate list_tasks(handle, opts),
    to: Task, as: :list

  @doc """
  Create a new task
  """
  def create_task(task),
    do: Task.create(new(), task)
  defdelegate create_task(handle, task),
    to: Task, as: :create

  @doc """
  List Favro task lists, optionally filtering using a set of query options.

  ## Options

      * `:card` - Return only task lists from the card with the given ID
  """
  defdelegate list_task_lists,
    to: TaskList, as: :list
  defdelegate list_task_lists(handle_or_opts),
    to: TaskList, as: :list
  defdelegate list_task_lists(handle, opts),
    to: TaskList, as: :list

  @doc """
  Create a new task list
  """
  def create_task_list(task_list),
    do: TaskList.create(new(), task_list)
  defdelegate create_task_list(handle, task_list),
    to: TaskList, as: :create
end
