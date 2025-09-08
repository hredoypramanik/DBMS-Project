-- Drop all tables in correct order to handle foreign key constraints
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE payments CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE registrations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE event_schedule CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE attendees CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE events CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE venues CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE organizers CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- Drop sequences
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_event_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_venue_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_organizer_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_attendee_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_registration_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_schedule_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_payment_id';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

-- Create tables
CREATE TABLE organizers (
    organizer_id NUMBER PRIMARY KEY,
    organizer_name VARCHAR2(100) NOT NULL,
    company_name VARCHAR2(100),
    email VARCHAR2(100),
    phone_number VARCHAR2(15),
    address VARCHAR2(200)
);

CREATE TABLE venues (
    venue_id NUMBER PRIMARY KEY,
    venue_name VARCHAR2(100) NOT NULL,
    address VARCHAR2(200),
    city VARCHAR2(50),
    state VARCHAR2(50),
    zip_code VARCHAR2(20),
    capacity NUMBER,
    contact_number VARCHAR2(15),
    email VARCHAR2(100),
    rental_cost NUMBER(10,2)
);

CREATE TABLE events (
    event_id NUMBER PRIMARY KEY,
    event_name VARCHAR2(100) NOT NULL,
    event_description VARCHAR2(500),
    event_type VARCHAR2(50) CHECK (event_type IN ('Conference', 'Concert', 'Wedding', 'Seminar', 'Exhibition', 'Other')),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    venue_id NUMBER,
    organizer_id NUMBER,
    status VARCHAR2(20) DEFAULT 'Planning' CHECK (status IN ('Planning', 'Scheduled', 'Ongoing', 'Completed', 'Cancelled')),
    max_attendees NUMBER,
    CONSTRAINT fk_events_venue FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    CONSTRAINT fk_events_organizer FOREIGN KEY (organizer_id) REFERENCES organizers(organizer_id)
);

CREATE TABLE attendees (
    attendee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15),
    registration_date DATE DEFAULT SYSDATE
);

