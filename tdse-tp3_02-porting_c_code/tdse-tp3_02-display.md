# TP3 - Actividad 02 - LCD Display Statechart

## Medición de tiempos de ejecución

Luego de varias ejecuciones de `app_update()`, se observaron los siguientes
valores de `task_dta_list[index]` mediante el depurador de STM32CubeIDE:

| Índice | Tarea | NOE [ejecuciones] | LET [µs] | BCET [µs] | WCET [µs] |
|:------:|:------|------------------:|---------:|----------:|----------:|
| 0 | `task_display` | 15199 | 2 | 2 | 221 |
| 1 | `task_test` | 15202 | 2 | 2 | 36 |

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

La pequeña diferencia entre los valores de NOE se debe a que el depurador
actualiza las expresiones de manera secuencial mientras el programa continúa en
ejecución.

## Análisis de las restricciones temporales

El ejecutor cíclico tiene un período de 1 ms, equivalente a 1000 µs. Como ambas
tareas se ejecutan en cada ciclo, debe cumplirse:

```text
WCET(task_display) + WCET(task_test) <= 1000 µs
```

Con los valores observados:

```text
221 µs + 36 µs = 257 µs
```

El peor caso conjunto utiliza aproximadamente el 25,7 % del período y deja un
margen temporal de 743 µs:

```text
1000 µs - 257 µs = 743 µs
```

Por lo tanto, las tareas **cumplen** las restricciones temporales del ejecutor
cíclico de 1 ms.

## Conclusión

La máquina de estados de `task_display` distribuye la actualización del LCD a
lo largo de varias ejecuciones. En cada ciclo escribe como máximo una
instrucción o un carácter, en lugar de actualizar las dos líneas completas de
forma bloqueante. Esta implementación reduce el WCET del display y evita el
incumplimiento temporal observado en la Actividad 1.

Perceptivamente, el display continúa funcionando correctamente. La escritura
completa requiere varios ciclos de 1 ms, pero la duración total es lo
suficientemente pequeña como para que el usuario no perciba el proceso carácter
por carácter. De esta manera se conserva el comportamiento visible y, al mismo
tiempo, se respeta formalmente el período del ejecutor cíclico.
