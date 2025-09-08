IF p_status IN ('Pending', 'Paid', 'Cancelled') THEN
            UPDATE registrations
            SET payment_status = p_status
            WHERE registration_id = p_registration_id;
        END IF;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Payment status updated successfully');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE;
    END update_payment_status;

    PROCEDURE cancel_registration(p_registration_id IN NUMBER) IS
    BEGIN