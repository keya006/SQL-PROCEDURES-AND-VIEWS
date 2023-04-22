
/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

use flight_management;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a database-wide unique location if
it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin
if ip_airlineID not in (select airlineID from airline) or ip_tail_num in (select tail_num from airplane where airlineID = ip_airlineID) then leave sp_main; end if;

if ip_speed <= 0 or ip_seat_capacity <= 0 then leave sp_main; end if;

if ip_plane_type like 'jet' and ip_jet_engines <= 0 then leave sp_main; end if;

if ip_plane_type like 'prop' and ip_propellers <= 0 then leave sp_main; end if;

if ip_skids < 0 then leave sp_main; end if;

insert into airplane (airlineID, tail_num, seat_capacity, speed, locationID, plane_type, skids, propellers, jet_engines) values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);
end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a database-wide unique location if it will be used to support
airplane takeoffs and landings.  An airport may have a longer, more descriptive
name.  An airport must also have a city and state designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state char(2), in ip_locationID varchar(50))
sp_main: begin
if ip_airportID in (select airportID from airport) or ip_locationID in (select locationID from location)
	THEN leave sp_main; end if;

if ip_city = null or ip_state = null THEN
  leave sp_main; end if;

insert into airport (airportID, airport_name, city, state, locationID) values (ip_airportID, ip_airport_name, ip_city, ip_state, ip_locationID);
end //
delimiter ;

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person may have a first and last name as well.

Also, a person can hold a pilot role, a passenger role, or both roles.  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  Also,
a pilot might be assigned to a specific airplane as part of the flight crew.  As a
passenger, a person will have some amount of frequent flyer miles. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_flying_airline varchar(50), in ip_flying_tail varchar(50),
    in ip_miles integer)
sp_main: begin
if ip_personID IN (SELECT personID from person) then leave sp_main; end if;

insert into person (personID, first_name, last_name, locationID, taxID, experience, flying_airline, flying_tail, miles) values (ip_personID, ip_first_name, ip_last_name, ip_locationID, ip_taxID, ip_experience, ip_flying_airline, ip_flying_tail, ip_miles);
end //
delimiter ;

-- [4] grant_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new pilot license.  The license must reference
a valid pilot, and must be a new/unique type of license for that pilot. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_pilot_license;
delimiter //
create procedure grant_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin
if ip_personID not in (select personID from pilot) then leave sp_main; end if;
 	
UPDATE pilot_licence
SET
license = ip_license WHERE personID = ip_personID;
end //
delimiter ;

-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  Once
an airplane has been assigned, we must also track where the airplane is along
the route, whether it is in flight or on the ground, and when the next action -
takeoff or landing - will occur. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_airplane_status varchar(100), in ip_next_time time)
sp_main: begin
if ip_routeID not in (select routeID from route) then
        leave sp_main; end if;
insert INTO flight (flightID, routeID, support_airline, support_tail, progress, airplane_status, next_time) values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress, ip_airplane_status, ip_next_time);
end //
delimiter ;

-- [6] purchase_ticket_and_seat()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ticket.  The cost of the flight is optional
since it might have been a gift, purchased with frequent flyer miles, etc.  Each
flight must be tied to a valid person for a valid flight.  Also, we will make the
(hopefully simplifying) assumption that the departure airport for the ticket will
be the airport at which the traveler is currently located.  The ticket must also
explicitly list the destination airport, which can be an airport before the final
airport on the route.  Finally, the seat must be unoccupied. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ticket_and_seat;
delimiter //
create procedure purchase_ticket_and_seat (in ip_ticketID varchar(50), in ip_cost integer,
	in ip_carrier varchar(50), in ip_customer varchar(50), in ip_deplane_at char(3),
    in ip_seat_number varchar(50))
sp_main: begin
if ip_customer not i (select personID from person) then
	leave sp_main; end if;

insert into ticket (ticketID, cost, carrier, customer, deplane_at) values (ip_ticketID, ip_cost, ip_carrier, ip_customer, ip_deplane_at);
insert into ticket_seats(ticketID, seat_number) values (ip_ticketID, ip_seat_number);
end //
delimiter ;

