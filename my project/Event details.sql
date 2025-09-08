CREATE OR REPLACE VIEW event_details_view AS
SELECT e.event_id, e.event_name, e.event_description, e.event_type,
       e.start_date, e.end_date, e.status, e.max_attendees,
       v.venue_name, v.address, v.city, v.state, v.capacity,
       o.organizer_name, o.company_name, o.phone_number as organizer_contact
FROM events e
JOIN venues v ON e.venue_id = v.venue_id
JOIN organizers o ON e.organizer_id = o.organizer_id;