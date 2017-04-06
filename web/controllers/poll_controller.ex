defmodule MmApi.PollController do
  use MmApi.Web, :controller

  #alias MmApi.Poll

  def index(conn, _params) do
    IO.puts("index") 
    {:ok, response} = Redis.command(~w(HGETALL party:kmt)) 
    
    response = response |> Enum.chunk(2) |> Enum.into(%{}, fn [key, val] -> {key, val} end)
    response = for {key, val} <- response, into: %{}, do: {String.to_atom(key), val}

    result = %{
      hong: String.to_integer(response[:hong_plus]) - String.to_integer(response[:hong_minus]),
      hao: String.to_integer(response[:hao_plus]) - String.to_integer(response[:hao_minus]),
      wu: String.to_integer(response[:wu_plus]) - String.to_integer(response[:wu_minus]),
      han: String.to_integer(response[:han_plus]) - String.to_integer(response[:han_minus]),
      zhan: String.to_integer(response[:zhan_plus]) - String.to_integer(response[:zhan_minus]),
      pan: String.to_integer(response[:pan_plus]) - String.to_integer(response[:pan_minus]),
    }
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
  def show(conn, %{"id" => id}) do
    IO.puts("id: #{id}")
    {:ok, response} = Redis.command(~w(HMGET party:kmt #{id}_plus #{id}_minus))
    [plus, minus] = response
    result = %{String.to_atom(id) => String.to_integer(plus) - String.to_integer(minus)}

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
    #conn |> send_resp(200, Integer.to_string(result))
    render(conn, "index.json", polls: result)
  end

  def increase(conn, %{"id" => id}) do
    IO.puts("id: #{id}")
    {:ok, response} = Redis.command(~w(HINCRBY party:kmt #{id}_plus 1))
    {:ok, minus_now} = Redis.command(~w(HGET party:kmt #{id}_minus)) 
    minus = String.to_integer(minus_now)
    result = %{"#{id}" => response - minus}
    render(conn, "index.json", polls: result)
  end

  def decrease(conn, %{"id" => id}) do
    IO.puts("id: #{id}")
    {:ok, response} = Redis.command(~w(HINCRBY party:kmt #{id}_minus 1))
    {:ok, plus_now} = Redis.command(~w(HGET party:kmt #{id}_plus)) 
    plus = String.to_integer(plus_now)
    result = %{"#{id}" => plus - response}
    render(conn, "index.json", polls: result)
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
