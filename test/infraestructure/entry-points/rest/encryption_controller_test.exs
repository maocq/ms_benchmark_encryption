defmodule Fua.EntryPoint.Encryption.EncryptionControllerTest do
  alias Fua.EntryPoint.Encryption.EncryptionController

  use ExUnit.Case
  use Plug.Test
  doctest Fua.Application

  @opts EncryptionController.init([])

  test "returns hello" do
    conn =
      :get
      |> conn("/hello", "")
      |> EncryptionController.call(@opts)

    assert conn.state == :sent
    assert conn.resp_body == "\"Hello\""
    assert conn.status == 200
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing", "")
      |> EncryptionController.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end