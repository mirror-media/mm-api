defmodule BqMaru.API do
  use Maru.Router
  import Plug.Conn
  namespace :bq do
    desc "Big Query Rest API"
    get do
      #current_time = String.to_char_list(DateTime.to_string(DateTime.utc_now()))
      #'gcloud beta logging write maru-test "#{current_time}"' |> :os.cmd()
      # Above method unsafe
      current_time = DateTime.to_string(DateTime.utc_now())
      System.cmd "gcloud", ["beta","logging","write", "maru-test", current_time]
      #conn |> text(current_time)
      conn
      |> send_resp(200, "")
    end
  end     
end
