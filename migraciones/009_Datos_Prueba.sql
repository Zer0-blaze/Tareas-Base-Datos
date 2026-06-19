INSERT INTO pelicula (pelicula_id, titulo, duracion_min, genero) VALUES
(DEFAULT, 'Profesor Diego El Reboot', 166, 'Drama Peruano'),
(DEFAULT, 'Profesor Diego Animado', 94, 'Animación y Accion'),
(DEFAULT, 'Profesor Diego El Renacimiento', 115, 'Acción, Drama, Comedia Boliviana'),
(DEFAULT, 'Profesor Diego vs Los Chamos', 96, 'Accion, Hentai y Terror');

INSERT INTO sala (sala_id, nombre, capacidad) VALUES
(DEFAULT, 'Sala 1 - IMAX', 250),
(DEFAULT, 'Sala 2 - 3D', 150),
(DEFAULT, 'Sala 3 - Estándar', 100);

insert into cine.cliente (nombre, rut, email) 
values ('Ramon Laferte', '11222333-9', 'progamer@email.com');
insert into cine.cliente (nombre, rut, email) 
values ('Hatsune Miku', '15666777-3', 'miku@email.com');
insert into cine.cliente (nombre, rut, email) 
values ('Marco Antonio Solis', '1899903-K', 'marco@email.com');
insert into cine.cliente (nombre, rut, email) 
values ('Jordi ENP', '20111222-2', 'jordi@email.com');

INSERT INTO asiento (asiento_id, sala_id, identificador) VALUES
(DEFAULT, 1, 'A1'), (DEFAULT, 1, 'A2'), (DEFAULT, 1, 'A3'),
(DEFAULT, 2, 'A1'), (DEFAULT, 2, 'A2'), (DEFAULT, 2, 'B1'),
(DEFAULT, 3, 'C1'), (DEFAULT, 3, 'C2');

INSERT INTO funcion (funcion_id, sala_id, pelicula_id, fecha_hora_inicio, precio, fecha_hora_fin) VALUES
(DEFAULT, 1, 1, '2026-06-20 18:00:00', 7500.00, '2026-06-20 20:46:00'),
(DEFAULT, 2, 4, '2026-06-20 16:30:00', 5000.00, '2026-06-20 18:06:00'),
(DEFAULT, 3, 3, '2026-06-20 21:00:00', 4500.00, '2026-06-20 22:55:00');

INSERT INTO entrada (entrada_id, funcion_id, cliente_id, asiento_id, fecha_venta, monto_pagado) VALUES
(DEFAULT, 1, 1, 1, '2026-06-18 10:15:00', 7500.00),
(DEFAULT, 1, 2, 2, '2026-06-18 10:16:00', 7500.00),
(DEFAULT, 2, 3, 6, '2026-06-18 11:30:00', 5000.00),
(DEFAULT, 3, 4, 8, '2026-06-18 12:45:00', 4500.00);

INSERT INTO schema_migrations (version) VALUES ('009-Datos-Prueba');