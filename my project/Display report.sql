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