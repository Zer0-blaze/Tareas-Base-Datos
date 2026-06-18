set search_path to cine;

create or replace view vista_llenado_sala as
select
    s.sala_id,
    s.nombre,
    s.capacidad,
    count(distinct f.funcion_id) as total_funciones,
    count(e.entrada_id) as total_entradas_vendidas,
    (s.capacidad * count(distinct f.funcion_id)) as total_asientos_ofrecidos,
    case
        when count(distinct f.funcion_id) = 0 then 0
        else round(
            count(e.entrada_id)::numeric * 100 
            / (s.capacidad * count(distinct f.funcion_id)), 2
        )
    end as porcentaje_llenado
from cine.sala s
left join cine.funcion f on f.sala_id = s.sala_id
left join cine.entrada e on e.funcion_id = f.funcion_id
group by s.sala_id, s.nombre, s.capacidad;

insert into schema_migrations (version) values ('006-vista-llenado-sala');

commit;