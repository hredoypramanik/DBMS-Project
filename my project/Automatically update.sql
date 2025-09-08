CREATE OR REPLACE TRIGGER trg_update_event_status
BEFORE INSERT OR UPDATE ON events
FOR EACH ROW
BEGIN
    IF :NEW.start_date > SYSTIMESTAMP THEN
        :NEW.status := 'Scheduled';
    ELSIF :NEW.start_date <= SYSTIMESTAMP AND :NEW.end_date >= SYSTIMESTAMP THEN
        :NEW.status := 'Ongoing';
    ELSIF :NEW.end_date < SYSTIMESTAMP THEN
        :NEW.status := 'Completed';
    END IF;
END;
/CREATE OR REPLACE TRIGGER trg_update_event_status
BEFORE INSERT OR UPDATE ON events
FOR EACH ROW
BEGIN
    IF :NEW.start_date > SYSTIMESTAMP THEN
        :NEW.status := 'Scheduled';
    ELSIF :NEW.start_date <= SYSTIMESTAMP AND :NEW.end_date >= SYSTIMESTAMP THEN
        :NEW.status := 'Ongoing';
    ELSIF :NEW.end_date < SYSTIMESTAMP THEN
        :NEW.status := 'Completed';
    END IF;
END;
/