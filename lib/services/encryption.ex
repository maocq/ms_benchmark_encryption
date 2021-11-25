defmodule Fua.Services.Encryption do

  @public_key_text "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlUSqWjbEGyOv0/tSlj+r\nRqrPtv/4wz3b4E7poWdLRiNjaTP6YaBmp9vxkg55VXAXtoZVXze9Xgh/pQ4uNHbb\n2cTTpaMdUZ1HsSf8YueJjBgCIfjFOk0MKnAokT5fx9K5A4hh5j0P8kyRVMvpMjdp\nPhLcTHQeBbrgWyvuKzU9R27MwRnhkc8XkwAzqJfq/PMH9pkcWlb393CB5gip+1XM\nHcmydHl7+i8LZYRxhp3czz0PhmLeXO0y6Dyc+vJKuU+x6Og57W81+OjP0U5QYjn2\nHECWHWXLzOHI9GCasIK8kypiDCRbi6eDqXHfmDnR7ve5K69x4bASQlRVGKCDEJyD\nfwIDAQAB\n-----END PUBLIC KEY-----"
  @private_key_text "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAlUSqWjbEGyOv0/tSlj+rRqrPtv/4wz3b4E7poWdLRiNjaTP6\nYaBmp9vxkg55VXAXtoZVXze9Xgh/pQ4uNHbb2cTTpaMdUZ1HsSf8YueJjBgCIfjF\nOk0MKnAokT5fx9K5A4hh5j0P8kyRVMvpMjdpPhLcTHQeBbrgWyvuKzU9R27MwRnh\nkc8XkwAzqJfq/PMH9pkcWlb393CB5gip+1XMHcmydHl7+i8LZYRxhp3czz0PhmLe\nXO0y6Dyc+vJKuU+x6Og57W81+OjP0U5QYjn2HECWHWXLzOHI9GCasIK8kypiDCRb\ni6eDqXHfmDnR7ve5K69x4bASQlRVGKCDEJyDfwIDAQABAoIBAE1gDr487WL0GMzV\n1nW0A2DaYloGTjlG85dO0KSuGsL8zSdXnk7FCvGwfYSspBC5zlD7SX3WMv9vgFtb\nAnCHvGciNGQELcqEsQkQJTBPvWk1eMWLYxFZpxjIkv7XSmcWwHkoVTc4J+/96Mf/\n+53gQ1m+BRxMhNOLj4kzOH6FVoKUCfj2IyZjg9oJ8nFudf/9ojfJ8iR6+siL3dbl\nKwxpJEbG6Z0kI9Hr3pOABa2ORwtxSdTooWGcZLknR78MqTZ29eHe8FD4CjsBt8X3\neNf1oJrdQANvYAq8mAlZWCi6upraLptaBIfMoTFLtpwCJiMAgBkpwmUkMdCLej5m\nZIuQJkECgYEA7+4J+0QJHbdGOcmw6suU/jLODNHFZIUM0U+FTbwDwxc5NDFYSpJm\na4hfoVyhya32v4pRlUEv2yNhRiN7wsW6WqV2qyuAVu87IQ61WlQ0EyPf+x53qmyj\nG1lb6+PExWjNu1Ar1EheJwQvYGS0imr7Rg/ImSxLPasOPXBPDCDI1XcCgYEAn0QY\ndZEm3f61VJqu4TfSEew2iL+KQcOp5127cNpXfGGpPLtqQEe+nQkC/AJobrCZfv2G\npKJXr1I5loPf96qERxIYG8PE44lFnCJtFSqE5xiV75m/HLAeGncrIhv3AAP0WOzM\nAkK0gsqZdWg0Nch653JGrDoAUCtiWFQ+/sYx5DkCgYEAnP5yU5KiMGqTLg72j7xk\noqyVvTep5OtWhsN043eKMqbIjIlZT3paQDS89nYJe1E0qwKT/YjpCogtB1sCiWEe\nXl/0tW5CjR/+3dOlARUl+fw4fDXkcYSieavQBRtFzzKTo+SCuWYdDYSkh3t90zDL\neH2tceTU2uZJ7BPH9ZSiNWMCgYBcgl4+s+BCpDdJfEvGL/lKRc1rYu54wqFG7a/5\nnimg6s01pJrT2ZiDeH+OSAvG97dBBxwVNuL9yCIBJnqKTjZlXcI5Jl6P1+ViCrEX\n0Um/Pg2hTcmvbTEfKEcamem/zYw5ttnNGlflfK7kfnGNJ/UTyNH6KfqSlpCaQ90P\neanzKQKBgQCkSBftOGKr90K8lKcKCuS5Whj0klsjngnbOZXc89qeip9/qLh/xTQa\nXqOvgeVJtPrzhLwQegzHQDRUH2JeqZdgH3hWvlhJw9toUHSK+UxbJP4P4/bFdPKV\n5GywRIclZrowsShU4qAumSed+6ETN56i40BqRC+GkEHRNc9F13FAHA==\n-----END RSA PRIVATE KEY-----"

  @private_key :public_key.pem_entry_decode(List.first(:public_key.pem_decode(@private_key_text)), "password")
  @public_key :public_key.pem_entry_decode(List.first(:public_key.pem_decode(@public_key_text)))

  @options [rsa_padding: :rsa_pkcs1_oaep_padding, rsa_oaep_md: :sha256]

  def encrypt(text) do
    case encrypt_public(text, @public_key) do
      {:ok, encrypt} -> {:ok, encrypt |> Base.encode64}
      error -> error
    end
  end

  def decrypt(text) do
    with {:ok, cipher_bytes} <- Base.decode64(text),
         {:ok, decrypt} <- decrypt_private(cipher_bytes, @private_key) do
       {:ok, decrypt}
    end
  end

  def encrypt_decrypt(text) do
    with {:ok, cypher} <- encrypt(text),
         {:ok, result} <- decrypt(cypher) do
      {:ok, result}
    end
  end

  defp encrypt_public(clear_text, rsa_pub_key_seq) do
    {:ok, :public_key.encrypt_public(clear_text, rsa_pub_key_seq, @options)}
  catch
    _kind, _error -> {:error, "Encrypt error"}
  end

  defp decrypt_private(cipher_bytes, rsa_priv_key_seq) do
    {:ok, :public_key.decrypt_private(cipher_bytes, rsa_priv_key_seq, @options)}
  catch
    _kind, _error -> {:error, "Decrypt error"}
  end

end
