set search_path to cine;

create or replace view vista_ventas_funcion as
select
    f.funcion_id,
    p.titulo as pelicula,
    s.nombre as sala,
    f.fecha_hora_inicio,
    f.fecha_hora_fin,
    coalesce(sum(e.monto_pagado), 0) as total_vendido,
    round(
        coalesce(sum(e.monto_pagado), 0) * 100 /
        nullif(sum(sum(e.monto_pagado)) over (
            partition by date(f.fecha_hora_inicio)
        ), 0)
    , 2) as porcentaje_del_dia
from cine.funcion f
join cine.pelicula p on p.pelicula_id = f.pelicula_id
join cine.sala s on s.sala_id = f.sala_id
left join cine.entrada e on e.funcion_id = f.funcion_id
group by f.funcion_id, p.titulo, s.nombre, f.fecha_hora_inicio, f.fecha_hora_fin;

insert into schema_migrations (version) values ('007-ventas-funcion');

commit;