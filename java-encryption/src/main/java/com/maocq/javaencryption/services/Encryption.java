package com.maocq.javaencryption.services;

import reactor.core.Exceptions;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

import static java.nio.charset.StandardCharsets.UTF_8;

public class Encryption {

    private static final PublicKey publicKey;
    private static final PrivateKey privateKey;

    static {
        String publicK = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAloYvxChRGuJt/EJtgK6dYS7yHpYwTOYwjQih1u8dWUPuDuxkvb5ibDfP6btLsO9yPX/A/e+HIIOGLFtsbKGbSE2no2LIQMimJLSW9IjHA81ghTbaRHI3q5YINPIGvFfddkFCEb1SSveUXLGceyJPXx+WcB8LEFkcwbv9Kvhruk0dS8A47w+i3VQv3uNY//EFe0dQR5pSxOML9r5sY2rzMvv2yLR4KTNFG2ovTcJ/nbfQXxuVzqrbMdYXIsuAl1P6a0GByxeUEZUr/CX+HWbuomlMDIJlTV+NmT9VgF+CS51I5iPtJCpFLbv690Nyg0Wq4tzAtKwc8FwugwF47rVMkQIDAQAB";
        String privateK = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCWhi/EKFEa4m38Qm2Arp1hLvIeljBM5jCNCKHW7x1ZQ+4O7GS9vmJsN8/pu0uw73I9f8D974cgg4YsW2xsoZtITaejYshAyKYktJb0iMcDzWCFNtpEcjerlgg08ga8V912QUIRvVJK95RcsZx7Ik9fH5ZwHwsQWRzBu/0q+Gu6TR1LwDjvD6LdVC/e41j/8QV7R1BHmlLE4wv2vmxjavMy+/bItHgpM0Ubai9Nwn+dt9BfG5XOqtsx1hciy4CXU/prQYHLF5QRlSv8Jf4dZu6iaUwMgmVNX42ZP1WAX4JLnUjmI+0kKkUtu/r3Q3KDRari3MC0rBzwXC6DAXjutUyRAgMBAAECggEAK1QrEcsNNbDyOgghH0akVOI/neBbvPcSCLbwZz9jclukfjU79oaELGSQe9aHPkJe3ycUNcSqYAicKc6TUl3ephx8YgLAZC2d7bjyLyfkKcsHurEEeWlrbv/8EsmMeNDOFglI7HRT6PKFiX0y7xr8QASGuHWnKKiOJ5JmmOTzlafFugVOndkz5EBzNihZIX0DissaGBhaq46BYGAnHF4vw9bq9JpG0sT0CEQ/PV7/qPAwWwwQMX0hUnyWZXrn17q06KwlEevrwjnVjAQ03cCR3OraWcLjb6FxGE2lQkx6uK5JaK2M6DBIFcsGW56gPlVYwwTFk1+aK84YPNC1ypAOAQKBgQDSgWyV+dPirqknAW6vP8nkwdq9Mr9M3Zv35p+M8wH5g9Fbhi1Uh/2y/svOy4wxd0FNhBTlYvYDGDJNL88KErS8yGMfoZcBy2Vgy9eGDWBruXQxdJbbtTPa1sEbCfTliwptVzlI4nWGvVfyigkKRygrlCCKjEh6CrJpVRmOaoNscQKBgQC3DjC5wOxQmk0w6m9JENovV4jC2++79g2YqHcH+sDTjUlDnflCCinZT6brVgLVXRWrwK5Nxav8RQnIiXYBiP9qwGxzzWbtoEi9F2Uo6KOapqvcxfXOr7PyIrVpDKsOdDbuu7nBEc0OzNel7RX8o1XB9X2vny3yErnStb5NShpyIQKBgFiMeNDdtnO0ZRMzVwwBGTxRD2Jm5nG/BszRBmyUDFCZUofdeVQFoIKbC8CBfweP0rh4xxF2/2Vt2Dr/0We7VqvS319+6baniI2fMZoCJn0qFeZ31L23C4kSrUhid9HXGxvDhSVTnXyASW6NAiCArjUmqkmdmR89QK9uTMHLrF0BAoGBAKxUZpiov5AOAzdWrFeLzuucq3pOVT2NITWi+xP/A4LlUqCeWqbKLKWRL+IDAf3deOZNKYq72fJPCCvLBNXjJBlad375UrnIGFIzcR93C3YvDEJ19reSf4QnGsN/kpWz4HcVMYVJ/dK+ExH4xacmGTjUpHMuFrH64Qc146adaZIhAoGAQ1y8lkZ+HxVTeeL65Hg78DUpp5WJt4cxBkXKTu+8jlve7SUigsNuGK5e0Zr0XvpHY/GYgR1uz++zXUtX98FdcOQt1RVK+xa8lbEQL1gjSCXZZ1bCRjW4nKvJaEqGMLusFnmxjPVhhCToTSquA5Ssxg49yEEj42qsLGnItOopB8c=";
        try {
            publicKey = getPublicKey(publicK);
            privateKey = getPrivateKey(privateK);
        } catch (Exception error) {
            throw Exceptions.propagate(error);
        }
    }

    public static String encrypt(String data, String algorithm) {
        try {
            Cipher cipher = Cipher.getInstance(algorithm);
            cipher.init(Cipher.ENCRYPT_MODE, publicKey);
            return Base64.getEncoder().encodeToString(cipher.doFinal(data.getBytes()));
        } catch (Exception error) {
            throw Exceptions.propagate(error);
        }
    }

    public static String decrypt(String data, String algorithm) {
        try {
            Cipher cipher = Cipher.getInstance(algorithm);
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            return new String(cipher.doFinal(Base64.getDecoder().decode(data.getBytes())), UTF_8);
        } catch (Exception error) {
            throw Exceptions.propagate(error);
        }
    }

    private static PublicKey getPublicKey(String base64PublicKey) throws NoSuchAlgorithmException, InvalidKeySpecException {
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(Base64.getDecoder().decode(base64PublicKey.getBytes()));
        return KeyFactory.getInstance("RSA").generatePublic(keySpec);
    }

    private static PrivateKey getPrivateKey(String base64PrivateKey) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(base64PrivateKey.getBytes()));
        return KeyFactory.getInstance("RSA").generatePrivate(keySpec);
    }
}
