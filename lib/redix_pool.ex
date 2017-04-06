defmodule MmApi.RedixPool do 
  use Supervisor 
 
  #redis_connection_params host: "localhost"
  #@redis_connection_params host: "104.199.146.212" 
 
  def start_link do 
    Supervisor.start_link(__MODULE__, []) 
  end 
 
  def init([]) do 
    pool_opts = [ 
      name: {:local, :redix_poolboy}, 
      worker_module: Redix, 
      size: 2, 
      max_overflow: 2 
    ] 

    children = [ 
      #:poolboy.child_spec(:redix_poolboy, pool_opts, @redis_connection_params) 
      #:poolboy.child_spec(:redix_poolboy, pool_opts, redix_args) 
      #:poolboy.child_spec(:redix_poolboy, pool_opts, Application.get_env(:mm_api, :redix_args)[:test])
      :poolboy.child_spec(:redix_poolboy, pool_opts, Application.get_env(:mm_api, MmApi.RedixPool)[:redix_args])
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
