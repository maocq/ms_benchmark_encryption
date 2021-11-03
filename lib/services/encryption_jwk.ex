defmodule Fua.Services.EncryptionJwk do

  @public_key JOSE.JWK.from_pem("-----BEGIN PUBLIC KEY-----\nMIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQBxPOk8GQleL1npLQzmIAzf\nrK2EDjDF4qrySxTpi2Ikkrn02fW0hAsUBHRXRiOhzqD4TX8gfnvtjSCd4tGlPoa9\n4KpJy9ck9X+OOxsUaEdKq4nRzU1rvqeDEa3XnvaEVzykAAmm7oNPwPwT9NQvPQB0\nV6RdQtL3oUjmFVdqCCdP4vKInqXTQqJLoI89d9J10ofVmiZq1uN5ui4UbR4cheN4\nxVbQujwaEf+07cPf+Q/7EUnDHGMSp3+rRDog9mIZU5ZlBYxfTapEWOvvGZ3spUp7\nvX+OnR4lr//xqD+4OjbXEeOntvcXn0pScsmbUGmT7tUNILFoa/q2JS7p3R9RX8/t\nAgMBAAE=\n-----END PUBLIC KEY-----")
  @private_key JOSE.JWK.from_pem("-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQBxPOk8GQleL1npLQzmIAzfrK2EDjDF4qrySxTpi2Ikkrn02fW0\nhAsUBHRXRiOhzqD4TX8gfnvtjSCd4tGlPoa94KpJy9ck9X+OOxsUaEdKq4nRzU1r\nvqeDEa3XnvaEVzykAAmm7oNPwPwT9NQvPQB0V6RdQtL3oUjmFVdqCCdP4vKInqXT\nQqJLoI89d9J10ofVmiZq1uN5ui4UbR4cheN4xVbQujwaEf+07cPf+Q/7EUnDHGMS\np3+rRDog9mIZU5ZlBYxfTapEWOvvGZ3spUp7vX+OnR4lr//xqD+4OjbXEeOntvcX\nn0pScsmbUGmT7tUNILFoa/q2JS7p3R9RX8/tAgMBAAECggEAYLtXwi7hAcQRWk9R\npYPbe3dXAmfc4i4vOatJwfd/bx6oG7HVYs8pZ4AmoicYaTDJ8VLCNk/WLadRJY6M\n6EvxbmJtFX073CabQDTdfSFXRUIkCUUHzfKfxidkCb2ReJvNAYvGswMsyQRiUenj\nGDdUHA6CKejbrw3n6CRy9/DfJC3d3KE+VpbAjRuj63bZ81pPEsaZem+k36wb/tD9\n3RIyUsNqDk2lJYv8MvDotsEOEQHlerVwac1Gsco8TqJE+16UyhqP/g9rRStq5puE\nz2ePFrqjjiDzd76Xnrqco7drZVe8u7NcLlSsSH1hhywDxV6Tw7qbmH3ydXTLThlH\namOlQQKBgQDcD6rARJrdPq7lFcj9EMgab4Bc+//uXaJY7/iXrSkNY0EhmjRkQpgg\n4uREBmLOvcghfIrFLwg0rN997VM/ItUqeh+dWAAFNq94PvicJSgg2Tk+wnHvkFzr\nm0SbMY0V581EeasQEAafR0tLNXMSk3iAjVjHi8jeVPv+gOE9aIp5ZwKBgQCDuyuG\nMGWrkmmAkMUfrrJ5MQfzt4XSbuj0VVekAITuymyXK+D9SXXD5q65GiVXU07oWJcg\nV/aTNeuoaCzjLMPabaUQf4OY0GStemW6inyoSgRjlVkx1f3rc3+KDGatDtxH4Tlf\n0Lg58gPRMs667+qeYk2o85Eiuq4fyeep/uDTiwKBgDw/0dkYL2o5mjrATynyKUcL\nlhJfMD/7xNIiyWYFk8LFlPR1OrjkfrAqTqLNOMovrZZ1eazo5o89cWcRzgPwLnqV\nuwgiKsdCpKIAY6KkjasIriKfrAAR/07GUO9Ijr8bmtiPkyUvrhB3vYaW2K2SUKCp\nkk/31oQAsomIkaJ1d8wrAoGAHSW8AqwQwv7Zc0YVJ+Z6vRAZR1bzOFWsG+wKQVKQ\nF1oY3vYpiUHI2fjf7jsXyhO34PdBMTnlaDtFEnVCgV21VE5weI8OajCqJixv9++O\nl5oREIvKOZm03nUm4j/ONDqWiR0PmeDP8ppXN+G7FmfhjPwJXPnPwlR2FLiTFu07\nh/MCgYEAqDzfKFuefT7sOHEAvRznVydjyaWKznTUorNcg+f41OmhnS77wJNk2kEN\n+G4quhQUwadXzFIbitMp1tmQr0oLboB2QwIiqvYsbbpBdUq1ZxyoTVOx+LyXJLkJ\n7x3vhw64gbhZUEuWUfrXxtoIIO2XnTp8HGR0GkyghuSbBWokSEI=\n-----END RSA PRIVATE KEY-----")

  def encrypt(text) do
    {:ok, JOSE.JWK.block_encrypt(text, %{ "alg" => "RSA-OAEP-256", "enc" => "A128GCM" }, @public_key)
      |> JOSE.JWE.compact
      |> elem(1)}
  end

  def decrypt(cif) do
    case JOSE.JWK.block_decrypt(cif, @private_key) |> elem(0) do
      :error -> {:error, "Decrypt error"}
      decrypted -> {:ok, decrypted}
    end
  end

  def encrypt_decrypt(text) do
    with {:ok, cypher} <- encrypt(text),
         {:ok, result} <- decrypt(cypher) do
      {:ok, result}
    end
  end
end