-- [7] add_update_leg()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new leg as specified.  However, if a leg from
the departure airport to the arrival airport already exists, then don't create a
new leg - instead, update the existence of the current leg while keeping the existing
identifier.  Also, all legs must be symmetric.  If a leg in the opposite direction
exists, then update the distance to ensure that it is equivalent.   */
-- -----------------------------------------------------------------------------
drop procedure if exists add_update_leg;
delimiter //
create procedure add_update_leg (in ip_legID varchar(50), in ip_distance integer,
    in ip_departure char(3), in ip_arrival char(3))
sp_main: begin
-- Checking for non-zero and non-negative distances
    if ip_distance <= 0 then leave sp_main; end if;
    
    -- Checking for the other conditions
    if (ip_departure, ip_arrival) in (select departure, arrival from leg) then
    update leg set distance = ip_distance where (departure, arrival) = (ip_departure, ip_arrival);
    update leg set distance = ip_distance where (departure, arrival) = (ip_arrival, ip_departure);
    leave sp_main;
    end if;

insert into leg (legID, distance, departure, arrival) values (ip_legID, ip_distance, ip_departure, ip_arrival);
end //
delimiter ;

-- [8] start_route()
-- -----------------------------------------------------------------------------
/* This stored procedure creates the first leg of a new route.  Routes in our
system must be created in the sequential order of the legs.  The first leg of
the route can be any valid leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_route;
delimiter //
create procedure start_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
if ip_legID not in (select legID from leg) then
	leave sp_main; end if;

insert into route (routeID) values (ip_routeID);

insert into route_path (routeID, legID) values (ip_routeID, ip_legID);
end //
delimiter ;

-- [9] extend_route()
-- -----------------------------------------------------------------------------
/* This stored procedure adds another leg to the end of an existing route.  Routes
in our system must be created in the sequential order of the legs, and the route
must be contiguous: the departure airport of this leg must be the same as the
arrival airport of the previous leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists extend_route;
delimiter //
create procedure extend_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
-- Declaring local variables
    declare departure char(3);
    declare previous_arrival char(3);
    declare previous_sequence int;

    --Finding departure airport
    set departure = (select departure from leg where legID = ip_legID);
    
    -- Finding previous sequence number
    set previous_sequence = (select max(sequence) from route_path where routeID = ip_routeID group by routeID);
    
   -- Finding the arrival airport of the last leg of a route path
    set previous_arrival = (select arrival from leg where legID = (seliect legID from (select * from route_path where routeID = ip_routeID) as leg where sequence = previous_sequence));
    
    -- Checking for sequential order
    if departure not like previous_arrival then leave sp_main; end if;
    
    insert into route_path values (ip_routeID, ip_legID, previous_sequence + 1);
end //
delimiter ;

-- [10] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
--Declaring variables
    declare ip_legID varchar(50);
    declare ip_distance int;
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_locationID varchar(50);
    
    --Changing state of flight
    update flight set airplane_status = 'on_ground', next_time = addtime(next_time, '01:00:00') where flightID = ip_flightID;
    
    -- leg traversed
    set ip_legID = (select legID from route_path where (routeID, sequence) = (select routeID, progress from flight where flightID = ip_flightID));
    
    --distance traveled on the leg
    set ip_distance = (select distance from leg where legID = ip_legID);
    
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    
    set ip_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
    
    -- Increased experience update for pilot
	update pilot set experience = experience + 1 where flying_airline = ip_airline and flying_tail = ip_tail_num;
    
    --update passengers flyier miles
    update passenger set miles = miles + ip_distance where personID in (select personID from person where locationID = ip_locationID);
end //
delimiter ;

-- [11] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that propeller driven planes have at least one pilot
assigned, while jets must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare num_pilots int;
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare next_leg varchar(50);
    declare travel_time decimal;
    
    -- seeking the airline and tail number to find the plane
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    
    -- Finding the number of pilots
    set num_pilots = (select count(*) from pilot where flying_airline = ip_airline and flying_tail = ip_tail_num group by flying_airline, flying_tail);
    
    --check pilot shortage in prop
    if (select plane_type from airplane where airlineID = ip_airline and tail_num = ip_tail_num) like 'prop' and num_pilots < 1 then
    update flight set next_time = addtime(next_time, '00:30:00') where flightID = ip_flightID;
    leave sp_main;
    end if;
    
    if (select plane_type from airplane where airlineID = ip_airline and tail_num = ip_tail_num) like 'jet' and num_pilots < 2 then
    update flight set next_time = addtime(next_time, '00:30:00') where flightID = ip_flightID;
    leave sp_main;
    end if;
    
    -- Finding the the route and the current progress
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    
    if ip_progress + 1 > (select max(sequence) from route_path where routeID = ip_routeID) then leave sp_main; end if;
    
    -- find the next leg
    set next_leg = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress + 1);
    
    -- Calculate time (in seconds) needed for next leg
    set travel_time = (select distance from leg where legID = next_leg) / (select speed from airplane where airlineID = ip_airline and tail_num = ip_tail_num) * 3600;
    
    update flight set progress = progress + 1, airplane_status = 'in_flight', next_time = addtime(next_time, sec_to_time(travel_time)) where flightID = ip_flightID;
end //
delimiter ;

-- [12] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the airport and hold a valid ticket
for the flight. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_airplane_locationID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID varchar(3);
    declare ip_airport_locationID varchar(50);

    -- Check if the plane is on the ground, leave if not
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground' then leave sp_main; end if;

    -- Find the the route and the current progress, then use those to find the leg that was just traversed
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress);

	-- Find the current airport and airport locationID using the leg that was found
    set ip_airportID = (select arrival from leg where legID = ip_legID);
    set ip_airport_locationID = (select locationID from airport where airportID = ip_airportID);

    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);

    set ip_airplane_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);

    -- Update person location if they are at the airport and they are holding a valid ticket
    -- Also check if the ticket's deplaning airport is within the airports along the rest of the route
    update person set locationID = ip_airplane_locationID
    where
    locationID = ip_airport_locationID
    and
    personID in (select customer from ticket
		where
			carrier = ip_flightID
			and
			deplane_at in (select arrival from route_path as r join leg as l on r.legID = l.legID where routeID = ip_routeID and sequence >= ip_progress + 1)
        );
end //
delimiter ;

-- [13] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_airplane_locationID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID varchar(3);
    declare ip_airport_locationID varchar(50);

   -- Check if the plane is on the ground, leave if not
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground' then leave sp_main; end if;

    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_sequence;
    set ip_airportID = (select arrival from leg where legID = ip_legID);
    set ip_airport_locationID = (select locationID from airport where airportID = ip_airportID);
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_fligt;
    set ip_airplane_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);

    update person set locationID = ip_airport_locationID
    where
    locationID = ip_airplane_locationID
    and
    personID in (select customer from ticket where carrier = ip_flightID and deplane_at = ip_airportID);
end //
delimiter ;

-- [14] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
airplane.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), ip_personID varchar(50))
sp_main: begin
select locationID from location inner join personID from pilot into pilot.location;
if personID in (select personID from pilot)
	then
	insert into flight (flightID) values (ip_flightID);
	insert into pilot (personID) values (ip_personID);
	select concat('pilot', ip_personID, 'assigned to flight' flightID) AS MESSAGE;
end if;
end //
delimiter ;

-- [15] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
if flight_status = 'in_flight' in (select flight_status from flight) then
	leave sp_main; end if;
insert into flight (flightID) values (ip_flightID);	
end //
delimiter ;

-- [16] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
if ip_flightID in (SELECT airplane_status FROM flight where airplane_status = 'in_flight')
	then sp_main; end if;
delete from flight where flightID = ip_flightID;	
end //
delimiter ;

-- [17] remove_passenger_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the passenger role from person.  The passenger
must be on the ground at the time; and, if they are on a flight, then they must
disembark the flight at the current airport.  If the person had both a pilot role
and a passenger role, then the person and pilot role data should not be affected.
If the person only had a passenger role, then all associated person data must be
removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_passenger_role;
delimiter //
create procedure remove_passenger_role (in ip_personID varchar(50))
sp_main: begin
delete from passenger where ip_personID = personID;
end //
delimiter ;

-- [18] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the pilot role from person.  The pilot must not
be assigned to a flight; or, if they are assigned to a flight, then that flight
must either be at the start or end of its route.  If the person had both a pilot
role and a passenger role, then the person and passenger role data should not be
affected.  If the person only had a pilot role, then all associated person data
must be removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role;
delimiter //
create procedure remove_pilot_role (in ip_personID varchar(50))
sp_main: begin
if ip_personID in (select personID from passenger) and ip_personid in (select personID from pilot)
	then leave sp_main; end if;

delete from pilot where ip_pilotID = personID;	
end //
delimiter ;

-- [19] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air AS
SELECT departure as departing_from, arrival as arriving_at, count(flightID) as num_flights, flightID as flight_list, locationID as airplane_list from flight 
inner join airplane on flightID = airlineID
inner join location on airlineID = locationID
where airplane_status = 'in_flight';
   
end //
delimiter ;
-- [20] flights_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_on_the_ground (departing_from, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as 
select departure as departing_from, count(flightID) as num_flight, flightID as flight_list, next_time as earliest_arrival, next_time as latest_arrival, locationID as airplane_list from flight
join airplane on flightID = tail_num
join location on tail_num = locationID
where airplane_status = 'on_ground'
end //
delimiter ;
-- [21] people_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
select departure as departing_from, arrival as arriving_at, count(airplaneID) as num_airplane, count(licence) as num_pilots, count(miles) as num_passengers, (count(miles) + count(license)) as joint_pilots_passengers, personID as person_list from flight join airplane on flightID = airplaneID 
join person on tail_num = personID 
where airplane_status = 'in_flight'
end //
delimiter ;
-- [22] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
select departure as departure_from, airportID as airport, airport_name, city, state, count(licence) as num_pilots, count(miles) as num_passengers, (count(miles) + count(license)) as joint_pilots_passengers, personID as person_list from flight join airport on flightID = airportID
join person on airportID = personID where airplane_status = 'on_ground';
end //
delimiter ;
-- [23] route_summary()
-- -----------------------------------------------------------------------------
/* This view describes how the routes are being utilized by different flights. */
-- -----------------------------------------------------------------------------
create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as
select routeID as route, count(legID) as num_legs, sequence as leg_sequence, distance as route_length, count(flightID) as num_flight, flightID as flight_list, airportID as airport_sequence) from route_path join leg on routeID = legID JOIN FLIGHT ON routeID = flightID join airport on flightID = airportID; 
end //
delimiter ;
-- [24] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, num_airports,
	airport_code_list, airport_name_list) as
