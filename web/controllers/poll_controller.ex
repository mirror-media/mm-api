defmodule MmApi.PollController do
  use MmApi.Web, :controller

  #alias MmApi.Poll

  def index(conn, _params) do
    IO.puts("index") 
    {:ok, name} = Redis.command(~w(hgetall party:kmt)) 
    
    name = name |> Enum.chunk(2) |> Enum.into(%{}, fn [key, val] -> {key, val} end)
    name = for {key, val} <- name, into: %{}, do: {String.to_atom(key), val}

    result = %{
      hong: String.to_integer(name[:hong_plus]) - String.to_integer(name[:hong_minus]),
      hao: String.to_integer(name[:hao_plus]) - String.to_integer(name[:hao_minus]),
      wu: String.to_integer(name[:wu_plus]) - String.to_integer(name[:wu_minus]),
      han: String.to_integer(name[:han_plus]) - String.to_integer(name[:han_minus]),
      zhan: String.to_integer(name[:zhan_plus]) - String.to_integer(name[:zhan_minus]),
      pan: String.to_integer(name[:pan_plus]) - String.to_integer(name[:pan_minus]),
    }
    #IO.puts(name[:hongplus])
    #conn |> send_resp(200, result[:hongplus])
    #polls = Repo.all(Poll)
    #render(conn, "index.json", polls: polls)
    render(conn, "index.json", polls: result)
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
    IO.puts("id: #{qa_id}")
    """
    #poll = Repo.get!(Poll, id)
    
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
