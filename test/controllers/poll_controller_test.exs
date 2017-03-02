defmodule PollApi.PollControllerTest do
    use PollApi.ConnCase

    test "GET /poll" do
        conn = get build_conn(), "/poll"
        #conn = get conn(), poll_path(conn, :index)
        assert response(conn, 200) =~ "index"
    end

    test "GET /poll/id" do
        #conn = get conn(), "/poll/", 123:
        post = "123"
        conn = get build_conn(), poll_path(build_conn(), :show, post)
        #conn = get conn(), poll_path(conn, :index)
        assert response(conn, 200) =~ "123"
    end
    
    test "POST /poll" do
        conn = post build_conn(), "/poll", %{"name" => "Bona"}
        assert response(conn,200) =~ "Bona"
    end
end