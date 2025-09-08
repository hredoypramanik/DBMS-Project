v_registration_id := seq_registration_id.NEXTVAL;
        INSERT INTO registrations (registration_id, event_id, attendee_id, ticket_type, ticket_price)
        VALUES (v_registration_id, p_event_id, v_attendee_id, p_ticket_type, p_ticket_price);