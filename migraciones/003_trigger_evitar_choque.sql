SET search_path TO cine;

CREATE OR REPLACE FUNCTION fn_evitar_choque()
RETURNS TRIGGER LANGUAGE plpgsql AS
'
DECLARE
    choque INT;
BEGIN
    SELECT COUNT(*) INTO choque
    FROM funcion
    WHERE sala_id = NEW.sala_id
      AND tsrange(fecha_hora_inicio, fecha_hora_fin, ''[)'') 
          && tsrange(NEW.fecha_hora_inicio, NEW.fecha_hora_fin, ''[)'');

    IF choque > 0 THEN
        RAISE EXCEPTION ''Ya hay una funcion en la sala % en ese horario.'', NEW.sala_id;
    END IF;

    RETURN NEW;
END;
';

DROP TRIGGER IF EXISTS trg_evitar_choque ON funcion;

CREATE TRIGGER trg_evitar_choque
BEFORE INSERT OR UPDATE ON funcion
FOR EACH ROW
EXECUTE FUNCTION fn_evitar_choque();

INSERT INTO schema_migrations (version) VALUES ('003-evitar-choque');