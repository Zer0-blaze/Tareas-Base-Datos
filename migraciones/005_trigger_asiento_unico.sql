set search_path to cine;

create or replace function fn_asiento_unico()
returns trigger language plpgsql as
'
declare
    asiento_tomado int;
begin
    select count(*) into asiento_tomado
    from cine.entrada
    where funcion_id = new.funcion_id
      and asiento_id = new.asiento_id;

    if asiento_tomado > 0 then
        raise exception ''el asiento % ya esta ocupado en esta funcion.'', new.asiento_id;
    end if;

    return new;
end;
'
;

drop trigger if exists trg_asiento_unico on cine.entrada;

create trigger trg_asiento_unico
before insert on cine.entrada
for each row
execute function cine.fn_asiento_unico();

insert into schema_migrations (version) values ('005-asiento-unico');

commit;
