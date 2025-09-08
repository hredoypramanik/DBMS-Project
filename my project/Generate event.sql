PROCEDURE generate_event_report(p_event_id IN NUMBER);
    
END event_management_pkg;
/

CREATE OR REPLACE PACKAGE BODY event_management_pkg AS

    PROCEDURE register_attendee(
        p_event_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone_number IN VARCHAR2,
        p_ticket_type IN VARCHAR2,
        p_ticket_price IN NUMBER
    ) IS
        v_attendee_id NUMBER;
        v_registration_id NUMBER;
        v_event_capacity NUMBER;
        v_current_registrations NUMBER;
    BEGIN