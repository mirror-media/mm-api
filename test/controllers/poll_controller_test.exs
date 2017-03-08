defmodule MmApi.PollControllerTest do
  use MmApi.ConnCase

  alias MmApi.Poll
  @valid_attrs %{desired_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, qa_id: "some content", status: "some content", subtitle: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, poll_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = get conn, poll_path(conn, :show, poll)
    assert json_response(conn, 200)["data"] == %{"id" => poll.id,
      "title" => poll.title,
      "subtitle" => poll.subtitle,
      "qa_id" => poll.qa_id,
      "status" => poll.status,
      "desired_time" => poll.desired_time}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, poll_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, poll_path(conn, :create), poll: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Poll, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, poll_path(conn, :create), poll: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = put conn, poll_path(conn, :update, poll), poll: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Poll, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = put conn, poll_path(conn, :update, poll), poll: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = delete conn, poll_path(conn, :delete, poll)
    assert response(conn, 204)
    refute Repo.get(Poll, poll.id)
  end
end
