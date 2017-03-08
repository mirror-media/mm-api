defmodule MmApi.Router do
  use MmApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PollApi do
    pipe_through :api

    resources "/poll", PollController, only: [:index, :show, :create]
  end
end
