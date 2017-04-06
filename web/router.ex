defmodule MmApi.Router do
  use MmApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/poll", MmApi do
    pipe_through :api
    scope "/kmt" do
      #resources "/", PollController, only: [:index, :show, :update]
      #resources "/poll", PollController, except: [:new, :edit]
      get "/", PollController, :index
      get "/:id", PollController, :show
      
      put "/:id/up", PollController, :increase
      put "/:id/down", PollController, :decrease
    end
  end
end
