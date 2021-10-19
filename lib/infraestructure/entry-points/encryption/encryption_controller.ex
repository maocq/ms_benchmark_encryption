defmodule Fua.EntryPoint.Encryption.EncryptionController do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    "Hello"
    |> build_response(conn)
  end

  match _ do
    %{request_path: path} = conn
    build_response(%{status: 404, body: %{status: 404, path: path}}, conn)
  end

  defp build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  defp build_response(response, conn),
       do: build_response(%{status: 200, body: response}, conn)
end