select city, state, count(airportID) as num_airports, airportID as airport_code_list, airport_name as airport_name_list from airport group by city, state;
end //
delimiter ;
-- [25] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle ()
sp_main: begin
SELECT flightID, airplane_status, next_time, routeID, distance, speed, 
FROM flight
inner join route on flightID = routeID
INNER JOIN leg on flightID = legID
INNER JOIN airplane on flightID = tail_num
WHERE next_time = (SELECT MIN(next_time) from flight where airplane_status = 'on_ground' OR (airplane_status = 'in_flight' AND type = 'landing'))
ORDER BY airplane_type ASC, flightID ASC
LIMIT 1;

IF (flightID IS NOT NULL) THEN
	IF (airplane_status = 'on_ground' and flight_type = 'takeoff') THEN
		UPDATE flight SET airplane_status = 'in_flight'
	ELSEIF (airplane_status = 'on_ground' AND flight_type = 'landing') THEN
	       UPDATE flight SET status = 'landed', next_time = ADDTIME(next_time, '01:00:00')
        ELSEIF (airplane_status = 'in_flight' AND flight_type = 'landing') THEN
	       UPDATE flight SET status = 'landed', next_time = ADDTIME(next_time, '01:00:00')
        ELSEIF (airplane_status = 'in_flight' AND flight_type = 'takeoff') THEN
        END IF;
END IF;
END //
delimiter ;
