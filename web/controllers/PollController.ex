defmodule PollApi.PollController do
    use PollApi.Web, :controller

    def index(conn, _params) do
        conn |> send_resp(200, "index")
    end
    
    def show(conn, %{"id" => id}) do
        conn |> send_resp(200, "show: #{id}")
    end

    def create(conn, _params) do
        conn |> send_resp(200, "create")
    end
end