set search_path to cine;

-- 1. Top 3 películas por recaudación total
select
    p.titulo,
    coalesce(sum(e.monto_pagado), 0) as total_recaudado
from cine.pelicula p
left join cine.funcion f on f.pelicula_id = p.pelicula_id
left join cine.entrada e on e.funcion_id = f.funcion_id
group by p.pelicula_id, p.titulo
order by total_recaudado desc
limit 3;

-- 2. Función con mayor porcentaje de ocupación
select
    f.funcion_id,
    p.titulo as pelicula,
    s.nombre as sala,
    f.fecha_hora_inicio,
    count(e.entrada_id) as entradas_vendidas,
    s.capacidad,
    round(count(e.entrada_id)::numeric * 100 / s.capacidad, 2) as porcentaje_ocupacion
from cine.funcion f
join cine.pelicula p on p.pelicula_id = f.pelicula_id
join cine.sala s on s.sala_id = f.sala_id
left join cine.entrada e on e.funcion_id = f.funcion_id
group by f.funcion_id, p.titulo, s.nombre, f.fecha_hora_inicio, s.capacidad
order by porcentaje_ocupacion desc
limit 1;

-- 3. Clientes que compraron entradas en 3 o más funciones distintas
select
    c.cliente_id,
    c.nombre,
    count(distinct e.funcion_id) as funciones_distintas
from cine.cliente c
join cine.entrada e on e.cliente_id = c.cliente_id
group by c.cliente_id, c.nombre
having count(distinct e.funcion_id) >= 3;

-- 4. Recaudación por sala y por día
select
    s.nombre as sala,
    date(f.fecha_hora_inicio) as dia,
    coalesce(sum(e.monto_pagado), 0) as total_recaudado
from cine.sala s
left join cine.funcion f on f.sala_id = s.sala_id
left join cine.entrada e on e.funcion_id = f.funcion_id
group by s.sala_id, s.nombre, date(f.fecha_hora_inicio)
order by s.nombre, dia;

-- 5. Películas que no tienen ninguna entrada vendida
select
    p.pelicula_id,
    p.titulo
from cine.pelicula p
left join cine.funcion f on f.pelicula_id = p.pelicula_id
left join cine.entrada e on e.funcion_id = f.funcion_id
where e.entrada_id is null;

-- 6. Horario de inicio con más entradas vendidas
select
    date_part('hour', f.fecha_hora_inicio)::int as hora_inicio,
    count(e.entrada_id) as total_entradas
from cine.funcion f
join cine.entrada e on e.funcion_id = f.funcion_id
group by date_part('hour', f.fecha_hora_inicio)
order by total_entradas desc
limit 1;

INSERT INTO schema_migrations (version) VALUES ('010-consultas');