/*
    CSCI 403 Lab 3: Uver
    Name: Nathan Oliver
*/

/* PLEASE READ FIRST BEFORE RUNNING:

I didn't properly allot enough time for this assignment. Specifically, I didn't realize until after I'd finished
writing all of my CREATE statements that I had to add individual ALTER statmenets for my constraints and foreign 
keys as opposed to hardcoding them in as I built everything. I'm aware some of it may not build properly, but I 
believe the structure I outlined in my ERD can still be seen here. If it's blatantly incorrect, please let me
know so I can understand how to improve for the next assignment. 

*/
/* ENTITIES */
CREATE TABLE customer (
    customer_name TEXT NOT NULL,
    phone_number INT NOT NULL,
    start_location TEXT NOT NULL,
    payment_method CHAR(8),
    payment_confirmation VARCHAR(15) NOT NULL,
    PRIMARY KEY (customer_name, phone_number),
    CONSTRAINT unique_customer UNIQUE (start_location, payment_confirmation)
);

CREATE TABLE trip (
    trip_id INT NOT NULL,
    start_location TEXT NOT NULL,
    destination TEXT NOT NULL,
    number_of_riders INT NOT NULL DEFAULT 1,
    payment_confirmation VARCHAR(15) NOT NULL,
    PRIMARY KEY (trip_id),
    FOREIGN KEY (start_location) REFERENCES customer(start_location),
    FOREIGN KEY (payment_confirmation) REFERENCES customer(payment_confirmation)
);

CREATE TABLE car (
    plate VARCHAR(10) NOT NULL,
    number_of_seats INT NOT NULL,
    car_type TEXT NOT NULL, 
    PRIMARY KEY (plate),
    FOREIGN KEY (plate) REFERENCES car_driver_xref (xref_plate)
);

CREATE TABLE driver (
    driver_name TEXT NOT NULL,
    phone_number INT NOT NULL,
    registration VARCHAR(30) NOT NULL,
    PRIMARY KEY (driver_name, phone_number),
    FOREIGN KEY (registration) REFERENCES car_driver_xref (xref_registration)
);

/* 1:1 RELATIONSHIPS */
CREATE TABLE car_driver_xref (
    xref_plate VARCHAR(10) NOT NULL,
    xref_registration VARCHAR(30) NOT NULL,
    PRIMARY KEY (xref_plate, xref_registration),
    FOREIGN KEY (xref_plate) REFERENCES car(plate),
    FOREIGN KEY (xref_registration) REFERENCES driver(registration)
); 

/* 1:N RELATIONSHIPS */
CREATE TABLE ride_request (
    riders INT NOT NULL,
    ride_type TEXT NOT NULL,
    fare DECIMAL NOT NULL,
    ride_time DECIMAL NOT NULL,
    destination TEXT NOT NULL,
    start_location TEXT NOT NULL,
    ride_id INT NOT NULL,
    PRIMARY KEY (ride_id, type)
    FOREIGN KEY (ride_id) REFERENCES trip(trip_id),
    FOREIGN KEY (ride_type) REFERENCES car(car_type),
    FOREIGN KEY (destination) REFERENCES trip(destination),
    FOREIGN KEY (start_location) REFERENCES trip(start_location),
    FOREIGN KEY (riders) REFERENCES trip(number_of_riders),
    CONSTRAINT unique_trip UNIQUE (ride_id, ride_type, destination, start_location, riders)
);

/* MULTIVALUED ATTRIBUTES */
CREATE TABLE car_feature (
    ride_type TEXT NOT NULL,
    feature TEXT NOT NULL,
    PRIMARY KEY (ride_type, feature),
    FOREIGN KEY ride_type REFERENCES car(car_type),
    CONSTRAINT true_ride UNIQUE (ride_type)
);

/* VIEWS */
CREATE VIEW ride_distance AS
SELECT destination, start_location
FROM trip
WHERE ride_distance = destination <@> start_location;

CREATE VIEW ride_fare AS
SELECT ride_distance, ride_time, ride_type
FROM ride_distance, ride_request
    CASE
        WHEN ride_type = 'economy' THEN 0.7
        WHEN ride_type = 'regular' THEN 1.0
        WHEN ride_type = 'lux' THEN 1.5
    END AS ride_type_mulitplier
WHERE ride_fare = ride_distance * ride_time * ride_type_multiplier;

