BEGIN
    -- Register attendees for event
    event_management_pkg.register_attendee(1, 'Alice', 'Brown', 'alice.brown@email.com', '555-111-2222', 'Standard', 199.99);
    event_management_pkg.register_attendee(1, 'Bob', 'Wilson', 'bob.wilson@email.com', '555-333-4444', 'VIP', 399.99);
    
    -- Update payment status
    event_management_pkg.update_payment_status(1, 'Credit Card', 'Completed');
    event_management_pkg.update_payment_status(2, 'Credit Card', 'Completed');
    
    -- Generate event report
    event_management_pkg.generate_event_report(1);
    
    -- Test cancellation
    event_management_pkg.cancel_registration(1);
    event_management_pkg.generate_event_report(1);
END;
/