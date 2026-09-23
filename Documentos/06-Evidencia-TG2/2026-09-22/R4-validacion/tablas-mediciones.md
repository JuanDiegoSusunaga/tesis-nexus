**Tabla 6.10 — Serie R4: firmas clásicas, tiempos en microsegundos.**

| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |
|---|---:|---:|---:|
| Generación / ECDSA P-256 | 50 | 72,25 | 71,42–72,98 |
| Generación / RSA-2048 | 10 | 101588,03 | 78184,57–126318,48 |
| Firma / ECDSA P-256 | 50 | 88,03 | 86,73–89,05 |
| Firma / RSA-2048 | 50 | 792,96 | 783,55–799,45 |
| Firma / RSA-3072 | 50 | 2433,76 | 2411,85–2456,75 |
| Verificación / ECDSA P-256 | 50 | 149,05 | 147,84–152,56 |
| Verificación / RSA-2048 | 50 | 98,07 | 97,24–99,89 |
| Verificación / RSA-3072 | 50 | 221,01 | 219,07–222,22 |


**Tabla 6.11 — Serie R4: residencia y expansión de claves, tiempos en microsegundos.**

| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |
|---|---:|---:|---:|
| Firma cacheada / dilithium2 | 50 | 202,28 | 197,61–207,34 |
| Firma cacheada / dilithium3 | 50 | 327,42 | 325,39–334,82 |
| Firma cacheada / dilithium5 | 50 | 391,07 | 376,61–398,69 |
| Firma efímera / dilithium2 | 50 | 295,94 | 292,32–300,22 |
| Firma efímera / dilithium3 | 50 | 478,74 | 466,55–490,96 |
| Firma efímera / dilithium5 | 50 | 605,03 | 598,99–617,64 |
| Expansión / dilithium2 | 50 | 90,42 | 89,58–91,90 |
| Expansión / dilithium3 | 50 | 145,03 | 143,97–146,40 |
| Expansión / dilithium5 | 50 | 215,83 | 212,68–219,23 |


**Tabla 6.12 — Serie R4: STARK; mediana [mínimo–máximo] de cinco repeticiones.**

| Filas del AIR | Prueba (KiB) | Generación (ms) | Verificación (ms) |
|---:|---:|---:|---:|
| 16 | 128,98 | 111,97 [4,64–738,40] | 1,31 [1,21–1,96] |
| 64 | 190,29 | 337,00 [56,61–579,79] | 1,76 [1,73–2,05] |
| 256 | 261,60 | 339,51 [143,61–1370,42] | 2,45 [2,26–3,18] |
| 1024 | 342,91 | 247,68 [44,29–644,78] | 2,99 [2,88–4,88] |
| 4096 | 434,23 | 221,57 [171,85–413,06] | 3,62 [3,54–4,53] |
| 16384 | 535,54 | 721,48 [594,79–1135,98] | 5,56 [4,37–7,37] |
| 65536 | 646,85 | 3174,19 [2248,91–3600,72] | 6,39 [5,13–8,20] |
| 262144 | 768,16 | 14001,55 [9674,23–14251,98] | 7,79 [6,04–8,64] |
