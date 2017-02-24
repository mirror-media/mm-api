defmodule MmApi.BqController do
    use MmApi.Web, :controller

    def index(conn, _params) do
        IO.puts("index")
        {:ok, name} = Redis.command(~w(GET name))
        IO.puts("name: #{name}")
        conn |> send_resp(200, name)  
    end

    def create(conn, params) do
        IO.puts("create")
        %{"name" => name} = params
        Redis.command(~w(SET name #{name}))
        IO.puts(name)    
        conn |> send_resp(200, name)  
    end
end