-- =====================================================================
-- BASE DE DATOS «CONSULTORA» · Script 2 de 2: datos
-- Autor: Fernando Chust Piles
-- Dialecto: PostgreSQL · Codificación: UTF-8. Ejecutar DESPUÉS de 01_crear.sql.
--
-- Datos sintéticos (inventados), coherentes entre sí:
--   12 clientes + 10 empleados + 20 proyectos + 45 imputaciones = 87 filas.
-- Los nombres de clientes y empleados son ficticios.
-- =====================================================================

SET search_path TO consultora;

-- Vaciado previo, para poder ejecutar el script varias veces.
-- Mismo orden que el borrado de tablas: primero las que apuntan a otras.
DELETE FROM imputacion;
DELETE FROM proyecto;
DELETE FROM empleado;
DELETE FROM cliente;

-- Orden de inserción: primero las tablas referenciadas (cliente, empleado),
-- después las que contienen claves ajenas (proyecto, imputacion).

-- ---------------------------------------------------------------------
-- CLIENTE (12 filas)
-- C008 y C011 sin ciudad registrada · C010 ya no es cliente (activo = FALSE)
-- C012 es cliente activo pero aún no tiene proyectos
-- ---------------------------------------------------------------------
INSERT INTO cliente (cod_cli, nombre, tipo, sector, ciudad, activo) VALUES
    ('C001', 'Colegio Sant Josep Obrer', 'Sin lucro', 'Educación', 'Valencia', TRUE),
    ('C002', 'Farmacia Lledó Gil', 'Autónomo', 'Sanidad y farmacia', 'Castellón', TRUE),
    ('C003', 'Energías del Turia S.A.', 'Gran empresa', 'Energía', 'Valencia', TRUE),
    ('C004', 'Talleres Hermanos Puig S.L.', 'Pyme', 'Industria', 'Alzira', TRUE),
    ('C005', 'Ayuntamiento de Benimar', 'Otro', 'Administración pública', 'Benimar', TRUE),
    ('C006', 'Fundación Mar de Luz', 'Sin lucro', 'Otro', 'Valencia', TRUE),
    ('C007', 'Distribuciones Albufera S.L.', 'Pyme', 'Comercio', 'Silla', TRUE),
    ('C008', 'Clínica Dental Vera', 'Pyme', 'Sanidad y farmacia', NULL, TRUE),
    ('C009', 'Academia de Idiomas Delta', 'Autónomo', 'Educación', 'Paterna', TRUE),
    ('C010', 'Cerámicas Levante S.A.', 'Gran empresa', 'Industria', 'Castellón', FALSE),
    ('C011', 'Mercados Huerta Norte S.L.', 'Pyme', 'Comercio', NULL, TRUE),
    ('C012', 'Asociación Cultural Riu Blau', 'Sin lucro', 'Otro', 'Valencia', TRUE);

-- ---------------------------------------------------------------------
-- EMPLEADO (10 filas) · coste_hora = coste ACTUAL (2026)
-- E009 dejó la empresa a finales de 2024 (activo = FALSE): su coste es el último que tuvo
-- E010 se incorporó en 2026 y aún no ha imputado horas
-- ---------------------------------------------------------------------
INSERT INTO empleado (cod_emp, nombre, categoria, coste_hora, activo) VALUES
    ('E001', 'Lucía Ferrer Mas', 'Socio', 75.00, TRUE),
    ('E002', 'Andrés Navarro Gil', 'Socio', 72.00, TRUE),
    ('E003', 'Marta Ruiz Peris', 'Senior', 42.50, TRUE),
    ('E004', 'Javier Soler Bosch', 'Senior', 40.00, TRUE),
    ('E005', 'Pilar Domínguez Sanz', 'Senior', 43.00, TRUE),
    ('E006', 'Carlos Martí Vidal', 'Junior', 25.50, TRUE),
    ('E007', 'Elena Gómez Roig', 'Junior', 24.00, TRUE),
    ('E008', 'Raúl Pastor Llorens', 'Becario', 12.50, TRUE),
    ('E009', 'Sergio Blasco Ortiz', 'Senior', 38.50, FALSE),
    ('E010', 'Nuria Climent Sales', 'Becario', 12.00, TRUE);

