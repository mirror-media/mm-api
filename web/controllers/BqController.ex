defmodule MmApi.BqController do
    use MmApi.Web, :controller

    def index(conn, _params) do
        IO.puts("Get")
        conn |> send_resp(200, "Get")  
    end

    def create(conn, params) do
        IO.puts("create")
        %{"name" => name} = params
        IO.puts(name)    
        conn |> send_resp(200, name)  
    end
end