defmodule Fua.Services.Kms do

  @key_id "63f3a0cb-9566-4c05-a61e-9151e33f4db1"
  @algorithm "RSAES_OAEP_SHA_256"

  def encrypt(text) do
    data = text
    |> Base.encode64

    with {:ok, %{"CiphertextBlob" => cipher}} <- ExAws.KMS.encrypt(@key_id, data, [{"EncryptionAlgorithm", @algorithm}])
      |> ExAws.request do
      {:ok, cipher}
    end
  end

  def decrypt(cif) do
    with {:ok, %{"Plaintext" => text}} <- ExAws.KMS.decrypt(cif, [{"KeyId", @key_id}, {"EncryptionAlgorithm", @algorithm}])
      |> ExAws.request do
      text |> Base.decode64
    end
  end

  def _get_public_key do
    ExAws.KMS.get_public_key(@key_id) |> ExAws.request
  end
end