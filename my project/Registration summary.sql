CREATE OR REPLACE VIEW registration_summary_view AS
SELECT e.event_id, e.event_name,
       COUNT(r.registration_id) AS total_registrations,
       COUNT(CASE WHEN r.payment_status = 'Paid' THEN 1 END) AS paid_registrations,
       SUM(CASE WHEN r.payment_status = 'Paid' THEN r.ticket_price ELSE 0 END) AS total_revenue
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name;
