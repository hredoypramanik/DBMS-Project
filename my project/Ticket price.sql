IF p_ticket_price > 0 THEN
            INSERT INTO payments (payment_id, registration_id, amount, payment_method, status)
            VALUES (seq_payment_id.NEXTVAL, v_registration_id, p_ticket_price, NULL, 'Completed');
        END IF;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Attendee registered successfully with registration ID: ' || v_registration_id);
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE;
    END register_attendee;

    FUNCTION check_event_availability(p_event_id IN NUMBER) RETURN BOOLEAN IS
        v_event_capacity NUMBER;
        v_current_registrations NUMBER;
    BEGIN
        SELECT capacity INTO v_event_capacity
        FROM events e
        JOIN venues v ON e.venue_id = v.venue_id
        WHERE e.event_id = p_event_id;
        
        SELECT COUNT(*) INTO v_current_registrations
        FROM registrations
        WHERE event_id = p_event_id AND payment_status != 'Cancelled';
        
        RETURN (v_current_registrations < v_event_capacity);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END check_event_availability;

    PROCEDURE update_payment_status(
        p_registration_id IN NUMBER,
        p_payment_method IN VARCHAR2,
        p_status IN VARCHAR2
    ) IS
        v_ticket_price NUMBER;
    BEGIN