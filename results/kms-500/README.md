# MsBenchmarkEncryption

### Configuración de la prueba

- Pruebas realizada con: [Performance Analyzer](https://github.com/bancolombia/distributed-performance-analyzer).
```
execution: %{
 steps: 5,
 increment: 10,
 duration: 10000,
 constant_load: false
}
```

> El objetivo de este benchmark es realizar una comparación entre el uso de KMS (AWS Key Management Service) vs la implementación de cifrado y descifrado dentro de una instancia de EC2 (c5.large) con el lenguaje Elixir utilizando ex crypto en su versión 0.10.0

### Resultados
![Encrypt](encrypt.png)
![Decrypt](decrypt.png)

Nota: En los escenarios de prueba de KMS se obtiene un promedio de 5 peticiones fallidas con el siguiente mensaje:

`ThrottlingException: You have exceeded the rate at which you may call KMS. Reduce the frequency of your calls.`

#### Costo mensual aproximado - KMS

| Precio       |                                 |
|--------------|---------------------------------|
| 1 USD        | 1 clave de KMS                  |
| 3.000 USD    | 1.000 millones solicitudes (20.000 solicitudes dentro de la capa gratuita) x 0,03 USD / 10.000 solicitudes |