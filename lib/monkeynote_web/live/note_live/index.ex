defmodule MonkeynoteWeb.NoteLive.Index do
  use MonkeynoteWeb, :live_view

  alias Monkeynote.Notebooks
  alias Monkeynote.Notebooks.Note

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Notebooks.subscribe()
    {:ok, assign(socket, :notes, list_notes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, Notebooks.get_note!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, %Note{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notes")
    |> assign(:note, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Notebooks.get_note!(id)
    {:ok, _} = Notebooks.delete_note(note)

    {:noreply, assign(socket, :notes, list_notes())}
  end

  @impl true
  def handle_info({:note_created, note}, socket) do
    {:noreply, update(socket, :notes, fn notes -> [note | notes] end)}
  end

  @impl true
  def handle_info({:note_updated, note}, socket) do
    {:noreply, update(socket, :notes, fn notes -> [notes] end)}
  end

  @impl true
  def handle_info({:note_deleted, _note}, socket) do
    {:noreply, update(socket, :notes, fn notes -> [notes] end)}
  end

  defp list_notes do
    Notebooks.list_notes()
  end
end
