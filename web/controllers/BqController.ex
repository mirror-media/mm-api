defmodule MmApi.BqController do
    use MmApi.Web, :controller

    def index(conn, _params) do
        IO.puts("index")
        #{:ok, rdxconn} = Redix.start_link(host: "104.199.146.212", port: 6379, password: "ZgbRu7SP")
        #Redis.command(~w(AUTH ZgbRu7SP))
        {:ok, name} = Redis.command(~w(GET name))
        #{:ok, name} = Redis.pipeline([~w(AUTH ZgbRu7SP),~w(GET name)])
        IO.puts("driver count: #{name}")
        conn |> send_resp(200, name)  
    end

    def create(conn, params) do
        IO.puts("create")
        #{:ok, rdxconn} = Redix.start_link(host: "104.199.146.212", port: 6379, password: "ZgbRu7SP")
        %{"name" => name} = params
        Redis.command(~w(SET name #{name}))
        #Redis.pipeline([~w(AUTH ZgbRu7SP),~w(SET name #{name})])
        #=> {:ok, "OK"}
        IO.puts(name)    
        conn |> send_resp(200, name)  
    end
end