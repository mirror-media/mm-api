defmodule MmApi.BqController do
    use MmApi.Web, :controller

    def index(conn, _params) do
        IO.puts("Get")
        {:ok, rdxconn} = Redix.start_link(host: "104.199.146.212", port: 6379, password: "ZgbRu7SP")
        {:ok, name} = Redix.command(rdxconn, ~w(GET name))
        IO.puts("driver count: #{name}")
        conn |> send_resp(200, name)  
    end

    def create(conn, params) do
        IO.puts("create")
        {:ok, rdxconn} = Redix.start_link(host: "104.199.146.212", port: 6379, password: "ZgbRu7SP")
        %{"name" => name} = params
        Redix.command(rdxconn, ~w(SET name #{name}))
        #=> {:ok, "OK"}
        IO.puts(name)    
        conn |> send_resp(200, name)  
    end
end