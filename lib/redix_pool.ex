defmodule MmApi.RedixPool do
  use Supervisor

  #@redis_connection_params host: "localhost"
  #@redis_connection_params host: "104.199.146.212"

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    pool_opts = [
      name: {:local, :redix_poolboy},
      worker_module: Redix,
      size: 3,
      max_overflow: 2
    ]

    redix_args = [
      {:host, "104.199.146.212"},
      {:port, 6379},
      {:password, "ZgbRu7SP"}
    ]
  
    children = [
      #:poolboy.child_spec(:redix_poolboy, pool_opts, @redis_connection_params)
      :poolboy.child_spec(:redix_poolboy, pool_opts, redix_args)
    ]

    supervise(children, strategy: :one_for_one, name: __MODULE__)
  end

  def command(command) do
    :poolboy.transaction(:redix_poolboy, &Redix.command(&1, command))
  end

  def pipeline(commands) do
    :poolboy.transaction(:redix_poolboy, &Redix.pipeline(&1, commands))
  end
end
