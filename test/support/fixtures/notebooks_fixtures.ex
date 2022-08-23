defmodule Monkeynote.NotebooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Monkeynote.Notebooks` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Monkeynote.Notebooks.create_note()

    note
  end
end
