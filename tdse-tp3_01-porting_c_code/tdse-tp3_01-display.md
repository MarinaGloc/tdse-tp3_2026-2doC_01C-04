# TP3 - Actividad 01 - LCD Display

## Medición de tiempos de ejecución

Luego de varias ejecuciones de `app_update()`, se observaron los siguientes
valores de `task_dta_list[index]` mediante el depurador de STM32CubeIDE:

| Índice | Tarea | NOE [ejecuciones] | LET [µs] | BCET [µs] | WCET [µs] |
|:------:|:------|------------------:|---------:|----------:|----------:|
| 0 | `task_test` | 1368 | 2 | 2 | 35 |
| 1 | `task_display` | 1371 | 2 | 2 | 6206 |

La correspondencia entre cada índice y su tarea surge del orden de
`task_cfg_list` en `app/src/app.c`.

### Significado de las mediciones

- **NOE** (`Number of Executions`): cantidad de veces que se ejecutó la tarea.
- **LET** (`Last Execution Time`): duración de la última ejecución, expresada en
  microsegundos.
- **BCET** (`Best-Case Execution Time`): menor tiempo de ejecución registrado,
  expresado en microsegundos.
- **WCET** (`Worst-Case Execution Time`): mayor tiempo de ejecución registrado,
  expresado en microsegundos.

## Análisis de las restricciones temporales

El ejecutor cíclico tiene un período de 1 ms, equivalente a 1000 µs. Para que
pueda ejecutar todas las tareas dentro de cada ciclo debe cumplirse:

```text
WCET(task_display) + WCET(task_test) <= 1000 µs
```

Con los valores observados:

```text
35 µs + 6206 µs = 6241 µs
```

Por lo tanto, los WCET registrados **no cumplen** la restricción temporal del
ejecutor cíclico, ya que el peor caso medido supera el período disponible en
5241 µs.

El valor de 6206 µs es muy superior al LET y al BCET de 2 µs. La medición fue
repetida y volvió a registrar el mismo WCET, por lo que no se considera un hecho
aislado. En `task_display`, el estado `ST_DSP_UPDATE` posiciona el cursor y
escribe de forma bloqueante las dos líneas completas mediante
`displayStringWrite()`. Esa actualización es la causa principal del máximo
medido. Para cumplir estrictamente el período de 1 ms será necesario dividir la
escritura del display en operaciones más pequeñas y no bloqueantes.

A pesar de este incumplimiento temporal, perceptivamente el sistema funciona
bien: el LCD se actualiza aproximadamente una vez por segundo y un atraso
ocasional de unos 6,2 ms no es apreciable para el usuario. Además, los ticks que
ocurren durante la ejecución extensa quedan pendientes y `app_update()` los
procesa posteriormente. Esto permite que el programa continúe funcionando y
que el contador avance, aunque introduce latencia y *jitter*. Por lo tanto, el
comportamiento visible es correcto, pero el sistema no satisface formalmente la
restricción temporal de 1 ms en el peor caso medido.
