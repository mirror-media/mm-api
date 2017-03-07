defmodule PollApi.PollTest do
  use PollApi.ModelCase

  alias PollApi.Poll

  @valid_attrs %{desired_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, qa_id: "some content", status: "some content", subtitle: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Poll.changeset(%Poll{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Poll.changeset(%Poll{}, @invalid_attrs)
    refute changeset.valid?
  end
end
