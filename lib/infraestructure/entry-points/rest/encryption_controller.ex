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

  ############### Public key ###############

  post "/encrypt" do
    text = conn.body_params["text"] || UUID.uuid1()

    with {:ok, response} <- Encryption.encrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/decrypt" do
    text = conn.body_params["text"] || "OgT6liqJEqEJ7uoIo9tbtQ0AFYkfMdlwgH/VaN2dIU96df+V9i5TdyfrJZF5ccDbe5chHQNzw6HvnjSLyHznuaVSt7R79skSpkJkaKB3LC4pbGv+vWT6fggzuaxkCffCwc7BzrPln4F2FSSy9kI2n5axqWsRcexbPchyh3nfdGjxvtYAWM/zwxfqKPpecdapXYyf8yW2P8UgFsPCPk76FGA99+uWUMkt/NDKpHGlDorJjbRWFVBSngSVfeU8Vdkdzu+OSG4NHBjFijrLH5hwlk1j2EeOkifKqgP2eAsAkIZgE5l4Rml1oqcZyIxN+v5iYu+VCY7phdXNnRA3Zzdr9g=="

    with {:ok, response} <- Encryption.decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  get "/encrypt-decrypt" do
    text = UUID.uuid1()

    with {:ok, response} <- Encryption.encrypt_decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  ############### Jwk ###############

  post "/encrypt-jwk" do
    text = conn.body_params["text"] || UUID.uuid1()

    with {:ok, response} <- EncryptionJwk.encrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/decrypt-jwk" do
    text = conn.body_params["text"] || "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMTI4R0NNIn0.H29knCM1b80ILfCVXJp-ZASZx2gEiHs2ViQ1wuaKAeMLfEYUr3rg_yN4v0Vsh4jCbIjJeFt6_bf68vyzmJeeZYvpyAVrq7nSd1_z0nanAHxP8_IAVgHLgOmiIxR2qyD0Koq7SvdtYSlMGqdRDBRXLM3ZgbfkyAS5lHXnZV-cQARUfcOaHYMDdvS_sZujetJGmJRAtpXDZi-GrF8VEYoVfeeAtRKKLHdDa1FJFN2XmLSVscdVboj1z6EmFI08x_cpiA_2LxJhp3Ms8oHlYrCnL8MliqoNo078DAONu10Y7v8HZWdcGKY0a8p9tztUMjOhzH7NaFo3M7JVlSBp1iblQQ.iqoGe_BQH7FdenBj.fyHXI3t2X_x7KBjR_dYyg7qpDWKkbsJTdOk5Y4tiWdcMFLsM.nT-_Blmbpfft4_6BqdhrUg"

    with {:ok, response} <- EncryptionJwk.decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  get "/encrypt-decrypt-jwk" do
    text = UUID.uuid1()

    with {:ok, response} <- EncryptionJwk.encrypt_decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  ############### Kms ###############

  post "/encrypt-kms" do
    text = conn.body_params["text"] || UUID.uuid1()

    with {:ok, response} <- Kms.encrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  post "/decrypt-kms" do
    text = conn.body_params["text"] || "o5O4eF55poV90oP3F0cMIkY0mGPX5OrV6ATOVXOdn8eVIpY5Lckm6GzLRhHCbK9En58ymfIPAH2K4Fa7Nh09BCKsjfspfblUvyOSWnrNz47F0hghPnSYymGesEy410t/OoK0CsfbPHpdEX5Me4JuBpC7d05/Ow0evH2tpX12PgemtLMXYaW8pCVCmGoaVO2CqO9AW+trSw5av78WEigY4FtIKytl60LcPIEDMTC9j4lLwyckwxexEpR6MsUEjMrE7o+QOkuAudWYrS83R9PbacEpYFrFy3JJ+qoN60YN/XFlHlfjHpL0dYZgczb7iPXGJ9dTyCmIzmbY60+w25JEtE/QGt8+4+CKn+7aYY92kCwYoR4edyju29GYl7Pq+OWgZ2Vfeqj0z2HZ7sS1jUgKdrFCmw2kFv87tHbJJdVDT+XUGfhEf4VDzbukpIFvkqIxPrk1YF69yCx3HSZcUDbCGsSp1tKqNo9GH+1s/E4f6qKTJae6aawcR7UqA+ps45AXEGkIu+sW97SjIvzwtN/LaEwt5IOnVkKXFXP8Kg9jSvbIitLbwaUNVBZWoQhExJwYF/Rl6JlzCgQnB1vp//eEy7ocTBHixrmnB3FPm/RUmzLh9e1xNsEbcLiq9EXT8gUDVPVGwCaWpc1ahtF9NcEp231BAB5LBJ3yWimkk5kYJkU="

    with {:ok, response} <- Kms.decrypt(text) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  get "/encrypt-decrypt-kms" do
    text = UUID.uuid1()

    with {:ok, response} <- Kms.encrypt_decrypt(text) do
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
