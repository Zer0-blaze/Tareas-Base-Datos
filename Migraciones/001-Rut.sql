set search_path to cine;

create or replace function fn_validar_rut()
returns trigger language plpgsql as
'
declare
    rut_limpio   text;
    cuerpo       text;
    dv_ingresado text;
    dv_calculado text;
    suma         int := 0;
    multiplo     int := 2;
    largo        int;
    i            int;
    digito       int;
begin
    rut_limpio   := upper(replace(replace(new.rut, chr(46), ''''), chr(45), ''''));
    largo        := length(rut_limpio);
    cuerpo       := substring(rut_limpio from 1 for largo - 1);
    dv_ingresado := substring(rut_limpio from largo);

    largo := length(cuerpo);
    for i in 0..largo-1 loop
        digito   := substring(cuerpo from largo - i for 1)::int;
        suma     := suma + digito * multiplo;
        multiplo := case when multiplo = 7 then 2 else multiplo + 1 end;
    end loop;

    dv_calculado := case
        when (11 - suma % 11) = 11 then ''0''
        when (11 - suma % 11) = 10 then ''K''
        else (11 - suma % 11)::text
    end;

    if dv_calculado <> dv_ingresado then
        raise exception ''rut invalido: digito verificador incorrecto. esperado: %'', dv_calculado;
    end if;

    return new;
end;
'
;

set search_path to cine;

drop trigger if exists trg_validar_rut on cine.cliente;

create trigger trg_validar_rut
before insert or update on cine.cliente
for each row
execute function cine.fn_validar_rut();

INSERT INTO schema_migrations (version) VALUES ('001-trigger-validar-rut');