defmodule MmApi.PollView do
  use MmApi.Web, :view
  
  def render("index.json", %{polls: polls}) do
    %{result: polls}
  end
#  def render("index.json", %{polls: polls}) do
#    %{data: render_many(polls, MmApi.PollView, "poll.json")}
#  end

#  def render("show.json", %{poll: poll}) do
#    %{data: render_one(poll, MmApi.PollView, "poll.json")}
#  end

#  def render("poll.json", %{poll: poll}) do
#    %{id: poll.id,
#      title: poll.title,
#      subtitle: poll.subtitle,
#      qa_id: poll.qa_id,
#      status: poll.status,
#      desired_time: poll.desired_time}
#  end
end
