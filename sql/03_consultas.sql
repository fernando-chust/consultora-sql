-- =====================================================================
-- BASE DE DATOS «CONSULTORA» · Consultas
-- Autor: Fernando Chust Piles
-- Dialecto: PostgreSQL · Codificación: UTF-8. Requiere haber ejecutado 01_crear.sql
-- y 02_poblar.sql.
--
-- Cada consulta incluye: enunciado, explicación breve y solución.
-- Las consultas 2, 3, 4 y 7 usan JOIN y GROUP BY.
-- =====================================================================

SET search_path TO consultora;


-- ---------------------------------------------------------------------
-- 1. Obtener el código y el nombre de los clientes que no tienen ciudad
--    registrada, ordenados por nombre.
--
-- Explicación: la ciudad es el único dato de cliente que admite nulos.
-- Para buscar valores nulos se usa IS NULL; la comparación «= NULL» no
-- funcionaría, porque cualquier comparación con NULL da «desconocido».
-- ---------------------------------------------------------------------
SELECT cod_cli, nombre
FROM cliente
WHERE ciudad IS NULL
ORDER BY nombre;


-- ---------------------------------------------------------------------
-- 2. Obtener, para cada sector, el número de proyectos y el importe total
--    contratado, de mayor a menor importe.
--
-- Explicación: el sector está en CLIENTE y el importe en PROYECTO, así que
-- uno las dos tablas por el código de cliente (JOIN) y agrupo por sector
-- (GROUP BY), contando proyectos y sumando importes. Los clientes sin
-- proyectos no aparecen, porque el JOIN interno solo conserva las
-- combinaciones que existen.
-- ---------------------------------------------------------------------
SELECT c.sector,
       count(p.cod_pro) AS num_proyectos,
       sum(p.importe)   AS importe_total
FROM cliente c
JOIN proyecto p ON p.cod_cli = c.cod_cli
GROUP BY c.sector
ORDER BY importe_total DESC;


-- ---------------------------------------------------------------------
-- 3. Obtener los proyectos que han consumido más horas de las
--    presupuestadas, con las horas presupuestadas, las reales y la
--    desviación, de mayor a menor desviación.
--
-- Explicación: las horas reales son la suma de las imputaciones de cada
-- proyecto, así que uno PROYECTO con IMPUTACION y agrupo por proyecto.
-- Como la condición se aplica a un total (la suma de horas), va en HAVING
-- y no en WHERE: WHERE filtra filas antes de agrupar y HAVING filtra
-- grupos después de sumar. Incluyo horas_presup en el GROUP BY porque es
-- un dato del proyecto que quiero mostrar.
-- ---------------------------------------------------------------------
SELECT p.cod_pro,
       p.nombre,
       p.horas_presup,
       sum(i.horas)                  AS horas_reales,
       sum(i.horas) - p.horas_presup AS desviacion_horas
FROM proyecto p
JOIN imputacion i ON i.cod_pro = p.cod_pro
GROUP BY p.cod_pro, p.nombre, p.horas_presup
HAVING sum(i.horas) > p.horas_presup
ORDER BY desviacion_horas DESC;


-- ---------------------------------------------------------------------
-- 4. Obtener el margen de los proyectos ya cerrados: importe, coste de
--    personal, margen en euros y margen en porcentaje, del menos rentable
--    al más rentable.
--
-- Explicación: el coste de cada imputación es horas × coste_hora aplicado
-- (el que tenía el empleado ese año, guardado en IMPUTACION). Sumo esos
-- costes por proyecto y se los resto al importe. Filtro los proyectos
-- cerrados (NOT activo) en el WHERE, porque los que siguen en curso aún no
-- han consumido sus horas y su margen saldría artificialmente alto.
-- Redondeo los euros a dos decimales y el porcentaje a uno. El importe va en el GROUP BY: es
-- un único valor por proyecto, así que no se suma ni se duplica.
-- ---------------------------------------------------------------------
SELECT p.cod_pro,
       p.nombre,
       p.importe,
       round(sum(i.horas * i.coste_hora), 2)             AS coste_personal,
       round(p.importe - sum(i.horas * i.coste_hora), 2) AS margen,
       round(100 * (p.importe - sum(i.horas * i.coste_hora)) / p.importe, 1)
                                               AS margen_pct
FROM proyecto p
JOIN imputacion i ON i.cod_pro = p.cod_pro
WHERE NOT p.activo
GROUP BY p.cod_pro, p.nombre, p.importe
ORDER BY margen_pct;


-- ---------------------------------------------------------------------
-- 5. Obtener el código, el nombre y la categoría de los empleados que no
--    han imputado ninguna hora.
--
-- Explicación: uso LEFT JOIN para conservar a todos los empleados aunque
-- no tengan imputaciones. Los que no tienen ninguna quedan con NULL en las
-- columnas de IMPUTACION, y esos son los que selecciono con IS NULL sobre
-- una columna de la clave primaria de IMPUTACION (que nunca es nula en una
-- fila real).
-- ---------------------------------------------------------------------
SELECT e.cod_emp, e.nombre, e.categoria
FROM empleado e
LEFT JOIN imputacion i ON i.cod_emp = e.cod_emp
WHERE i.cod_emp IS NULL;


-- ---------------------------------------------------------------------
-- 6. Obtener los proyectos cuyo responsable ya no trabaja en la
--    consultora, con el nombre del responsable y el nombre del cliente.
--
-- Explicación: uno PROYECTO con EMPLEADO a través de la columna
-- responsable, y con CLIENTE para mostrar su nombre. Como en las tres
-- tablas hay una columna «nombre», uso alias en todas. El filtro
-- NOT e.activo aprovecha que activo es booleano.
-- ---------------------------------------------------------------------
SELECT p.cod_pro,
       p.nombre AS proyecto,
       e.nombre AS responsable,
       c.nombre AS cliente,
       p.anio
FROM proyecto p
JOIN empleado e ON e.cod_emp = p.responsable
JOIN cliente  c ON c.cod_cli = p.cod_cli
WHERE NOT e.activo
ORDER BY p.anio, p.cod_pro;


-- ---------------------------------------------------------------------
-- 7. Obtener, para cada año, las horas imputadas, el coste de personal y
--    el coste medio por hora, ordenado por año.
--
-- Explicación: el año está en PROYECTO y las horas y costes en
-- IMPUTACION, así que las uno y agrupo por año. El coste medio por hora no
-- es la media simple de coste_hora, sino el coste total dividido entre las
-- horas totales (media ponderada): un empleado con muchas horas debe pesar
-- más que uno con pocas. El coste medio no solo depende de las subidas
-- salariales, sino también de quién trabaja: en 2024 sube mucho porque
-- un socio dedicó muchas horas al proyecto P0009.
-- ---------------------------------------------------------------------
SELECT p.anio,
       sum(i.horas)                                        AS horas,
       round(sum(i.horas * i.coste_hora), 2)               AS coste_personal,
       round(sum(i.horas * i.coste_hora) / sum(i.horas), 2) AS coste_medio_hora
FROM proyecto p
JOIN imputacion i ON i.cod_pro = p.cod_pro
GROUP BY p.anio
ORDER BY p.anio;
