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
  List Favro cards, optionally filtering using a set of query options.
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
  defdelegate create_card(handle, card),
    to: Favro.Card, as: :create

  @doc """
  List Favro columns, optionally filtering using a set of query options.
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
  defdelegate create_column(handle, column),
    to: Favro.Column, as: :create

  @doc """
  List Favro widgets, optionally filtering using a set of query options.
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
  defdelegate create_widget(handle, widget),
    to: Widget, as: :create

  @doc """
  List Favro tags, optionally filtering using a set of query options.
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
  defdelegate create_tag(handle, tag),
    to: Tag, as: :create

  @doc """
  List Favro tasks, optionally filtering using a set of query options.
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
  defdelegate create_task(handle, task),
    to: Task, as: :create

  @doc """
  List Favro task lists, optionally filtering using a set of query options.
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
  defdelegate create_task_list(handle, task_list),
    to: TaskList, as: :create
end
