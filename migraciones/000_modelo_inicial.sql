CREATE SCHEMA IF NOT EXISTS cine;
SET search_path TO cine;

CREATE TABLE schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS sala (
    sala_id    SERIAL PRIMARY KEY,
    nombre     TEXT NOT NULL UNIQUE,
    capacidad  INT  NOT NULL CHECK (capacidad > 0)
);

CREATE TABLE IF NOT EXISTS asiento (
    asiento_id    SERIAL PRIMARY KEY,
    sala_id       INT  NOT NULL REFERENCES sala(sala_id),
    identificador TEXT NOT NULL,
    UNIQUE (sala_id, identificador)
);

CREATE TABLE IF NOT EXISTS pelicula (
    pelicula_id  SERIAL PRIMARY KEY,
    titulo       TEXT NOT NULL,
    duracion_min INT  NOT NULL CHECK (duracion_min > 0),
    genero       TEXT
);

CREATE TABLE IF NOT EXISTS funcion (
    funcion_id       SERIAL PRIMARY KEY,
    sala_id          INT     NOT NULL REFERENCES sala(sala_id),
    pelicula_id      INT     NOT NULL REFERENCES pelicula(pelicula_id),
    fecha_hora_inicio TIMESTAMP NOT NULL,
    precio           NUMERIC(10,2) NOT NULL CHECK (precio >= 0)
    fecha_hora_fin TIMESTAMP NOT NULL,
);

CREATE TABLE IF NOT EXISTS cliente (
    cliente_id SERIAL PRIMARY KEY,
    nombre     TEXT NOT NULL,
    rut        TEXT NOT NULL UNIQUE,
    email      TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS entrada (
    entrada_id   SERIAL PRIMARY KEY,
    funcion_id   INT     NOT NULL REFERENCES funcion(funcion_id),
    cliente_id   INT     NOT NULL REFERENCES cliente(cliente_id),
    asiento_id   INT     NOT NULL REFERENCES asiento(asiento_id),
    fecha_venta  TIMESTAMP NOT NULL DEFAULT now(),
    monto_pagado NUMERIC(10,2) NOT NULL CHECK (monto_pagado >= 0),
    UNIQUE (funcion_id, asiento_id)
);

INSERT INTO schema_migrations (version) VALUES ('000-modelo-inicial');