# TP3 - Actividad 04 - System Setup Menu Statechart

## Verificación funcional

El proyecto `tdse-tp3_03-system_setup_menu` fue compilado y depurado en
STM32CubeIDE. Durante la ejecución se verificó la navegación del menú mediante
los botones `Enter`, `Next` y `Escape`, junto con la actualización de los
mensajes en el LCD.

El comportamiento implementado es el siguiente:

- `Enter` avanza al siguiente nivel del menú y guarda la configuración desde
  el nivel de edición de valores.
- `Next` recorre los motores, los parámetros o los valores disponibles.
- `Escape` vuelve al nivel anterior y, desde `Main`, sale del modo de
  configuración.
- El botón azul `B1` permite entrar o salir del modo `SETUP`.

## Medición de tiempos de ejecución

Luego de varias ejecuciones de `app_update()`, se observaron los siguientes
valores de `task_dta_list[index]` mediante el depurador de STM32CubeIDE:

| Índice | Tarea | NOE [ejecuciones] | LET [µs] | BCET [µs] | WCET [µs] |
|:------:|:------|------------------:|---------:|----------:|----------:|
| 0 | `task_sensor` | 67341 | 12 | 12 | 14 |
| 1 | `task_system` | 67345 | 2 | 2 | 78 |
| 2 | `task_actuator` | 67348 | 3 | 2 | 4 |
| 3 | `task_display` | 67350 | 2 | 2 | 78 |

La correspondencia entre los índices y las tareas surge del orden de
`task_cfg_list` en `app/src/app.c` del proyecto
`tdse-tp3_03-system_setup_menu`.

### Significado de las mediciones

- **NOE** (`Number of Executions`): cantidad de ejecuciones de la tarea; no
  posee unidad física.
- **LET** (`Last Execution Time`): duración de la última ejecución, expresada
  en microsegundos.
- **BCET** (`Best-Case Execution Time`): menor tiempo de ejecución registrado,
  expresado en microsegundos.
- **WCET** (`Worst-Case Execution Time`): mayor tiempo de ejecución registrado,
  expresado en microsegundos.

Las pequeñas diferencias entre los valores de NOE se deben a que el depurador
actualiza las expresiones de manera secuencial mientras el programa continúa en
ejecución.

## Análisis de las restricciones temporales

El ejecutor cíclico tiene un período de 1 ms, equivalente a 1000 µs. Las cuatro
tareas se ejecutan en cada ciclo, por lo que debe cumplirse:

```text
WCET(sensor) + WCET(system) + WCET(actuator) + WCET(display) <= 1000 µs
```

Con los valores observados:

```text
14 µs + 78 µs + 4 µs + 78 µs = 174 µs
```

El peor caso conjunto utiliza aproximadamente el 17,4 % del período y deja un
margen temporal de 826 µs:

```text
1000 µs - 174 µs = 826 µs
```

Por lo tanto, las cuatro tareas **cumplen** las restricciones temporales del
ejecutor cíclico de 1 ms. Incluso considerando simultáneamente los WCET de todas
las tareas, la ejecución termina con un margen amplio antes del siguiente tick.

## Conclusión

La implementación del menú mantiene tiempos de ejecución acotados. La lectura
con antirrebote de los botones, el procesamiento de la máquina de estados, la
actualización de los actuadores y la escritura no bloqueante del LCD pueden
completarse dentro del período de 1 ms. El comportamiento perceptible es
correcto y las mediciones confirman también el cumplimiento temporal formal.
