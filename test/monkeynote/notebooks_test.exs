defmodule Monkeynote.NotebooksTest do
  use Monkeynote.DataCase

  alias Monkeynote.Notebooks

  describe "notes" do
    alias Monkeynote.Notebooks.Note

    import Monkeynote.NotebooksFixtures

    @invalid_attrs %{body: nil, title: nil}

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Notebooks.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Notebooks.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      valid_attrs = %{body: "some body", title: "some title"}

      assert {:ok, %Note{} = note} = Notebooks.create_note(valid_attrs)
      assert note.body == "some body"
      assert note.title == "some title"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notebooks.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      update_attrs = %{body: "some updated body", title: "some updated title"}

      assert {:ok, %Note{} = note} = Notebooks.update_note(note, update_attrs)
      assert note.body == "some updated body"
      assert note.title == "some updated title"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Notebooks.update_note(note, @invalid_attrs)
      assert note == Notebooks.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Notebooks.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Notebooks.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Notebooks.change_note(note)
    end
  end
end
