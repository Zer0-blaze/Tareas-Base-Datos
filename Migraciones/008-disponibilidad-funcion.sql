set search_path to cine;

create or replace view vista_disponibilidad_funcion as
select
    f.funcion_id,
    p.titulo as pelicula,
    s.nombre as sala,
    f.fecha_hora_inicio,
    f.fecha_hora_fin,
    s.capacidad,
    count(distinct e.entrada_id) as entradas_vendidas,
    s.capacidad - count(distinct e.entrada_id) as asientos_disponibles,
    array_agg(distinct a.identificador order by a.identificador) 
        filter (where a.asiento_id not in (
            select asiento_id from cine.entrada where funcion_id = f.funcion_id
        )) as asientos_libres,
    coalesce(sum(e.monto_pagado), 0) as total_recaudado
from cine.funcion f
join cine.pelicula p on p.pelicula_id = f.pelicula_id
join cine.sala s on s.sala_id = f.sala_id
join cine.asiento a on a.sala_id = s.sala_id
left join cine.entrada e on e.funcion_id = f.funcion_id
group by f.funcion_id, p.titulo, s.nombre, f.fecha_hora_inicio, f.fecha_hora_fin, s.capacidad;

insert into schema_migrations (version) values ('008-disponibilidad-funcion');

commit;