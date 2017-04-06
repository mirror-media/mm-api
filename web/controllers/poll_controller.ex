defmodule MmApi.PollController do
  use MmApi.Web, :controller

  #alias MmApi.Poll

  def index(conn, _params) do
    IO.puts("index") 
    #IO.puts( Application.get_env(:mm_api, MmApi.Endpoint)[:redix_args] )
    {:ok, name} = Redis.command(~w(GET name)) 
    
    
    IO.puts("name: #{name}") 
    conn |> send_resp(200, name)
    #polls = Repo.all(Poll)
    #render(conn, "index.json", polls: polls)
  end

"""
  def create(conn, %{"poll" => poll_params}) do

    changeset = Poll.changeset(%Poll{}, poll_params)

    case Repo.insert(changeset) do
      {:ok, poll} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", poll_path(conn, :show, poll))
        |> render("show.json", poll: poll)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MmApi.ChangesetView, "error.json", changeset: changeset)
    end

  end
"""
  def show(conn, %{"id" => qa_id}) do
    #poll = Repo.get!(Poll, id)
    """
    poll = Repo.get_by!(Poll, qa_id: qa_id)
    render(conn, "show.json", poll: poll)
  end

  def update(conn, %{"id" => qa_id, "poll" => poll_params}) do
    poll = Repo.get_by!(Poll, qa_id: qa_id)
    changeset = Poll.changeset(poll, poll_params)

    case Repo.update(changeset) do
      {:ok, poll} ->
        render(conn, "show.json", poll: poll)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MmApi.ChangesetView, "error.json", changeset: changeset)
    end
    """
  end
"""
  def delete(conn, %{"id" => qa_id}) do
    poll = Repo.get_by!(Poll, qa_id: qa_id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(poll)

    send_resp(conn, :no_content, "")
  end
"""
end
