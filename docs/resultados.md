# Resultados de las consultas

Resultados obtenidos al ejecutar `sql/03_consultas.sql` sobre los datos de `sql/02_poblar.sql` (PostgreSQL).


## 1. Obtener el código y el nombre de los clientes que no tienen ciudad registrada, ordenados por nombre.

| cod_cli | nombre |
|---|---|
| C008 | Clínica Dental Vera |
| C011 | Mercados Huerta Norte S.L. |


## 2. Obtener, para cada sector, el número de proyectos y el importe total contratado, de mayor a menor importe.

| sector | num_proyectos | importe_total |
|---|---|---|
| Energía | 3 | 48600.00 |
| Comercio | 3 | 39700.00 |
| Industria | 4 | 37700.00 |
| Educación | 4 | 24500.00 |
| Administración pública | 2 | 21700.00 |
| Sanidad y farmacia | 2 | 9100.00 |
| Otro | 2 | 9000.00 |


## 3. Obtener los proyectos que han consumido más horas de las presupuestadas, con las horas presupuestadas, las reales y la desviación, de mayor a menor desviación.

| cod_pro | nombre | horas_presup | horas_reales | desviacion_horas |
|---|---|---|---|---|
| P0009 | Cuadro de mando municipal | 220 | 350.0 | 130.0 |
| P0011 | Modelo de previsión de demanda | 240 | 305.0 | 65.0 |
| P0003 | Implantación de Lean en el taller | 160 | 192.5 | 32.5 |
| P0014 | Agenda y flujo de pacientes | 80 | 103.5 | 23.5 |
| P0013 | Indicadores de impacto social | 90 | 92.0 | 2.0 |


## 4. Obtener el margen de los proyectos ya cerrados: importe, coste de personal, margen en euros y margen en porcentaje, del menos rentable al más rentable.

| cod_pro | nombre | importe | coste_personal | margen | margen_pct |
|---|---|---|---|---|---|
| P0009 | Cuadro de mando municipal | 15400.00 | 16920.00 | -1520.00 | -9.9 |
| P0014 | Agenda y flujo de pacientes | 5200.00 | 3127.00 | 2073.00 | 39.9 |
| P0011 | Modelo de previsión de demanda | 19200.00 | 11190.00 | 8010.00 | 41.7 |
| P0003 | Implantación de Lean en el taller | 10400.00 | 6035.00 | 4365.00 | 42.0 |
| P0013 | Indicadores de impacto social | 5400.00 | 3020.00 | 2380.00 | 44.1 |
| P0006 | Optimización de rutas de reparto | 10500.00 | 5765.00 | 4735.00 | 45.1 |
| P0010 | Rediseño del proceso de matrícula | 4200.00 | 2224.00 | 1976.00 | 47.0 |
| P0004 | Digitalización del almacén | 11700.00 | 6050.00 | 5650.00 | 48.3 |
| P0002 | Cuadro de mando de ventas | 15000.00 | 7390.00 | 7610.00 | 50.7 |
| P0001 | Diagnóstico de procesos administrativos | 7800.00 | 3661.00 | 4139.00 | 53.1 |
| P0008 | Auditoría de procesos de calidad | 9100.00 | 4025.00 | 5075.00 | 55.8 |
| P0007 | Control de stock en farmacia | 3900.00 | 1640.50 | 2259.50 | 57.9 |
| P0005 | Análisis de satisfacción de familias | 4800.00 | 2004.00 | 2796.00 | 58.3 |
| P0012 | Reducción de tiempos de cambio (SMED) | 6500.00 | 2565.00 | 3935.00 | 60.5 |


## 5. Obtener el código, el nombre y la categoría de los empleados que no han imputado ninguna hora.

| cod_emp | nombre | categoria |
|---|---|---|
| E010 | Nuria Climent Sales | Becario |


## 6. Obtener los proyectos cuyo responsable ya no trabaja en la consultora, con el nombre del responsable y el nombre del cliente.

| cod_pro | proyecto | responsable | cliente | anio |
|---|---|---|---|---|
| P0003 | Implantación de Lean en el taller | Sergio Blasco Ortiz | Talleres Hermanos Puig S.L. | 2023 |
| P0004 | Digitalización del almacén | Sergio Blasco Ortiz | Cerámicas Levante S.A. | 2023 |
| P0008 | Auditoría de procesos de calidad | Sergio Blasco Ortiz | Cerámicas Levante S.A. | 2024 |


## 7. Obtener, para cada año, las horas imputadas, el coste de personal y el coste medio por hora, ordenado por año.

| anio | horas | coste_personal | coste_medio_hora |
|---|---|---|---|
| 2023 | 740.0 | 25140.00 | 33.97 |
| 2024 | 743.5 | 30574.50 | 41.12 |
| 2025 | 695.5 | 24824.50 | 35.69 |
| 2026 | 297.5 | 10964.75 | 36.86 |

