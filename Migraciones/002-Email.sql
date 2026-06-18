set search_path to cine;

create or replace function fn_validar_email()
returns trigger language plpgsql as
'
declare
    pos_arroba    int;
    parte_dominio text;
begin
    new.email := lower(new.email);

    pos_arroba := position(chr(64) in new.email);

    if pos_arroba <= 1 then
        raise exception ''email invalido: debe tener algo antes del arroba. email ingresado: %'', new.email;
    end if;

    parte_dominio := substring(new.email from pos_arroba + 1);

    if length(parte_dominio) = 0 then
        raise exception ''email invalido: falta algo despues del arroba. email ingresado: %'', new.email;
    end if;

    if position(chr(46) in parte_dominio) = 0 then
        raise exception ''email invalido: el dominio debe tener un punto. email ingresado: %'', new.email;
    end if;

    return new;
end;
'
;

set search_path to cine;

drop trigger if exists trg_validar_email on cliente;

create trigger trg_validar_email
before insert or update on cliente
for each row
execute function fn_validar_email();

set search_path to cine;

insert into schema_migrations (version) values ('002-trigger-validar-email');

commit;