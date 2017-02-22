defmodule MmApi.Router do
  use MmApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MmApi do
    pipe_through :api

    resources "/bq", BqController, only: [:index, :create]
  end
end
