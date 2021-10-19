defmodule Fua.EntryPoint.Encryption.EncryptionController do
  alias Fua.Services.Encryption

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
  defp handle_errors(conn, %{} = error) do
    Logger.error("Internal server - #{inspect(error)}}")
    build_response(%{status: 500, body: %{status: 500, error: "Internal server"}}, conn)
  end
end