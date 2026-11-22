-- =====================================================================
-- BASE DE DATOS «CONSULTORA» · Script 1 de 2: creación de las tablas
-- Autor: Fernando Chust Piles
-- Dialecto: PostgreSQL · Codificación del fichero: UTF-8
--
-- Escenario: una consultora trabaja para varios clientes. Cada cliente
-- encarga proyectos con unas horas presupuestadas y un importe. Cada
-- proyecto tiene un empleado responsable, y los empleados imputan horas
-- a los proyectos al coste por hora que tenían en ese momento.
--
-- Leyenda de los comentarios (como en el script de clase):
--   CP = clave primaria · CAj = clave ajena · VNN = valor no nulo
--   Uni = unicidad · RI = restricción de integridad general (CHECK)
-- =====================================================================

CREATE SCHEMA IF NOT EXISTS consultora;
SET search_path TO consultora;

-- Borrado previo, para poder ejecutar el script varias veces.
-- Orden inverso al de creación: primero las tablas que apuntan a otras.
DROP TABLE IF EXISTS imputacion;
DROP TABLE IF EXISTS proyecto;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS cliente;

-- ---------------------------------------------------------------------
-- CLIENTE: empresas u organizaciones para las que se trabaja
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    cod_cli  CHAR(4),
    nombre   VARCHAR(80) NOT NULL,               -- VNN
    tipo     VARCHAR(20) NOT NULL,               -- VNN
    sector   VARCHAR(30) NOT NULL,               -- VNN
    ciudad   VARCHAR(40),                        -- admite nulos a propósito
    activo   BOOLEAN NOT NULL DEFAULT TRUE,      -- VNN: ¿sigue siendo cliente?
    CONSTRAINT pk_cliente PRIMARY KEY (cod_cli),                     -- CP
    CONSTRAINT uni_nombre_cli UNIQUE (nombre),                       -- Uni
    CONSTRAINT ri1_tipo_cli CHECK (tipo IN
        ('Autónomo', 'Pyme', 'Gran empresa', 'Sin lucro', 'Otro')),  -- RI1
    CONSTRAINT ri2_sector_cli CHECK (sector IN
        ('Educación', 'Sanidad y farmacia', 'Energía', 'Industria',
         'Comercio', 'Administración pública', 'Otro'))                -- RI2
);

-- ---------------------------------------------------------------------
-- EMPLEADO: personal de la consultora
-- ---------------------------------------------------------------------
CREATE TABLE empleado (
    cod_emp     CHAR(4),
    nombre      VARCHAR(80) NOT NULL,            -- VNN
    categoria   VARCHAR(10) NOT NULL,            -- VNN
    coste_hora  NUMERIC(6,2) NOT NULL,           -- VNN: coste por hora ACTUAL
    activo      BOOLEAN NOT NULL DEFAULT TRUE,   -- VNN: ¿sigue en la empresa?
    CONSTRAINT pk_empleado PRIMARY KEY (cod_emp),                    -- CP
    CONSTRAINT ri3_categoria_emp CHECK (categoria IN
        ('Becario', 'Junior', 'Senior', 'Socio')),                   -- RI3
    CONSTRAINT ri4_coste_emp CHECK (coste_hora > 0)                  -- RI4
);

-- ---------------------------------------------------------------------
-- PROYECTO: encargos de los clientes
-- ---------------------------------------------------------------------
CREATE TABLE proyecto (
    cod_pro       CHAR(5),
    nombre        VARCHAR(80) NOT NULL,          -- VNN
    cod_cli       CHAR(4) NOT NULL,              -- VNN: todo proyecto tiene cliente
    responsable   CHAR(4) NOT NULL,              -- VNN: todo proyecto tiene responsable
    anio          INTEGER NOT NULL,              -- VNN: año de inicio del proyecto
    horas_presup  INTEGER NOT NULL,              -- VNN: horas vendidas al cliente
    importe       NUMERIC(10,2) NOT NULL,        -- VNN: importe contratado (euros)
    activo        BOOLEAN NOT NULL DEFAULT TRUE, -- VNN: ¿sigue en curso?
    CONSTRAINT pk_proyecto PRIMARY KEY (cod_pro),                    -- CP
    CONSTRAINT fk_pro_cli FOREIGN KEY (cod_cli)
        REFERENCES cliente (cod_cli)
        ON DELETE RESTRICT ON UPDATE CASCADE,                        -- CAj
    CONSTRAINT fk_pro_resp FOREIGN KEY (responsable)
        REFERENCES empleado (cod_emp)
        ON DELETE RESTRICT ON UPDATE CASCADE,                        -- CAj
    CONSTRAINT ri5_anio_pro CHECK (anio BETWEEN 2022 AND 2026),      -- RI5
    CONSTRAINT ri6_horas_pro CHECK (horas_presup > 0),               -- RI6
    CONSTRAINT ri7_importe_pro CHECK (importe > 0)                   -- RI7
);

-- ---------------------------------------------------------------------
-- IMPUTACION: horas totales de cada empleado en cada proyecto (N:M)
-- coste_hora guarda el coste que tenía el empleado al trabajar en ese
-- proyecto, para que los márgenes históricos no cambien si sube su coste.
-- ---------------------------------------------------------------------
CREATE TABLE imputacion (
    cod_emp     CHAR(4),
    cod_pro     CHAR(5),
    horas       NUMERIC(5,1) NOT NULL,           -- VNN: admite medias horas
    coste_hora  NUMERIC(6,2) NOT NULL,           -- VNN: coste por hora APLICADO
    CONSTRAINT pk_imputacion PRIMARY KEY (cod_emp, cod_pro),         -- CP
    CONSTRAINT fk_imp_emp FOREIGN KEY (cod_emp)
        REFERENCES empleado (cod_emp)
        ON DELETE RESTRICT ON UPDATE CASCADE,                        -- CAj
    CONSTRAINT fk_imp_pro FOREIGN KEY (cod_pro)
        REFERENCES proyecto (cod_pro)
        ON DELETE CASCADE ON UPDATE CASCADE,                         -- CAj
    CONSTRAINT ri8_horas_imp CHECK (horas > 0),                      -- RI8
    CONSTRAINT ri9_coste_imp CHECK (coste_hora > 0)                  -- RI9
);
