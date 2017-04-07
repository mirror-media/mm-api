defmodule MmApi.RedixPool do 
  use Supervisor 
 
  #redis_connection_params host: "localhost"
  #@redis_connection_params host: "104.199.146.212" 
 
  def start_link do 
    Supervisor.start_link(__MODULE__, []) 
  end 
 
  def init([]) do 

    read_opts = Application.get_env(:mm_api, MmApi.RedixPool)[:redix_opts]
    write_opts = Application.get_env(:mm_api, MmApi.RedixPool)[:redix_opts]
    read_opts = read_opts++ [name: {:local, :read_pool}]
    write_opts = write_opts ++ [name: {:local, :write_pool}]

    read_args = Application.get_env(:mm_api, MmApi.RedixPool)[:read_args]
    write_args = Application.get_env(:mm_api, MmApi.RedixPool)[:write_args]

    children = [ 
      #:poolboy.child_spec(:redix_poolboy, pool_opts, @redis_connection_params) 
      #:poolboy.child_spec(:redix_poolboy, pool_opts, redix_args) 
      #:poolboy.child_spec(:redix_poolboy, pool_opts, Application.get_env(:mm_api, :redix_args)[:test])
      :poolboy.child_spec(:read_pool, read_opts, read_args),
      :poolboy.child_spec(:write_pool, write_opts, write_args)
    ] 
 
    supervise(children, strategy: :one_for_one, name: __MODULE__) 
  end 
  def read(command) do 
    :poolboy.transaction(:read_pool, &Redix.command(&1, command)) 
  end 
 
  def write(commands) do 
    :poolboy.transaction(:write_pool, &Redix.command(&1, commands)) 
  end
 
  """
  def command(command) do 
    :poolboy.transaction(:redix_poolboy, &Redix.command(&1, command)) 
  end 
 
  def pipeline(commands) do 
    :poolboy.transaction(:redix_poolboy, &Redix.pipeline(&1, commands)) 
  end
  """
end 