-- ---------------------------------------------------------------------
-- PROYECTO (20 filas, 5 por año de 2023 a 2026)
-- Activos: los de 2026 y P0015 (empezó en 2025 y sigue en curso)
-- ---------------------------------------------------------------------
INSERT INTO proyecto (cod_pro, nombre, cod_cli, responsable, anio, horas_presup, importe, activo) VALUES
    ('P0001', 'Diagnóstico de procesos administrativos', 'C001', 'E003', 2023, 120, 7800.00, FALSE),
    ('P0002', 'Cuadro de mando de ventas', 'C003', 'E001', 2023, 200, 15000.00, FALSE),
    ('P0003', 'Implantación de Lean en el taller', 'C004', 'E009', 2023, 160, 10400.00, FALSE),
    ('P0004', 'Digitalización del almacén', 'C010', 'E009', 2023, 180, 11700.00, FALSE),
    ('P0005', 'Análisis de satisfacción de familias', 'C001', 'E004', 2023, 80, 4800.00, FALSE),
    ('P0006', 'Optimización de rutas de reparto', 'C007', 'E002', 2024, 150, 10500.00, FALSE),
    ('P0007', 'Control de stock en farmacia', 'C002', 'E005', 2024, 60, 3900.00, FALSE),
    ('P0008', 'Auditoría de procesos de calidad', 'C010', 'E009', 2024, 140, 9100.00, FALSE),
    ('P0009', 'Cuadro de mando municipal', 'C005', 'E001', 2024, 220, 15400.00, FALSE),
    ('P0010', 'Rediseño del proceso de matrícula', 'C009', 'E003', 2024, 70, 4200.00, FALSE),
    ('P0011', 'Modelo de previsión de demanda', 'C003', 'E002', 2025, 240, 19200.00, FALSE),
    ('P0012', 'Reducción de tiempos de cambio (SMED)', 'C004', 'E004', 2025, 100, 6500.00, FALSE),
    ('P0013', 'Indicadores de impacto social', 'C006', 'E005', 2025, 90, 5400.00, FALSE),
    ('P0014', 'Agenda y flujo de pacientes', 'C008', 'E003', 2025, 80, 5200.00, FALSE),
    ('P0015', 'Rentabilidad por línea de producto', 'C011', 'E001', 2025, 120, 8400.00, TRUE),
    ('P0016', 'Migración del ERP de ventas', 'C007', 'E002', 2026, 260, 20800.00, TRUE),
    ('P0017', 'Cuadro de mando de dirección escolar', 'C001', 'E005', 2026, 110, 7700.00, TRUE),
    ('P0018', 'Análisis de consumos energéticos', 'C003', 'E004', 2026, 180, 14400.00, TRUE),
    ('P0019', 'Encuesta de satisfacción ciudadana', 'C005', 'E003', 2026, 90, 6300.00, TRUE),
    ('P0020', 'Inventario de fondos documentales', 'C006', 'E004', 2026, 60, 3600.00, TRUE);

-- ---------------------------------------------------------------------
-- IMPUTACION (45 filas) · coste_hora = coste APLICADO: el que tenía el
-- empleado el año del proyecto (por eso cambia según el año)
-- ---------------------------------------------------------------------
INSERT INTO imputacion (cod_emp, cod_pro, horas, coste_hora) VALUES
    ('E003', 'P0001', 70.0, 38.00),
    ('E006', 'P0001', 45.5, 22.00),
    ('E001', 'P0002', 40.0, 68.00),
    ('E004', 'P0002', 90.0, 36.00),
    ('E006', 'P0002', 65.0, 22.00),
    ('E009', 'P0003', 120.0, 37.00),
    ('E006', 'P0003', 72.5, 22.00),
    ('E009', 'P0004', 110.0, 37.00),
    ('E004', 'P0004', 55.0, 36.00),
    ('E004', 'P0005', 30.0, 36.00),
    ('E006', 'P0005', 42.0, 22.00),
    ('E002', 'P0006', 35.0, 67.00),
    ('E003', 'P0006', 60.0, 39.50),
    ('E007', 'P0006', 50.0, 21.00),
    ('E005', 'P0007', 25.0, 40.00),
    ('E007', 'P0007', 30.5, 21.00),
    ('E009', 'P0008', 80.0, 38.50),
    ('E007', 'P0008', 45.0, 21.00),
    ('E001', 'P0009', 150.0, 70.00),
    ('E003', 'P0009', 120.0, 39.50),
    ('E007', 'P0009', 80.0, 21.00),
    ('E003', 'P0010', 40.0, 39.50),
    ('E006', 'P0010', 28.0, 23.00),
    ('E002', 'P0011', 60.0, 69.00),
    ('E004', 'P0011', 110.0, 39.00),
    ('E006', 'P0011', 95.0, 24.00),
    ('E008', 'P0011', 40.0, 12.00),
    ('E004', 'P0012', 55.0, 39.00),
    ('E008', 'P0012', 35.0, 12.00),
    ('E005', 'P0013', 50.0, 41.50),
    ('E007', 'P0013', 42.0, 22.50),
    ('E003', 'P0014', 65.0, 41.00),
    ('E008', 'P0014', 38.5, 12.00),
    ('E001', 'P0015', 30.0, 72.00),
    ('E005', 'P0015', 55.0, 41.50),
    ('E006', 'P0015', 20.0, 24.00),
    ('E002', 'P0016', 25.0, 72.00),
    ('E004', 'P0016', 60.0, 40.00),
    ('E007', 'P0016', 48.0, 24.00),
    ('E005', 'P0017', 30.0, 43.00),
    ('E008', 'P0017', 22.0, 12.50),
    ('E004', 'P0018', 40.0, 40.00),
    ('E006', 'P0018', 35.5, 25.50),
    ('E003', 'P0019', 25.0, 42.50),
    ('E004', 'P0020', 12.0, 40.00);

-- ---------------------------------------------------------------------
-- Comprobación: número de filas por tabla (esperado 12, 10, 20, 45)
-- ---------------------------------------------------------------------
SELECT 'cliente' AS tabla, count(*) AS filas FROM cliente
UNION ALL SELECT 'empleado', count(*) FROM empleado
UNION ALL SELECT 'proyecto', count(*) FROM proyecto
UNION ALL SELECT 'imputacion', count(*) FROM imputacion;
