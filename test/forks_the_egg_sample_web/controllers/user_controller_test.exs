defmodule ForksTheEggSampleWeb.UserControllerTest do
  use ForksTheEggSampleWeb.ConnCase

  import ForksTheEggSampleWeb.AuthCase
  alias ForksTheEggSample.Accounts

  @create_attrs %{email: "bill@mail.com", password: "hard2guess"}
  @update_attrs %{email: "william@mail.com"}
  @invalid_attrs %{email: nil}

  setup %{conn: conn} = config do
    conn = conn |> bypass_through(ForksTheEggSampleWeb.Router, [:browser]) |> get("/")
    if email = config[:login] do
      user = add_user(email)
      other = add_user("tony@mail.com")
      conn = conn |> put_session(:user_id, user.id) |> send_resp(:ok, "/")
      {:ok, %{conn: conn, user: user, other: other}}
    else
      {:ok, %{conn: conn}}
    end
  end

  @tag login: "reg@mail.com"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Users"
  end

  test "renders /users error for unauthorized user", %{conn: conn}  do
    conn = get conn, user_path(conn, :index)
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "renders form for new users", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New User"
  end

  @tag login: "reg"
  test "show chosen user's page", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show User"
  end

  test "creates user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New User"
  end

  @tag login: "reg@mail.com"
  test "renders form for editing chosen user", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit User"
  end

  @tag login: "reg@mail.com"
  test "updates chosen user when data is valid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @update_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    updated_user = Accounts.get(user.id)
    assert updated_user.email == "william@mail.com"
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "william@mail.com"
  end

  @tag login: "reg@mail.com"
  test "does not update chosen user and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit User"
  end

  @tag login: "reg@mail.com"
  test "deletes chosen user", %{conn: conn, user: user} do
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == session_path(conn, :new)
    refute Accounts.get(user.id)
  end

  @tag login: "reg@mail.com"
  test "cannot delete other user", %{conn: conn, other: other} do
    conn = delete conn, user_path(conn, :delete, other)
    assert redirected_to(conn) == user_path(conn, :index)
    assert Accounts.get(other.id)
  end
end
