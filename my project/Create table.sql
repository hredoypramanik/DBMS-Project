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