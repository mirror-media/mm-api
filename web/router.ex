defmodule MmApi.Router do
  use MmApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/poll/kmt", MmApi do
    pipe_through :api

    resources "/", PollController, only: [:index, :show, :update]
    #resources "/poll", PollController, except: [:new, :edit]
  end
end
