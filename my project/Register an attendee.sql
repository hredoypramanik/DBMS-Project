PROCEDURE register_attendee(
        p_event_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone_number IN VARCHAR2,
        p_ticket_type IN VARCHAR2,
        p_ticket_price IN NUMBER
    );