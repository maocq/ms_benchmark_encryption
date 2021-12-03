defmodule Fua.Services.Kms do

  @key_id "63f3a0cb-9566-4c05-a61e-9151e33f4db1"
  @key_id_sign "8c75811f-c59e-4049-9a92-85c1107a0c70"
  @algorithm "RSAES_OAEP_SHA_256"
  @algorithm_sign "ECDSA_SHA_256"

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

  def encrypt_decrypt(text) do
    with {:ok, cypher} <- encrypt(text),
         {:ok, result} <- decrypt(cypher) do
      {:ok, result}
    end
  end

  def _get_public_key do
    ExAws.KMS.get_public_key(@key_id) |> ExAws.request
  end

  def sign(text) do
    data = text |> Base.encode64

    with {:ok, %{"Signature" => sign}} <- ExAws.KMS.sign(data, @key_id_sign, @algorithm_sign) |> ExAws.request do
      {:ok, sign}
    end
  end

  def verify(text, signature) do
    data = text |> Base.encode64

    with {:ok, %{"SignatureValid" => sign}} <- ExAws.KMS.verify(data, signature, @key_id_sign, @algorithm_sign) |> ExAws.request do
      {:ok, sign}
    end
  end
end
