package com.maocq.javaencryption.entrypoints;

import com.maocq.javaencryption.services.Encryption;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.util.UUID;

@Component
public class Handler {

    private static final String algorithm = "RSA/ECB/OAEPWithSHA-256AndMGF1Padding";

    public Mono<ServerResponse> listen(ServerRequest serverRequest) {
        return Mono.just("Hello")
          .flatMap(r -> ServerResponse.ok().bodyValue(r));
    }

    public Mono<ServerResponse> listenEncrypt(ServerRequest serverRequest) {
        var id = UUID.randomUUID().toString();

        return Mono.defer(() -> Mono.just(Encryption.encrypt(id, algorithm)))
          .subscribeOn(Schedulers.boundedElastic())
          .flatMap(r -> ServerResponse.ok().bodyValue(r));
    }

    public Mono<ServerResponse> listenDecrypt(ServerRequest serverRequest) {
        var text = "kbWsLOHjA42nNzWfxhZBhK/98tLmVu/rOotn3VCSinozMp0LYJFSBe2bPN9liMBVX8/qDV7191kgfF4dVUh6sJCsR3DqBI/yTchXLffpA7I3oho2NpKrEP/3MwuJ30RrmrL58U9++W3V9LZcxCygRK9intSAkUP90vWpy0DLSLcgR8e3LEQbo9f8omMvJlWDMyTTeBv656HgKexDWDBHG9EHVui4sKuadmWJurvZyg+5yDSFq9PPyr5bHMRGK6/av3xSFumqYwDW2jlpU0J5nYbJZZqbxVV0fOKqlbP/izqgapu7bksc/+BSmha6HGH+2YqBA85JKIVQTF+oHzIOBQ==";

        return Mono.defer(() -> Mono.just(Encryption.decrypt(text, algorithm)))
          .subscribeOn(Schedulers.boundedElastic())
          .flatMap(r -> ServerResponse.ok().bodyValue(r));
    }

    public Mono<ServerResponse> listenEncripAndDecrypt(ServerRequest serverRequest) {
        return Mono.just(UUID.randomUUID().toString())
          .publishOn(Schedulers.boundedElastic())
          .map(text -> Encryption.encrypt(text, algorithm))
          .map(cypher -> Encryption.decrypt(cypher, algorithm))
          .flatMap(r -> ServerResponse.ok().bodyValue(r));
    }
}
