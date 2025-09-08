SELECT capacity INTO v_event_capacity
        FROM events e
        JOIN venues v ON e.venue_id = v.venue_id
        WHERE e.event_id = p_event_id;
        
        SELECT COUNT(*) INTO v_current_registrations
        FROM registrations
        WHERE event_id = p_event_id AND payment_status != 'Cancelled';
        
        IF v_current_registrations >= v_event_capacity THEN
            RAISE_APPLICATION_ERROR(-20001, 'Event is at full capacity. Cannot register more attendees.');
        END IF;