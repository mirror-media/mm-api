defmodule PollApi.PollController do
    use PollApi.Web, :controller

    def index(conn, _params) do
        IO.puts("index")
        conn |> send_resp(200, "index")
    end
    
    def show(conn, %{"id" => id}) do
        IO.puts("show")
        conn |> send_resp(200, "show: #{id}")
    end

    def create(conn, params) do
        IO.puts("create")
        %{"name" => name} = params
        conn |> send_resp(200, name)
    end
end