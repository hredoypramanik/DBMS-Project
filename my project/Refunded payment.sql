UPDATE payments
        SET status = 'Refunded'
        WHERE registration_id = p_registration_id AND status = 'Completed';
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Registration cancelled successfully');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE;
    END cancel_registration;

    FUNCTION calculate_event_revenue(p_event_id IN NUMBER) RETURN NUMBER IS
        v_total_revenue NUMBER := 0;
    BEGIN
        SELECT SUM(p.amount) INTO v_total_revenue
        FROM payments p
        JOIN registrations r ON p.registration_id = r.registration_id
        WHERE r.event_id = p_event_id AND p.status = 'Completed';
        
        RETURN NVL(v_total_revenue, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calculate_event_revenue;

    PROCEDURE generate_event_report(p_event_id IN NUMBER) IS
        v_event_name events.event_name%TYPE;
        v_venue_name venues.venue_name%TYPE;
        v_total_registrations NUMBER;
        v_paid_registrations NUMBER;
        v_total_revenue NUMBER;
        v_capacity_utilization NUMBER;
        v_venue_capacity NUMBER;
    BEGIN