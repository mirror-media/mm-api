defmodule MmApi.Endpoint do
  use Phoenix.Endpoint, otp_app: :mm_api

  socket "/socket", MmApi.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :mm_api, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
    #headers: %{"Access-Control-Allow-Origin" => "*"}

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison
    #headers: %{"Access-Control-Allow-Origin" => "*"}

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_mm_api_key",
    signing_salt: "L0Pslitd"
  
  # Allow CORS
  plug Corsica,
    origins: "*",
    allow_headers: ["accept"],
    allow_methods: ["HEAD", "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]

  plug MmApi.Router
end
