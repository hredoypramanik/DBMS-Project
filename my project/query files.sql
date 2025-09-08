SELECT * FROM events;

------------------------
SELECT * FROM venues WHERE city = 'New York';

----------------------------------------------

SELECT * FROM attendees WHERE last_name LIKE 'Brown%';

------------------------------------------------------
SELECT r.*, a.first_name, a.last_name
FROM registrations r
JOIN attendees a ON r.attendee_id = a.attendee_id
WHERE r.event_id = 1;

--------------------------------------------------------------------
SELECT * FROM event_schedule WHERE event_id = 1 ORDER BY start_time;

--------------------------------------------------------------------
SELECT * FROM event_details_view;

--------------------------------------------------------------------
SELECT * FROM registration_summary_view;

--------------------------------------------------------------------
SELECT e.event_type, COUNT(r.registration_id) AS registration_count
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_type;

-------------------------------------------------------------------
SELECT a.first_name, a.last_name, a.email, e.event_name, r.ticket_type, r.ticket_price, p.payment_method
FROM registrations r
JOIN attendees a ON r.attendee_id = a.attendee_id
JOIN events e ON r.event_id = e.event_id
JOIN payments p ON r.registration_id = p.registration_id
WHERE r.payment_status = 'Paid';

--------------------------------------------------------------------------------------------------------------------
SELECT e.event_id, e.event_name, SUM(p.amount) AS total_revenue
FROM events e
JOIN registrations r ON e.event_id = r.event_id
JOIN payments p ON r.registration_id = p.registration_id
WHERE p.status = 'Completed'
GROUP BY e.event_id, e.event_name
ORDER BY total_revenue DESC
FETCH FIRST 3 ROWS ONLY;

------------------------------------------------------------
SELECT e.event_id, e.event_name, v.capacity,
       COUNT(r.registration_id) AS current_registrations,
       ROUND((COUNT(r.registration_id) / v.capacity) * 100, 2) AS percent_full
FROM events e
JOIN venues v ON e.venue_id = v.venue_id
LEFT JOIN registrations r ON e.event_id = r.event_id AND r.payment_status != 'Cancelled'
GROUP BY e.event_id, e.event_name, v.capacity
HAVING (COUNT(r.registration_id) / v.capacity) * 100 < 50
ORDER BY percent_full;

-------------------------------------------------------------------------------------
SELECT e.event_type,
       ROUND(AVG(r.ticket_price), 2) AS avg_ticket_price
FROM events e
JOIN registrations r ON e.event_id = r.event_id
WHERE r.payment_status = 'Paid'
GROUP BY e.event_type;

------------------------------------------------------------------------------------

SELECT e.event_type,
       ROUND(AVG(r.ticket_price), 2) AS avg_ticket_price
FROM events e
JOIN registrations r ON e.event_id = r.event_id
WHERE r.payment_status = 'Paid'
GROUP BY e.event_type;

-----------------------------------------------------------------------------------------

SELECT a.attendee_id, a.first_name, a.last_name, a.email,
       COUNT(r.registration_id) AS events_attended
FROM attendees a
JOIN registrations r ON a.attendee_id = r.attendee_id
JOIN events e ON r.event_id = e.event_id
WHERE e.end_date < SYSTIMESTAMP -- Only completed events
AND r.payment_status = 'Paid'
GROUP BY a.attendee_id, a.first_name, a.last_name, a.email
HAVING COUNT(r.registration_id) > 1
ORDER BY events_attended DESC;

-----------------------------------------------------------------------------------------------
SELECT e.event_id, e.event_name, e.start_date, v.venue_name, v.capacity,
       (v.capacity - COUNT(r.registration_id)) AS available_slots
FROM events e
JOIN venues v ON e.venue_id = v.venue_id
LEFT JOIN registrations r ON e.event_id = r.event_id AND r.payment_status != 'Cancelled'
WHERE e.start_date BETWEEN SYSTIMESTAMP AND SYSTIMESTAMP + 30
AND e.status = 'Scheduled'
GROUP BY e.event_id, e.event_name, e.start_date, v.venue_name, v.capacity
HAVING (v.capacity - COUNT(r.registration_id)) > 0
ORDER BY e.start_date;

------------------------------------------------------------------------------
DECLARE
    v_is_available BOOLEAN;
BEGIN
    v_is_available := event_management_pkg.check_event_availability(1);
    IF v_is_available THEN
        DBMS_OUTPUT.PUT_LINE('Event 1 has available slots.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Event 1 is full.');
    END IF;
END;
/

---------------------------------------------------------------------------
BEGIN
    event_management_pkg.generate_event_report(1);
END;
/

-------------------------------------------------------------------------
DECLARE
    v_revenue NUMBER;
BEGIN
    v_revenue := event_management_pkg.calculate_event_revenue(1);
    DBMS_OUTPUT.PUT_LINE('Total Revenue for Event 1: $' || v_revenue);
END;
/

--------------------------------------------------------------------
UPDATE event_schedule
SET speaker = 'Dr. Jane Smith'
WHERE schedule_id = 1;

---------------------------------------------------------------------
UPDATE venues SET capacity = 1200 WHERE venue_id = 1;

--------------------------------------------------------------------
UPDATE events
SET start_date = TO_TIMESTAMP('2023-11-15 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    end_date = TO_TIMESTAMP('2023-11-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS')
WHERE event_id = 1;
-- Note: The trigger `trg_update_event_status` will automatically update the status.

----------------------------------------------------------------------------------------
INSERT INTO event_schedule (schedule_id, event_id, activity_name, activity_description, start_time, end_time)
VALUES (seq_schedule_id.NEXTVAL, 1, 'Networking Lunch', 'Buffet lunch and networking session',
        TO_TIMESTAMP('2023-10-16 12:30:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2023-10-16 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));


--------------------------------------------------------------------------------------------------
