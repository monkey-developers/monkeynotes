defmodule MonkeynoteWeb.NoteLiveTest do
  use MonkeynoteWeb.ConnCase

  import Phoenix.LiveViewTest
  import Monkeynote.NotebooksFixtures

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  defp create_note(_) do
    note = note_fixture()
    %{note: note}
  end

  describe "Index" do
    setup [:create_note]

    test "lists all notes", %{conn: conn, note: note} do
      {:ok, _index_live, html} = live(conn, Routes.note_index_path(conn, :index))

      assert html =~ "Listing Notes"
      assert html =~ note.body
    end

    test "saves new note", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.note_index_path(conn, :index))

      assert index_live |> element("a", "New Note") |> render_click() =~
               "New Note"

      assert_patch(index_live, Routes.note_index_path(conn, :new))

      assert index_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#note-form", note: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.note_index_path(conn, :index))

      assert html =~ "Note created successfully"
      assert html =~ "some body"
    end

    test "updates note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, Routes.note_index_path(conn, :index))

      assert index_live |> element("#note-#{note.id} a", "Edit") |> render_click() =~
               "Edit Note"

      assert_patch(index_live, Routes.note_index_path(conn, :edit, note))

      assert index_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#note-form", note: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.note_index_path(conn, :index))

      assert html =~ "Note updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, Routes.note_index_path(conn, :index))

      assert index_live |> element("#note-#{note.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#note-#{note.id}")
    end
  end

  describe "Show" do
    setup [:create_note]

    test "displays note", %{conn: conn, note: note} do
      {:ok, _show_live, html} = live(conn, Routes.note_show_path(conn, :show, note))

      assert html =~ "Show Note"
      assert html =~ note.body
    end

    test "updates note within modal", %{conn: conn, note: note} do
      {:ok, show_live, _html} = live(conn, Routes.note_show_path(conn, :show, note))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Note"

      assert_patch(show_live, Routes.note_show_path(conn, :edit, note))

      assert show_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#note-form", note: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.note_show_path(conn, :show, note))

      assert html =~ "Note updated successfully"
      assert html =~ "some updated body"
    end
  end
end
