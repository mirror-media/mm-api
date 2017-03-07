defmodule PollApi.PollView do
  use PollApi.Web, :view

  def render("index.json", %{polls: polls}) do
    %{data: render_many(polls, PollApi.PollView, "poll.json")}
  end

  def render("show.json", %{poll: poll}) do
    %{data: render_one(poll, PollApi.PollView, "poll.json")}
  end

  def render("poll.json", %{poll: poll}) do
    %{id: poll.id,
      title: poll.title,
      subtitle: poll.subtitle,
      qa_id: poll.qa_id,
      status: poll.status,
      desired_time: poll.desired_time}
  end
end