CREATE TABLE registrations (
    registration_id NUMBER PRIMARY KEY,
    event_id NUMBER,
    attendee_id NUMBER,
    registration_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    ticket_type VARCHAR2(50),
    ticket_price NUMBER(10,2),
    payment_status VARCHAR2(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Paid', 'Cancelled')),
    CONSTRAINT fk_registrations_event FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT fk_registrations_attendee FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);

CREATE TABLE event_schedule (
    schedule_id NUMBER PRIMARY KEY,
    event_id NUMBER,
    activity_name VARCHAR2(100) NOT NULL,
    activity_description VARCHAR2(300),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    speaker VARCHAR2(100),
    CONSTRAINT fk_schedule_event FOREIGN KEY (event_id) REFERENCES events(event_id)
);

CREATE TABLE payments (
    payment_id NUMBER PRIMARY KEY,
    registration_id NUMBER,
    payment_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    amount NUMBER(10,2),
    payment_method VARCHAR2(50) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash')),
    status VARCHAR2(20) DEFAULT 'Completed' CHECK (status IN ('Completed', 'Failed', 'Refunded')),
    CONSTRAINT fk_payments_registration FOREIGN KEY (registration_id) REFERENCES registrations(registration_id)
);

-- Create sequences
CREATE SEQUENCE seq_event_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_venue_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_organizer_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_attendee_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_registration_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_schedule_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1;

-- Create indexes
CREATE INDEX idx_events_date ON events(start_date);
CREATE INDEX idx_events_venue ON events(venue_id);
CREATE INDEX idx_registrations_event ON registrations(event_id);
CREATE INDEX idx_registrations_attendee ON registrations(attendee_id);
CREATE INDEX idx_schedule_event ON event_schedule(event_id);

-- PL/SQL Package for Event Management
CREATE OR REPLACE PACKAGE event_management_pkg AS
    -- Procedure to register an attendee for an event
    PROCEDURE register_attendee(
        p_event_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone_number IN VARCHAR2,
        p_ticket_type IN VARCHAR2,
        p_ticket_price IN NUMBER
    );
    
    -- Function to check event availability
    FUNCTION check_event_availability(p_event_id IN NUMBER) RETURN BOOLEAN;
    
    -- Procedure to update payment status
    PROCEDURE update_payment_status(
        p_registration_id IN NUMBER,
        p_payment_method IN VARCHAR2,
        p_status IN VARCHAR2
    );
    
    -- Procedure to cancel registration
    PROCEDURE cancel_registration(p_registration_id IN NUMBER);
    
    -- Function to calculate event revenue
    FUNCTION calculate_event_revenue(p_event_id IN NUMBER) RETURN NUMBER;
    
    -- Procedure to generate event report
    PROCEDURE generate_event_report(p_event_id IN NUMBER);
    
END event_management_pkg;
/

CREATE OR REPLACE PACKAGE BODY event_management_pkg AS

    PROCEDURE register_attendee(
        p_event_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone_number IN VARCHAR2,
        p_ticket_type IN VARCHAR2,
        p_ticket_price IN NUMBER
    ) IS
        v_attendee_id NUMBER;
        v_registration_id NUMBER;
        v_event_capacity NUMBER;
        v_current_registrations NUMBER;
    BEGIN
        -- Check if event exists and has capacity
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
        
        -- Check if attendee already exists
        BEGIN
            SELECT attendee_id INTO v_attendee_id
            FROM attendees
            WHERE email = p_email;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Create new attendee
                v_attendee_id := seq_attendee_id.NEXTVAL;
                INSERT INTO attendees (attendee_id, first_name, last_name, email, phone_number)
                VALUES (v_attendee_id, p_first_name, p_last_name, p_email, p_phone_number);
        END;
        
        -- Create registration
        v_registration_id := seq_registration_id.NEXTVAL;
        INSERT INTO registrations (registration_id, event_id, attendee_id, ticket_type, ticket_price)
        VALUES (v_registration_id, p_event_id, v_attendee_id, p_ticket_type, p_ticket_price);
        
        -- Create payment record only if ticket price > 0
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
        -- Get the ticket price first
        SELECT ticket_price INTO v_ticket_price
        FROM registrations
        WHERE registration_id = p_registration_id;
        
        -- Update or insert payment record
        MERGE INTO payments p
        USING (SELECT p_registration_id AS reg_id FROM dual) src
        ON (p.registration_id = src.reg_id)
        WHEN MATCHED THEN
            UPDATE SET payment_method = p_payment_method,
                       status = p_status,
                       payment_date = SYSTIMESTAMP
        WHEN NOT MATCHED THEN
            INSERT (payment_id, registration_id, amount, payment_method, status)
            VALUES (seq_payment_id.NEXTVAL, p_registration_id, v_ticket_price, p_payment_method, p_status);
        
        -- Update registration payment status (only if it's a valid status for registrations)
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
        -- Update registration status to 'Cancelled'
        UPDATE registrations
        SET payment_status = 'Cancelled'
        WHERE registration_id = p_registration_id;
        
        -- Update payment status to 'Refunded' if payment exists
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
        -- Get event details
        SELECT e.event_name, v.venue_name, v.capacity
        INTO v_event_name, v_venue_name, v_venue_capacity
        FROM events e
        JOIN venues v ON e.venue_id = v.venue_id
        WHERE e.event_id = p_event_id;
        
        -- Get registration statistics
        SELECT COUNT(*), 
               COUNT(CASE WHEN payment_status = 'Paid' THEN 1 END)
        INTO v_total_registrations, v_paid_registrations
        FROM registrations
        WHERE event_id = p_event_id;
        
        -- Calculate revenue
        v_total_revenue := calculate_event_revenue(p_event_id);
        
        -- Calculate capacity utilization
        IF v_venue_capacity > 0 THEN
            v_capacity_utilization := (v_total_registrations / v_venue_capacity) * 100;
        ELSE
            v_capacity_utilization := 0;
        END IF;
        
        -- Display report
        DBMS_OUTPUT.PUT_LINE('=== EVENT REPORT ===');
        DBMS_OUTPUT.PUT_LINE('Event: ' || v_event_name);
        DBMS_OUTPUT.PUT_LINE('Venue: ' || v_venue_name);
        DBMS_OUTPUT.PUT_LINE('Total Registrations: ' || v_total_registrations);
        DBMS_OUTPUT.PUT_LINE('Paid Registrations: ' || v_paid_registrations);
        DBMS_OUTPUT.PUT_LINE('Total Revenue: $' || v_total_revenue);
        DBMS_OUTPUT.PUT_LINE('Capacity Utilization: ' || ROUND(v_capacity_utilization, 2) || '%');
        DBMS_OUTPUT.PUT_LINE('====================');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Event not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END generate_event_report;

END event_management_pkg;
/

-- Insert sample data using PL/SQL anonymous block
DECLARE
BEGIN
    -- Insert sample organizers
    INSERT INTO organizers VALUES (seq_organizer_id.NEXTVAL, 'John Smith', 'Event Masters Inc', 'john@eventmasters.com', '555-123-4567', '789 Event Planners Lane, NY');
    INSERT INTO organizers VALUES (seq_organizer_id.NEXTVAL, 'Sarah Johnson', 'Corporate Events Co', 'sarah@corpevents.com', '555-987-6543', '321 Business Ave, Boston');

    -- Insert sample venues
    INSERT INTO venues VALUES (seq_venue_id.NEXTVAL, 'Grand Convention Center', '123 Main St', 'New York', 'NY', '10001', 1000, '212-555-1234', 'events@grandcc.com', 5000.00);
    INSERT INTO venues VALUES (seq_venue_id.NEXTVAL, 'City Hall', '456 Oak Ave', 'Boston', 'MA', '02108', 500, '617-555-9876', 'bookings@cityhall.com', 3000.00);

    -- Insert sample events
    INSERT INTO events VALUES (seq_event_id.NEXTVAL, 'Tech Conference 2023', 'Annual technology conference showcasing latest innovations', 'Conference', 
    TO_TIMESTAMP('2023-10-15 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    TO_TIMESTAMP('2023-10-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    1, 1, 'Scheduled', 800);

    INSERT INTO events VALUES (seq_event_id.NEXTVAL, 'Music Festival', 'Summer music festival with popular artists', 'Concert', 
    TO_TIMESTAMP('2023-07-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    TO_TIMESTAMP('2023-07-22 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    2, 2, 'Scheduled', 450);

    COMMIT;
END;
/

-- Create a trigger to automatically update event status
CREATE OR REPLACE TRIGGER trg_update_event_status
BEFORE INSERT OR UPDATE ON events
FOR EACH ROW
BEGIN
    IF :NEW.start_date > SYSTIMESTAMP THEN
        :NEW.status := 'Scheduled';
    ELSIF :NEW.start_date <= SYSTIMESTAMP AND :NEW.end_date >= SYSTIMESTAMP THEN
        :NEW.status := 'Ongoing';
    ELSIF :NEW.end_date < SYSTIMESTAMP THEN
        :NEW.status := 'Completed';
    END IF;
END;
/

-- Create a view for event details
CREATE OR REPLACE VIEW event_details_view AS
SELECT e.event_id, e.event_name, e.event_description, e.event_type,
       e.start_date, e.end_date, e.status, e.max_attendees,
       v.venue_name, v.address, v.city, v.state, v.capacity,
       o.organizer_name, o.company_name, o.phone_number as organizer_contact
FROM events e
JOIN venues v ON e.venue_id = v.venue_id
JOIN organizers o ON e.organizer_id = o.organizer_id;

-- Create a view for registration summary
CREATE OR REPLACE VIEW registration_summary_view AS
SELECT e.event_id, e.event_name,
       COUNT(r.registration_id) AS total_registrations,
       COUNT(CASE WHEN r.payment_status = 'Paid' THEN 1 END) AS paid_registrations,
       SUM(CASE WHEN r.payment_status = 'Paid' THEN r.ticket_price ELSE 0 END) AS total_revenue
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name;

-- Demonstrate usage of the package
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