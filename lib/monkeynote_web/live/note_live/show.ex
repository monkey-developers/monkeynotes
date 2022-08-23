defmodule MonkeynoteWeb.NoteLive.Show do
  use MonkeynoteWeb, :live_view

  alias Monkeynote.Notebooks

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Notebooks.subscribe()
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:note, Notebooks.get_note!(id))}
  end

  @impl true
  def handle_info({:note_updated, note}, socket) do
    {:noreply, socket |> assign(:note, note)}
  end

  defp page_title(:show), do: "Show Note"
  defp page_title(:edit), do: "Edit Note"
end
