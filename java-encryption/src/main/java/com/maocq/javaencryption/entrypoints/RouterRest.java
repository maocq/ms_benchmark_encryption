package com.maocq.javaencryption.entrypoints;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.ServerResponse;

import static org.springframework.web.reactive.function.server.RequestPredicates.GET;
import static org.springframework.web.reactive.function.server.RouterFunctions.route;

@Configuration
public class RouterRest {
    @Bean
    public RouterFunction<ServerResponse> routerFunction(Handler handler) {
        return route(GET("/hello"), handler::listen)
          .andRoute(GET("/encrypt"), handler::listenEncrypt)
          .andRoute(GET("/decrypt"), handler::listenDecrypt)
          .andRoute(GET("/encrypt-decrypt"), handler::listenEncripAndDecrypt);
    }
}
