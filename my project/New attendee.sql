 v_attendee_id := seq_attendee_id.NEXTVAL;
                INSERT INTO attendees (attendee_id, first_name, last_name, email, phone_number)
                VALUES (v_attendee_id, p_first_name, p_last_name, p_email, p_phone_number);
        END;