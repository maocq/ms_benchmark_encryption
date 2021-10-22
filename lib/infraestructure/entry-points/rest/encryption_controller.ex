defmodule Fua.EntryPoint.Encryption.EncryptionController do
  alias Fua.Services.Encryption
  alias Fua.Services.EncryptionJwk
  alias Fua.Services.Kms

  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  plug(CORSPlug,
    methods: ["GET", "POST"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:fua, :plug])
  plug(:dispatch)

  get "/hello" do
    "Hello"
    |> build_response(conn)
  end

  post "/encrypt" do
    text = conn.body_params["text"] || "hello"

    with {:ok, response} <- Encryption.encrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/decrypt" do
    text = conn.body_params["text"] || "Haj6M0Q_sNTzwff8ZtRvPI1PmugeIEXw2uLnpO9FE8C9bTwwUoB_JgIJM0Kv1Ne6c8kHtzHYDjKaiqoVsAq_eh5Bpfxu9F9KZjwP27dFjusQMLeRxRKP86o9TfzSxdAbV-YdCDXTqFNfVdw-F22fqMSpacjGywra2U6jDqqX8OMZfklR-oGqBDWISEtniouLmqbo6RdAjZJ5PZLEhuhljrU8ta1Q2ow-Xa_G0Wxg1vMs6qO8Dv_iL4SYKW6xXtPpO_LLJzNnGTlbSYVCxcuRt4Lspf181IzquUThkkNoNmm46op39r6crBEDqfKEp9xGVgArLBj2OOuKNr7IhaIz3w=="

    with {:ok, response} <- Encryption.decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/encrypt-jwk" do
    text = conn.body_params["text"] || "hello"

    with {:ok, response} <- EncryptionJwk.encrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/decrypt-jwk" do
    text = conn.body_params["text"] || "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMTI4R0NNIn0.bwkZURq9x4LnlBCuNxO0oJ16hsjjf46dKdYmJ8fL-8ZDJEzjjRRi0wJ5lr4WuxUvJcmgDUYJ7fWemM1XperpVbDjTN_c8SAUUQrzqzknb_7yUTj8kKFSulSOg96iAC6rN9WFIPdftouNf6ezg6ZT5YrIqeNmgpEQqQDAPZLI5rXUuLmP-cIwJ_ee7LmjYqa3uN9nDKW0-3ghGYdpx41jM5SR7l-EppQaownahxImoWokEqNgTB3m6SHGLuKlP9KetjSjn02TpHZ5YYiEZsTZYS-oftyRhhgDQmzXLKw1S7mvvF018vFVuSJonG5hBVKUgiHGKkf01Wbm4IL-cRrmpQ.Tp_cwuMo_clJkeLy.f6rR2DY.DxAo1YpD4Mhv2Q_PF26gLA"

    with {:ok, response} <- EncryptionJwk.decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/encrypt-kms" do
    text = conn.body_params["text"] || "hello"

    with {:ok, response} <- Kms.encrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/decrypt-kms" do
    text = conn.body_params["text"] || "P1EJu73bKk0FcEqGQYKrLZi6sV/cp4QWKvPmLdmZcN9jV6Wv05CMFh+DsQDWuChxO9a2r8wc7H7epHNXRgguHwW+mnEc2b0hjDTTjcJvNycnHhj6c88emFia05Y0K1i8ghMZj6NtmSDKmh+DXfpLzvlPSSxwUoePY8yiK/+4T8bAuYEprPiD99sEeBhpz2yTfFJWmm98MVSfGmCcRk4xqOt/Yn0CfyNcJvmGzLyUMDFl5LVWccygT/j4c4xVQ2YVO8fYtaIYRrGxSZk/KH9Xh6Q3kDV89/rSd9sKBZU/7Wbj/jFDIi55IzTfieOPmKWKhte69Q5GEDuGMUlv63gh689woHCZSBs5UI9ciCP7kP9dbiKtTq1JrV5PxmfpWTaQX18Z9rGrOgdS5vDBFy2KpUczgiF56pUcCjfmGuJQHFiX7k6iZ67PhfslADHQlTKI1Z+54yLJdiNrjL8tV94NZSpGDM+WPn2MLWrMtmal5NupQJeypmth633Yhgg6HrrTuOTqCdp+vzPdBWE2SLIjiqWlIoAWvKW6Dobv+83gwXxf6h3xD2GUUf9dSgakdCibNwBiOkgGyA6/gbcS+u5X+ENBGZbTahT+6/rxLUWOidUG/X0g63/VKkSakTmqvXVIOd2k866Dpg2Aw7N79RenkoZTHtRt3/NfzTV9xoRw4pk="

    with {:ok, response} <- Kms.decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
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

  defp handle_error(error, conn) do
    Logger.error("Unexpected error #{inspect(error)}}")
    build_response(%{status: 500, body: %{status: 500, error: "Error"}}, conn)
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{} = error) do
    Logger.error("Internal server - #{inspect(error)}}")
    build_response(%{status: 500, body: %{status: 500, error: "Internal server"}}, conn)
  end
end