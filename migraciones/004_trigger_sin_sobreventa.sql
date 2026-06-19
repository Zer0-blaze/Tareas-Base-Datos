set search_path to cine;

create or replace function fn_evitar_sobreventa()
returns trigger language plpgsql as
'
declare
    capacidad_sala  int;
    entradas_vendidas int;
begin
    select s.capacidad into capacidad_sala
    from sala s
    join funcion f on f.sala_id = s.sala_id
    where f.funcion_id = new.funcion_id;

    select count(*) into entradas_vendidas
    from entrada
    where funcion_id = new.funcion_id;

    if entradas_vendidas >= capacidad_sala then
        raise exception ''sobreventa: la sala ya esta llena para esta funcion. capacidad: %, entradas vendidas: %'', 
            capacidad_sala, entradas_vendidas;
    end if;

    return new;
end;
'
;

drop trigger if exists trg_evitar_sobreventa on entrada;

create trigger trg_evitar_sobreventa
before insert on entrada
for each row
execute function fn_evitar_sobreventa();

insert into schema_migrations (version) values ('004-trigger-sin-sobreventa');

commit;