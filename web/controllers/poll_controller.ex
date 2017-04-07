defmodule MmApi.PollController do
  use MmApi.Web, :controller

  #alias MmApi.Poll

  def index(conn, _params) do
    IO.puts("index") 
    {:ok, response} = Redis.read(~w(HGETALL 2017kmt-chairman)) 
    
    response = response |> Enum.chunk(2) |> Enum.into(%{}, fn [key, val] -> {key, val} end)
    response = for {key, val} <- response, into: %{}, do: {String.to_atom(key), val}

    result = %{
      hong: String.to_integer(response[:hong_up]) - String.to_integer(response[:hong_down]),
      hao: String.to_integer(response[:hao_up]) - String.to_integer(response[:hao_down]),
      wu: String.to_integer(response[:wu_up]) - String.to_integer(response[:wu_down]),
      han: String.to_integer(response[:han_up]) - String.to_integer(response[:han_down]),
      zhan: String.to_integer(response[:zhan_up]) - String.to_integer(response[:zhan_down]),
      pan: String.to_integer(response[:pan_up]) - String.to_integer(response[:pan_down]),
    }
    #conn |> send_resp(200, result[:hongplus])
    #polls = Repo.all(Poll)
    #render(conn, "index.json", polls: polls)
    render(conn, "index.json", polls: result)
  end

  def show(conn, %{"id" => id}) do
    IO.puts("id: #{id}")
    {:ok, response} = Redis.read(~w(HMGET 2017kmt-chairman #{id}_up #{id}_down))
    [plus, minus] = response
    result = %{String.to_atom(id) => String.to_integer(plus) - String.to_integer(minus)}

   
    #conn |> send_resp(200, Integer.to_string(result))
    render(conn, "index.json", polls: result)
  end

  def increase(conn, %{"id" => id}) do
    IO.puts("id: #{id}")
    {:ok, response} = Redis.write(~w(HINCRBY 2017kmt-chairman #{id}_up 1))
    {:ok, minus_now} = Redis.read(~w(HGET 2017kmt-chairman #{id}_down)) 
    minus = String.to_integer(minus_now)
    result = %{"#{id}" => response - minus}
    render(conn, "index.json", polls: result)
  end

  def decrease(conn, %{"id" => id}) do
    IO.puts("id: #{id}")
    {:ok, response} = Redis.write(~w(HINCRBY 2017kmt-chairman #{id}_down 1))
    {:ok, plus_now} = Redis.read(~w(HGET 2017kmt-chairman #{id}_up)) 
    plus = String.to_integer(plus_now)
    result = %{"#{id}" => plus - response}
    render(conn, "index.json", polls: result)
  end

"""
  def show(conn, %{"id" => id}) do
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
  end
  
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

  def delete(conn, %{"id" => qa_id}) do
    poll = Repo.get_by!(Poll, qa_id: qa_id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(poll)

    send_resp(conn, :no_content, "")
  end
"""
end
