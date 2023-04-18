

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

use flight_management;
-- ----------------------------------------------------------------------------------
-- [1] Implement a capability to reset the database state easily
-- ----------------------------------------------------------------------------------

drop procedure if exists magic44_reset_database_state;
delimiter //
create procedure magic44_reset_database_state ()
begin
	-- Purge and then reload all of the database rows back into the tables.
    -- Ensure that the data is deleted in reverse order with respect to the
    -- foreign key dependencies (i.e., from children up to parents).
	delete from ticket_seats;
	delete from ticket;
	delete from flight;
	delete from route_path;
	delete from route;
	delete from leg;
	delete from passenger;
	delete from pilot_licenses;
	delete from pilot;
	delete from person;
	delete from airport;
	delete from airplane;
    delete from location;
    delete from airline;

    -- Ensure that the data is inserted in order with respect to the
    -- foreign key dependencies (i.e., from parents down to children).
	insert into airline values
	('Delta', 46),
	('American', 45),
	('United', 40),
	('Lufthansa', 31),
	('Air_France', 25),
	('Southwest', 22),
	('JetBlue', 8),
	('Spirit', 4);

	insert into location values
	('port_1'),
	('port_2'),
	('port_3'),
	('port_4'),
	('port_5'),
	('port_9'),
	('plane_1'),
	('plane_2'),
	('plane_4'),
	('plane_7'),
	('plane_8'),
	('plane_9'),
	('plane_11'),
	('plane_15'),
	('port_7'),
	('port_10'),
	('port_11'),
	('port_13'),
	('port_14'),
	('port_15'),
	('port_17'),
	('port_18');

	insert into airplane values
	('Delta', 'n106js', 4, 200, 'plane_1', 'jet', null, null, 2),
	('Delta', 'n110jn', 5, 600, 'plane_2', 'jet', null, null, 4),
	('Delta', 'n127js', 4, 800, null, null, null, null, null),
	('American', 'n330ss', 4, 200, 'plane_4', 'jet', null, null, 2),
	('American', 'n380sd', 5, 400, null, 'jet', null, null, 2),
	('United', 'n616lt', 7, 400, null, 'jet', null, null, 4),
	('United', 'n517ly', 4, 400, 'plane_7', 'jet', null, null, 2),
	('United', 'n620la', 4, 200, 'plane_8', 'prop', FALSE, 2, null),
	('Southwest', 'n401fj', 4, 200, 'plane_9', 'jet', null, null, 2),
	('Southwest', 'n653fk', 6, 400, null, 'jet', null, null, 2),
	('Southwest', 'n118fm', 4, 100, 'plane_11', 'prop', TRUE, 1, null),
	('Southwest', 'n815pw', 3, 200, null, 'prop', FALSE, 2, null),
	('JetBlue', 'n161fk', 4, 200, null, 'jet', null, null, 2),
	('JetBlue', 'n337as', 5, 400, null, 'jet', null, null, 2),
	('Spirit', 'n256ap', 4, 400, 'plane_15', 'jet', null, null, 2),
	('Delta', 'n156sq', 8, 100, null, null, null, null, null),
	('United', 'n451fi', 5, 400, null, 'jet', null, null, 4);

	insert into airport values
	('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 'port_1'),
	('DFW', 'Dallas-Fort Worth International Airport', 'Dallas', 'TX', 'port_2'),
	('DEN', 'Denver International Airport', 'Denver', 'CO', 'port_3'),
	('ORD', 'O_Hare International Airport', 'Chicago', 'IL', 'port_4'),
	('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 'port_5'),
	('LGA', 'LaGuardia Airport', 'New York', 'NY', null),
	('JFK', 'John F_Kennedy International Airport', 'New York', 'NY', 'port_15'),
	('MDW', 'Chicago Midway International Airport', 'Chicago', 'IL', null),
	('DCA', 'Ronald Reagan Washington National Airport', 'Washington', 'DC', 'port_9'),
	('IAD', 'Washington Dulles International Airport', 'Washington', 'DC', 'port_11'),
	('DAL', 'Dallas Love Field', 'Dallas', 'TX', 'port_7'),
	('IAH', 'George Bush Intercontinental Houston Airport', 'Houston', 'TX', 'port_13'),
	('HOU', 'William P_Hobby Airport', 'Houston', 'TX', 'port_18'),
	('BHM', 'Birmingham-Shuttlesworth International Airport', 'Birmingham', 'AL', null),
	('MRI', 'Merrill Field', 'Anchorage', 'AK', null),
	('ANC', 'Ted Stevens Anchorage International Airport', 'Anchorage', 'AK', null),
	('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'AZ', null),
	('LIT', 'Bill and Hillary Clinton National Airport', 'Little Rock', 'AR', null),
	('BDL', 'Bradley International Airport', 'Hartford', 'CT', null),
	('ILG', 'Wilmington Airport', 'Wilmington', 'DE', null),
	('MCO', 'Orlando International Airport', 'Orlando', 'FL', null),
	('HNL', 'Daniel K. Inouye International Airport', 'Honolulu Oahu', 'HI', null),
	('BOI', 'Boise Airport', 'Boise', 'ID', null),
	('IND', 'Indianapolis International Airport', 'Indianapolis', 'IN', null),
	('DSM', 'Des Moines International Airport', 'Des Moines', 'IA', null),
	('ICT', 'Wichita Dwight D_Eisenhower National Airport', 'Wichita', 'KS', null),
	('SDF', 'Louisville International Airport', 'Louisville', 'KY', null),
	('MSY', 'Louis Armstrong New Orleans International Airport', 'New Orleans', 'LA', null),
	('PWM', 'Portland International Jetport', 'Portland', 'ME', null),
	('BWI', 'Baltimore_Washington International Airport', 'Baltimore', 'MD', null),
	('BOS', 'General Edward Lawrence Logan International Airport', 'Boston', 'MA', null),
	('DTW', 'Detroit Metro Wayne County Airport', 'Detroit', 'MI', null),
	('MSP', 'Minneapolis_St_Paul International Wold_Chamberlain Airport', 'Minneapolis Saint Paul', 'MN', null),
	('JAN', 'Jackson_Medgar Wiley Evers International Airport', 'Jackson', 'MS', null),
	('STL', 'St_Louis Lambert International Airport', 'Saint Louis', 'MO', null),
	('BZN', 'Bozeman Yellowstone International Airport', 'Bozeman', 'MT', null),
	('OMA', 'Eppley Airfield', 'Omaha', 'NE', null),
	('LAS', 'Harry Reid International Airport', 'Las Vegas', 'NV', null),
	('MHT', 'Manchester_Boston Regional Airport', 'Manchester', 'NH', null),
	('EWR', 'Newark Liberty International Airport', 'Newark', 'NJ', null),
	('ABQ', 'Albuquerque International Sunport', 'Albuquerque', 'NM', null),
	('ISP', 'Long Island MacArthur Airport', 'New York Islip', 'NY', 'port_14'),
	('CLT', 'Charlotte Douglas International Airport', 'Charlotte', 'NC', null),
	('FAR', 'Hector International Airport', 'Fargo', 'ND', null),
	('CLE', 'Cleveland Hopkins International Airport', 'Cleveland', 'OH', null),
	('OKC', 'Will Rogers World Airport', 'Oklahoma City', 'OK', null),
	('PDX', 'Portland International Airport', 'Portland', 'OR', null),
	('PHL', 'Philadelphia International Airport', 'Philadelphia', 'PA', null),
	('PVD', 'Rhode Island T_F_Green International Airport', 'Providence', 'RI', null),
	('CHS', 'Charleston International Airport', 'Charleston', 'SC', null),
	('FSD', 'Joe Foss Field', 'Sioux Falls', 'SD', null),
	('BNA', 'Nashville International Airport', 'Nashville', 'TN', null),
	('SLC', 'Salt Lake City International Airport', 'Salt Lake City', 'UT', null),
	('BTV', 'Burlington International Airport', 'Burlington', 'VT', null),
	('SEA', 'Seattle-Tacoma International Airport', 'Seattle Tacoma', 'WA', 'port_17'),
	('BFI', 'King County International Airport', 'Seattle', 'WA', 'port_10'),
	('CRW', 'Yeager Airport', 'Charleston', 'WV', null),
	('MKE', 'Milwaukee Mitchell International Airport', 'Milwaukee', 'WI', null),
	('JAC', 'Jackson Hole Airport', 'Jackson', 'WY', null),
	('GUM', 'Antonio B_Won Pat International Airport', 'Agana Tamuning', 'GU', null),
	('GSN', 'Saipan International Airport', 'Obyan Saipan Island', 'MP', null),
	('SJU', 'Luis Munoz Marin International Airport', 'San Juan Carolina', 'PR', null),
	('STT', 'Cyril E_King Airport', 'Charlotte Amalie Saint Thomas', 'VI', null);

	insert into person values
	('p1', 'Jeanne', 'Nelson', 'plane_1'),
	('p2', 'Roxanne', 'Byrd', 'plane_1'),
	('p3', 'Tanya', 'Nguyen', 'plane_4'),
	('p4', 'Kendra', 'Jacobs', 'plane_4'),
	('p5', 'Jeff', 'Burton', 'plane_4'),
	('p6', 'Randal', 'Parks', 'plane_7'),
	('p7', 'Sonya', 'Owens', 'plane_7'),
	('p8', 'Bennie', 'Palmer', 'plane_8'),
	('p9', 'Marlene', 'Warner', 'plane_8'),
	('p10', 'Lawrence', 'Morgan', 'plane_9'),
	('p11', 'Sandra', 'Cruz', 'plane_9'),
	('p12', 'Dan', 'Ball', 'plane_11'),
	('p13', 'Bryant', 'Figueroa', 'plane_2'),
	('p14', 'Dana', 'Perry', 'plane_2'),
	('p15', 'Matt', 'Hunt', 'plane_2'),
	('p16', 'Edna', 'Brown', 'plane_15'),
	('p17', 'Ruby', 'Burgess', 'plane_15'),
	('p18', 'Esther', 'Pittman', 'port_2'),
	('p19', 'Doug', 'Fowler', 'port_4'),
	('p20', 'Thomas', 'Olson', 'port_3'),
	('p21', 'Mona', 'Harrison', 'port_4'),
	('p22', 'Arlene', 'Massey', 'port_2'),
	('p23', 'Judith', 'Patrick', 'port_3'),
	('p24', 'Reginald', 'Rhodes', 'plane_1'),
	('p25', 'Vincent', 'Garcia', 'plane_1'),
	('p26', 'Cheryl', 'Moore', 'plane_4'),
	('p27', 'Michael', 'Rivera', 'plane_7'),
	('p28', 'Luther', 'Matthews', 'plane_8'),
	('p29', 'Moses', 'Parks', 'plane_8'),
	('p30', 'Ora', 'Steele', 'plane_9'),
	('p31', 'Antonio', 'Flores', 'plane_9'),
	('p32', 'Glenn', 'Ross', 'plane_11'),
	('p33', 'Irma', 'Thomas', 'plane_11'),
	('p34', 'Ann', 'Maldonado', 'plane_2'),
	('p35', 'Jeffrey', 'Cruz', 'plane_2'),
	('p36', 'Sonya', 'Price', 'plane_15'),
	('p37', 'Tracy', 'Hale', 'plane_15'),
	('p38', 'Albert', 'Simmons', 'port_1'),
	('p39', 'Karen', 'Terry', 'port_9'),
	('p40', 'Glen', 'Kelley', 'plane_4'),
	('p41', 'Brooke', 'Little', 'port_4'),
	('p42', 'Daryl', 'Nguyen', 'port_3'),
	('p43', 'Judy', 'Willis', 'port_1'),
	('p44', 'Marco', 'Klein', 'port_2'),
	('p45', 'Angelica', 'Hampton', 'port_5');

	insert into pilot values
	('p1', '330-12-6907', 31, 'Delta', 'n106js'),
	('p2', '842-88-1257', 9, 'Delta', 'n106js'),
	('p3', '750-24-7616', 11, 'American', 'n330ss'),
	('p4', '776-21-8098', 24, 'American', 'n330ss'),
	('p5', '933-93-2165', 27, 'American', 'n330ss'),
	('p6', '707-84-4555', 38, 'United', 'n517ly'),
	('p7', '450-25-5617', 13, 'United', 'n517ly'),
	('p8', '701-38-2179', 12, 'United', 'n620la'),
	('p9', '936-44-6941', 13, 'United', 'n620la'),
	('p10', '769-60-1266', 15, 'Southwest', 'n401fj'),
	('p11', '369-22-9505', 22, 'Southwest', 'n401fj'),
	('p12', '680-92-5329', 24, 'Southwest', 'n118fm'),
	('p13', '513-40-4168', 24, 'Delta', 'n110jn'),
	('p14', '454-71-7847', 13, 'Delta', 'n110jn'),
	('p15', '153-47-8101', 30, 'Delta', 'n110jn'),
	('p16', '598-47-5172', 28, 'Spirit', 'n256ap'),
	('p17', '865-71-6800', 36, 'Spirit', 'n256ap'),
	('p18', '250-86-2784', 23, null, null),
	('p19', '386-39-7881', 2, null, null),
	('p20', '522-44-3098', 28, null, null),
	('p21', '621-34-5755', 2, null, null),
	('p22', '177-47-9877', 3, null, null),
	('p23', '528-64-7912', 12, null, null),
	('p24', '803-30-1789', 34, null, null),
	('p25', '986-76-1587', 13, null, null),
	('p26', '584-77-5105', 20, null, null);

	insert into pilot_licenses values
	('p1', 'jet'),
	('p2', 'jet'),
	('p2', 'prop'),
	('p3', 'jet'),
	('p4', 'jet'),
	('p4', 'prop'),
	('p5', 'jet'),
	('p6', 'jet'),
	('p6', 'prop'),
	('p7', 'jet'),
	('p8', 'prop'),
	('p9', 'prop'),
	('p9', 'jet'),
	('p9', 'testing'),
	('p10', 'jet'),
	('p11', 'jet'),
	('p11', 'prop'),
	('p12', 'prop'),
	('p13', 'jet'),
	('p14', 'jet'),
	('p15', 'jet'),
	('p15', 'prop'),
	('p15', 'testing'),
	('p16', 'jet'),
	('p17', 'jet'),
	('p17', 'prop'),
	('p18', 'jet'),
	('p19', 'jet'),
	('p20', 'jet'),
	('p21', 'jet'),
	('p21', 'prop'),
	('p22', 'jet'),
	('p23', 'jet'),
	('p24', 'jet'),
	('p24', 'prop'),
	('p24', 'testing'),
	('p25', 'jet'),
	('p26', 'jet');

	insert into passenger values
	('p21', 771),
	('p22', 374),
	('p23', 414),
	('p24', 292),
	('p25', 390),
	('p26', 302),
	('p27', 470),
	('p28', 208),
	('p29', 292),
	('p30', 686),
	('p31', 547),
	('p32', 257),
	('p33', 564),
	('p34', 211),
	('p35', 233),
	('p36', 293),
	('p37', 552),
	('p38', 812),
	('p39', 541),
	('p40', 441),
	('p41', 875),
	('p42', 691),
	('p43', 572),
	('p44', 572),
	('p45', 663);

	insert into leg values
	('leg_1', 600, 'ATL', 'IAD'),
	('leg_2', 600, 'ATL', 'IAH'),
	('leg_3', 800, 'ATL', 'JFK'),
	('leg_4', 600, 'ATL', 'ORD'),
	('leg_5', 1000, 'BFI', 'LAX'),
	('leg_6', 200, 'DAL', 'HOU'),
	('leg_7', 600, 'DCA', 'ATL'),
	('leg_8', 200, 'DCA', 'JFK'),
	('leg_9', 800, 'DFW', 'ATL'),
	('leg_10', 800, 'DFW', 'ORD'),
	('leg_11', 600, 'IAD', 'ORD'),
	('leg_12', 200, 'IAH', 'DAL'),
	('leg_13', 1400, 'IAH', 'LAX'),
	('leg_14', 2400, 'ISP', 'BFI'),
	('leg_15', 800, 'JFK', 'ATL'),
	('leg_16', 800, 'JFK', 'ORD'),
	('leg_17', 2400, 'JFK', 'SEA'),
	('leg_18', 1200, 'LAX', 'DFW'),
	('leg_19', 1000, 'LAX', 'SEA'),
	('leg_20', 600, 'ORD', 'DCA'),
	('leg_21', 800, 'ORD', 'DFW'),
	('leg_22', 800, 'ORD', 'LAX'),
	('leg_23', 2400, 'SEA', 'JFK'),
	('leg_24', 1800, 'SEA', 'ORD'),
	('leg_25', 600, 'ORD', 'ATL'),
	('leg_26', 800, 'LAX', 'ORD'),
	('leg_27', 1600, 'ATL', 'LAX');

	insert into route values
	('eastbound_north_milk_run'),
	('westbound_north_milk_run'),
	('eastbound_south_milk_run'),
	('eastbound_north_nonstop'),
	('westbound_north_nonstop'),
	('northbound_west_coast'),
	('northbound_east_coast'),
	('southbound_midwest'),
	('circle_west_coast'),
	('circle_east_coast'),
	('hub_xchg_southeast'),
	('hub_xchg_southwest'),
	('westbound_south_nonstop'),
	('local_texas');

	insert into route_path values
	('eastbound_north_milk_run', 'leg_24', 1),
	('eastbound_north_milk_run', 'leg_20', 2),
	('eastbound_north_milk_run', 'leg_8', 3),
	('westbound_north_milk_run', 'leg_16', 1),
	('westbound_north_milk_run', 'leg_22', 2),
	('westbound_north_milk_run', 'leg_19', 3),
	('eastbound_south_milk_run', 'leg_18', 1),
	('eastbound_south_milk_run', 'leg_9', 2),
	('eastbound_south_milk_run', 'leg_1', 3),
	('eastbound_north_nonstop', 'leg_23', 1),
	('westbound_north_nonstop', 'leg_17', 1),
	('northbound_west_coast', 'leg_19', 1),
	('northbound_east_coast', 'leg_3', 1),
	('southbound_midwest', 'leg_21', 1),
	('circle_west_coast', 'leg_18', 1),
	('circle_west_coast', 'leg_10', 2),
	('circle_west_coast', 'leg_22', 3),
	('circle_east_coast', 'leg_4', 1),
	('circle_east_coast', 'leg_20', 2),
	('circle_east_coast', 'leg_7', 3),
	('hub_xchg_southeast', 'leg_25', 1),
	('hub_xchg_southeast', 'leg_4', 2),
	('hub_xchg_southwest', 'leg_22', 1),
	('hub_xchg_southwest', 'leg_26', 2),
	('westbound_south_nonstop', 'leg_27', 1),
	('local_texas', 'leg_12', 1),
	('local_texas', 'leg_6', 2);

	insert into flight values
	('DL_1174', 'northbound_east_coast', 'Delta', 'n106js', 0, 'on_ground', '08:00:00'),
	('AM_1523', 'circle_west_coast', 'American', 'n330ss', 2, 'on_ground', '14:30:00'),
	('UN_1899', 'eastbound_north_milk_run', 'United', 'n517ly', 0, 'on_ground', '09:30:00'),
	('UN_523', 'hub_xchg_southeast', 'United', 'n620la', 1, 'in_flight', '11:00:00'),
	('SW_1776', 'hub_xchg_southwest', 'Southwest', 'n401fj', 2, 'in_flight', '14:00:00'),
	('SW_610', 'local_texas', 'Southwest', 'n118fm', 2, 'in_flight', '11:30:00'),
	('DL_1243', 'westbound_north_nonstop', 'Delta', 'n110jn', 0, 'on_ground', '09:30:00'),
	('SP_1880', 'circle_east_coast', 'Spirit', 'n256ap', 2, 'in_flight', '15:00:00'),
	('DL_3410', 'circle_east_coast', null, null, null, null, null),
	('UN_717', 'circle_west_coast', null, null, null, null, null);

	insert into ticket values
	('tkt_dl_1', 450, 'DL_1174', 'p24', 'JFK'),
	('tkt_dl_2', 225, 'DL_1174', 'p25', 'JFK'),
	('tkt_am_3', 250, 'AM_1523', 'p26', 'LAX'),
	('tkt_un_4', 175, 'UN_1899', 'p27', 'DCA'),
	('tkt_un_5', 225, 'UN_523', 'p28', 'ATL'),
	('tkt_un_6', 100, 'UN_523', 'p29', 'ORD'),
	('tkt_sw_7', 400, 'SW_1776', 'p30', 'ORD'),
	('tkt_sw_8', 175, 'SW_1776', 'p31', 'ORD'),
	('tkt_sw_9', 125, 'SW_610', 'p32', 'HOU'),
	('tkt_sw_10', 425, 'SW_610', 'p33', 'HOU'),
	('tkt_dl_11', 500, 'DL_1243', 'p34', 'LAX'),
	('tkt_dl_12', 250, 'DL_1243', 'p35', 'LAX'),
	('tkt_sp_13', 225, 'SP_1880', 'p36', 'ATL'),
	('tkt_sp_14', 150, 'SP_1880', 'p37', 'DCA'),
	('tkt_un_15', 150, 'UN_523', 'p38', 'ORD'),
	('tkt_sp_16', 475, 'SP_1880', 'p39', 'ATL'),
	('tkt_am_17', 375, 'AM_1523', 'p40', 'ORD'),
	('tkt_am_18', 275, 'AM_1523', 'p41', 'LAX');

	insert into ticket_seats values
	('tkt_dl_1', '1C'),
	('tkt_dl_1', '2F'),
	('tkt_dl_2', '2D'),
	('tkt_am_3', '3B'),
	('tkt_un_4', '2B'),
	('tkt_un_5', '1A'),
	('tkt_un_6', '3B'),
	('tkt_sw_7', '3C'),
	('tkt_sw_8', '3E'),
	('tkt_sw_9', '1C'),
	('tkt_sw_10', '1D'),
	('tkt_dl_11', '1E'),
	('tkt_dl_11', '1B'),
	('tkt_dl_11', '2F'),
	('tkt_dl_12', '2A'),
	('tkt_sp_13', '1A'),
	('tkt_am_17', '2B'),
	('tkt_am_18', '2A');
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [2] Create views to evaluate the queries & transactions
-- ----------------------------------------------------------------------------------
    
-- Create one view per original base table and student-created view to be used
-- to evaluate the transaction results.
create or replace view practiceQuery10 as select * from airline;
create or replace view practiceQuery11 as select * from location;
create or replace view practiceQuery12 as select * from airplane;
create or replace view practiceQuery13 as select * from airport;
create or replace view practiceQuery14 as select * from person;
create or replace view practiceQuery15 as select * from pilot;
create or replace view practiceQuery16 as select * from pilot_licenses;
create or replace view practiceQuery17 as select * from passenger;
create or replace view practiceQuery18 as select * from leg;
create or replace view practiceQuery19 as select * from route;
create or replace view practiceQuery20 as select * from route_path;
create or replace view practiceQuery21 as select * from flight;
create or replace view practiceQuery22 as select * from ticket;
create or replace view practiceQuery23 as select * from ticket_seats;

create or replace view practiceQuery30 as select * from flights_in_the_air;
create or replace view practiceQuery31 as select * from flights_on_the_ground;
create or replace view practiceQuery32 as select * from people_in_the_air;
create or replace view practiceQuery33 as select * from people_on_the_ground;
create or replace view practiceQuery34 as select * from route_summary;
create or replace view practiceQuery35 as select * from alternative_airports;

-- ----------------------------------------------------------------------------------
-- [3] Prepare to capture the query results for later analysis
-- ----------------------------------------------------------------------------------

-- The magic44_data_capture table is used to store the data created by the student's queries
-- The table is populated by the magic44_evaluate_queries stored procedure
-- The data in the table is used to populate the magic44_test_results table for analysis

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stepID integer, queryID integer,
    columnDump0 varchar(1000), columnDump1 varchar(1000), columnDump2 varchar(1000), columnDump3 varchar(1000), columnDump4 varchar(1000),
    columnDump5 varchar(1000), columnDump6 varchar(1000), columnDump7 varchar(1000), columnDump8 varchar(1000), columnDump9 varchar(1000),
	columnDump10 varchar(1000), columnDump11 varchar(1000), columnDump12 varchar(1000), columnDump13 varchar(1000), columnDump14 varchar(1000)
);

-- The magic44_column_listing table is used to help prepare the insert statements for the magic44_data_capture
-- table for the student's queries which may have variable numbers of columns (the table is prepopulated)

drop table if exists magic44_column_listing;
create table magic44_column_listing (
	columnPosition integer,
    simpleColumnName varchar(50),
    nullColumnName varchar(50)
);

insert into magic44_column_listing (columnPosition, simpleColumnName) values
(0, 'columnDump0'), (1, 'columnDump1'), (2, 'columnDump2'), (3, 'columnDump3'), (4, 'columnDump4'),
(5, 'columnDump5'), (6, 'columnDump6'), (7, 'columnDump7'), (8, 'columnDump8'), (9, 'columnDump9'),
(10, 'columnDump10'), (11, 'columnDump11'), (12, 'columnDump12'), (13, 'columnDump13'), (14, 'columnDump14');

drop function if exists magic44_gen_simple_template;
delimiter //
create function magic44_gen_simple_template(numberOfColumns integer)
	returns varchar(1000) reads sql data
begin
	return (select group_concat(simpleColumnName separator ', ') from magic44_column_listing
	where columnPosition < numberOfColumns);
end //
delimiter ;

-- Create a variable to effectively act as a program counter for the testing process/steps
set @stepCounter = 0;

-- The magic44_query_capture function is used to construct the instruction
-- that can be used to execute and store the results of a query

drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer)
	returns varchar(2000) reads sql data
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('practiceQuery', thisQuery));

	set @buildQuery = 'insert into magic44_data_capture (stepID, queryID, ';
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ') select ');
    set @buildQuery = concat(@buildQuery, @stepCounter, ', ');
    set @buildQuery = concat(@buildQuery, thisQuery, ', practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, '.* from practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, ';');

return @buildQuery;
end //
delimiter ;

drop function if exists magic44_query_exists;
delimiter //
create function magic44_query_exists(thisQuery integer)
	returns integer deterministic
begin
	return (select exists (select * from information_schema.views
		where table_schema = @thisDatabase
        and table_name like concat('practiceQuery', thisQuery)));
end //
delimiter ;

-- Exception checking has been implemented to prevent (as much as reasonably possible) errors
-- in the queries being evaluated from interrupting the testing process
-- The magic44_log_query_errors table captures these errors for later review

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	step_id integer,
    query_id integer,
    query_text varchar(2000),
    error_code char(5),
    error_message text
);

drop procedure if exists magic44_query_check_and_run;
delimiter //
create procedure magic44_query_check_and_run(in thisQuery integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;

	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

    declare continue handler for SQLWARNING
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		set @sql_text = magic44_query_capture(thisQuery);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000' then
			insert into magic44_log_query_errors values (@stepCounter, thisQuery, @sql_text, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [4] Organize the testing results by step and query identifiers
-- ----------------------------------------------------------------------------------

drop table if exists magic44_test_case_directory;
create table if not exists magic44_test_case_directory (
	base_step_id integer,
	number_of_steps integer,
    query_label char(20),
    query_name varchar(100),
    scoring_weight integer
);

insert into magic44_test_case_directory values
(0, 1, '[V_0]', 'initial_state_check', 0),
(20, 1, '[C_1]', 'add_airplane', 1),
(40, 1, '[C_2]', 'add_airport', 1),
(60, 1, '[C_3]', 'add_person', 1),
(80, 1, '[C_4]', 'grant_pilot_license', 1),
(100, 1, '[C_5]', 'offer_flight', 1),
(120, 1, '[C_6]', 'purchase_ticket_and_seat', 1),
(140, 1, '[C_7]', 'add_update_leg', 1),
(160, 1, '[C_8]', 'start_route', 1),
(180, 1, '[C_9]', 'extend_route', 1),
(200, 1, '[U_1]', 'flight_landing', 1),
(220, 1, '[U_2]', 'flight_takeoff', 1),
(240, 1, '[U_3]', 'passengers_board', 1),
(260, 1, '[U_4]', 'passengers_disembark', 1),
(280, 1, '[U_5]', 'assign_pilot', 1),
(300, 1, '[U_6]', 'recycle_crew', 1),
(320, 1, '[R_1]', 'retire_flight', 1),
(340, 1, '[R_2]', 'remove_passenger_role', 1),
(360, 1, '[R_3]', 'remove_pilot_role', 1),
(380, 1, '[V_1]', 'flights_in_the_air', 1),
(400, 1, '[V_2]', 'flights_on_the_ground', 1),
(420, 1, '[V_3]', 'people_in_the_air', 1),
(440, 1, '[V_4]', 'people_on_the_ground', 1),
(460, 1, '[V_5]', 'route_summary', 1),
(480, 1, '[V_6]', 'alternative_airports', 1),
(500, 1, '[U_7]', 'simulation_cycle', 1),
(600, 1, '[E_1]', 'one_leg', 1),
(650, 0, '[E_2]', 'one_leg_with_errors', 1),
(700, 0, '[E_3]', 'monitor_one_leg', 1),
(750, 0, '[E_4]', 'multiple_legs', 1),
(800, 0, '[E_5]', 'multiple_legs_with_errors', 1),
(850, 0, '[E_6]', 'monitor_multiple_legs', 1),
(900, 0, '[E_7]', 'single_simulation_cycle', 1),
(950, 0, '[E_8]', 'multiple_simulation_cycles', 1);

drop table if exists magic44_scores_guide;
create table if not exists magic44_scores_guide (
    score_tag char(1),
    score_category varchar(100),
    display_order integer
);

insert into magic44_scores_guide values
('C', 'Create Transactions', 1), ('U', 'Use Case Transactions', 2),
('R', 'Remove Transactions', 3), ('V', 'Global Views/Queries', 4),
('E', 'Event Scenarios/Sequences', 5);

-- ----------------------------------------------------------------------------------
-- [5] Test the queries & transactions and store the results
-- ----------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------
/* Check that the initial state of their database matches the required configuration.
The magic44_reset_database_state() call is deliberately missing in order to evaluate
the state of the submitted database. */
-- ----------------------------------------------------------------------------------
set @stepCounter = 0;
call magic44_query_check_and_run(10); -- airline
call magic44_query_check_and_run(11); -- location
call magic44_query_check_and_run(12); -- airplane
call magic44_query_check_and_run(13); -- airport
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot
call magic44_query_check_and_run(16); -- pilot_licenses
call magic44_query_check_and_run(17); -- passenger
call magic44_query_check_and_run(18); -- leg
call magic44_query_check_and_run(19); -- route
call magic44_query_check_and_run(20); -- route_path
call magic44_query_check_and_run(21); -- flight
call magic44_query_check_and_run(22); -- ticket
call magic44_query_check_and_run(23); -- ticket_seats

-- ----------------------------------------------------------------------------------
/* Check the unit test cases here.  The magic44_reset_database_state() call is used
for each test to ensure that the database state is set to the initial configuration.
The @stepCounter is set to index the test appropriately, and then the test call is
performed.  Finally, calls are made to the appropriate database tables to compare the
actual state changes to the expected state changes per our answer key. */
-- ----------------------------------------------------------------------------------
-- [1] add_airplane() SUCCESS case(s)
-- Add test cases that satisfy all guard conditions and change the database state
call magic44_reset_database_state();
set @stepCounter = 20;
call add_airplane('Delta', 'n120jn', 10, 350, null, 'jet', null, null, 4);
call magic44_query_check_and_run(12); -- airplane

-- [1] add_airplane() FAILURE case(s)
-- Add test cases that violate one or more of the guard conditions

-- [2] add_airport() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 40;
call add_airport('SJC', 'San Jose Mineta International Airport', 'San Jose', 'CA', null);
call magic44_query_check_and_run(13); -- airport
    
-- [3] add_person() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 60;
call add_person('p78','Sam','Jones','port_2', null, 4, 'American', 'n330ss', 20);
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot
call magic44_query_check_and_run(17); -- passenger

-- [4] grant_pilot_license() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 80;
call grant_pilot_license('p1', 'prop');
call magic44_query_check_and_run(16); -- pilot_licenses

-- [5] offer_flight() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 100;
call offer_flight('UN_3403', 'westbound_north_milk_run', 'American', 'n380sd', 0, 'on_ground', '15:30:00');
call magic44_query_check_and_run(21); -- flight

-- [6] purchase_ticket_and_seat() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 120;
call purchase_ticket_and_seat('tkt_dl_20', 450, 'DL_1174', 'p23', 'JFK', '5A');
call magic44_query_check_and_run(22); -- ticket
call magic44_query_check_and_run(23); -- ticket_seats

-- [7] add_update_leg() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 140;
call add_update_leg('leg_28', 2800, 'DCA', 'SEA');
call magic44_query_check_and_run(18); -- leg

-- [8] start_route() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 160;
call start_route('new_eastbound_west_milk_run','leg_10');
call magic44_query_check_and_run(19); -- route
call magic44_query_check_and_run(20); -- route_path

-- [9] extend_route() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 180;
call extend_route('eastbound_south_milk_run', 'leg_11');
call magic44_query_check_and_run(20); -- route_path

-- [10] flight_landing() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 200;
call flight_landing('SW_1776');
call magic44_query_check_and_run(15); -- pilot
call magic44_query_check_and_run(17); -- passenger
call magic44_query_check_and_run(21); -- flight

-- [11] flight_takeoff() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 220;
call flight_takeoff('DL_1174');
call magic44_query_check_and_run(21); -- flight

-- [12] passengers_board() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 240;
call passengers_board('AM_1523');
call magic44_query_check_and_run(14); -- person

-- [13] passengers_disembark() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 260;
call passengers_disembark('AM_1523');
call magic44_query_check_and_run(14); -- person

-- [14] assign_pilot() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 280;
call assign_pilot('AM_1523', 'p19');
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot

-- [15] recycle_crew() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 300;
update flight set progress = 3 where flightID = 'AM_1523';
update person set locationID = 'port_5' where personID in ('p26', 'p40', 'p41');
call recycle_crew('AM_1523');
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot

-- [16] retire_flight() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 320;
call retire_flight('DL_1243');
call magic44_query_check_and_run(21); -- flight

-- [17] remove_passenger_role() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 340;
call remove_passenger_role('p45');
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(17); -- passenger
call magic44_query_check_and_run(22); -- ticket

-- [18] remove_pilot_role() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 360;
call remove_pilot_role('p20');
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot
call magic44_query_check_and_run(16); -- pilot_licenses

-- [19] flights_in_the_air() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 380;
call magic44_query_check_and_run(30); -- flights_in_the_air

-- [19] flights_in_the_air() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 380;
call magic44_query_check_and_run(30); -- flights_in_the_air

-- [20] flights_on_the_ground() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 400;
call magic44_query_check_and_run(31); -- flights_on_the_ground

-- [21] people_in_the_air() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 420;
call magic44_query_check_and_run(32); -- people_in_the_air

-- [22] people_on_the_ground() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 440;
call magic44_query_check_and_run(33); -- people_on_the_ground

-- [23] route_summary() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 460;
call magic44_query_check_and_run(34); -- route_summary

-- [24] alternative_airports() INITIAL & ALTERNATE STATE case(s)
call magic44_reset_database_state();
set @stepCounter = 480;
call magic44_query_check_and_run(35); -- alternative_airports

-- [25] simulation_cycle() SUCCESS case(s)
call magic44_reset_database_state();
set @stepCounter = 500;
call simulation_cycle();
call magic44_query_check_and_run(12); -- airplane
call magic44_query_check_and_run(13); -- airport
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot
call magic44_query_check_and_run(16); -- pilot_licenses
call magic44_query_check_and_run(17); -- passenger
call magic44_query_check_and_run(21); -- flight
call magic44_query_check_and_run(22); -- ticket
call magic44_query_check_and_run(23); -- ticket_seats

-- [] One Leg: EVENT SCENARIO #1
call magic44_reset_database_state();

set @stepCounter = 600;
-- make sure that passengers at the airport board the flight
call passengers_board('DL_1174');
-- have the flight take off towards the destination
call flight_takeoff('DL_1174');
-- evaluate the relevant tables for this sequence of procedure calls
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(21); -- flight

set @stepCounter = @stepCounter + 1;
-- when ready, have the flight land at the destination airport
call flight_landing('DL_1174');
-- once the flight has landed, have the passengers disembark as needed
call passengers_disembark('DL_1174');
-- evaluate the relevant tables for this sequence of procedure calls
call magic44_query_check_and_run(14); -- person
call magic44_query_check_and_run(15); -- pilot
call magic44_query_check_and_run(17); -- passenger
call magic44_query_check_and_run(21); -- flight

-- [] One Leg with Errors: EVENT SCENARIO #2
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 650;

-- [] One Leg with Errors & View Monitoring: EVENT SCENARIO #3
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 700;

-- [] Multiple Legs: EVENT SCENARIO #4
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 750;

-- [] Multiple Legs with Errors: EVENT SCENARIO #5
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 800;

-- [] Multiple Legs with Errors & View Monitoring: EVENT SCENARIO #6
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 850;

-- [] Single Simulation Cycle: EVENT SCENARIO #7
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 900;

-- [] Multiple Simulation Cycles: EVENT SCENARIO #8
call magic44_reset_database_state();
-- make sure that passengers at the airport board the flight
set @stepCounter = 950;

-- ----------------------------------------------------------------------------------
-- [6] Collect and analyze the testing results for the student's submission
-- ----------------------------------------------------------------------------------

-- These tables are used to store the answers and test results.  The answers are generated by executing
-- the test script against our reference solution.  The test results are collected by running the test
-- script against your submission in order to compare the results.

-- The results from magic44_data_capture are transferred into the magic44_test_results table
drop table if exists magic44_test_results;
create table magic44_test_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

insert into magic44_test_results
select stepID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

-- the answers generated from the reference solution are loaded below
drop table if exists magic44_expected_results;
create table magic44_expected_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null,
    index (step_id),
    index (query_id)
);

insert into magic44_expected_results values
(0,10,'air_france#25#############'),
(0,10,'american#45#############'),
(0,10,'delta#46#############'),
(0,10,'jetblue#8#############'),
(0,10,'lufthansa#31#############'),
(0,10,'southwest#22#############'),
(0,10,'spirit#4#############'),
(0,10,'united#40#############'),
(0,11,'plane_1##############'),
(0,11,'plane_11##############'),
(0,11,'plane_15##############'),
(0,11,'plane_2##############'),
(0,11,'plane_4##############'),
(0,11,'plane_7##############'),
(0,11,'plane_8##############'),
(0,11,'plane_9##############'),
(0,11,'port_1##############'),
(0,11,'port_10##############'),
(0,11,'port_11##############'),
(0,11,'port_13##############'),
(0,11,'port_14##############'),
(0,11,'port_15##############'),
(0,11,'port_17##############'),
(0,11,'port_18##############'),
(0,11,'port_2##############'),
(0,11,'port_3##############'),
(0,11,'port_4##############'),
(0,11,'port_5##############'),
(0,11,'port_7##############'),
(0,11,'port_9##############'),
(0,12,'american#n330ss#4#200#plane_4#jet###2######'),
(0,12,'american#n380sd#5#400##jet###2######'),
(0,12,'delta#n106js#4#200#plane_1#jet###2######'),
(0,12,'delta#n110jn#5#600#plane_2#jet###4######'),
(0,12,'delta#n127js#4#800###########'),
(0,12,'delta#n156sq#8#100###########'),
(0,12,'jetblue#n161fk#4#200##jet###2######'),
(0,12,'jetblue#n337as#5#400##jet###2######'),
(0,12,'southwest#n118fm#4#100#plane_11#prop#1#1#######'),
(0,12,'southwest#n401fj#4#200#plane_9#jet###2######'),
(0,12,'southwest#n653fk#6#400##jet###2######'),
(0,12,'southwest#n815pw#3#200##prop#0#2#######'),
(0,12,'spirit#n256ap#4#400#plane_15#jet###2######'),
(0,12,'united#n451fi#5#400##jet###4######'),
(0,12,'united#n517ly#4#400#plane_7#jet###2######'),
(0,12,'united#n616lt#7#400##jet###4######'),
(0,12,'united#n620la#4#200#plane_8#prop#0#2#######'),
(0,13,'abq#albuquerqueinternationalsunport#albuquerque#nm###########'),
(0,13,'anc#tedstevensanchorageinternationalairport#anchorage#ak###########'),
(0,13,'atl#hartsfield-jacksonatlantainternationalairport#atlanta#ga#port_1##########'),
(0,13,'bdl#bradleyinternationalairport#hartford#ct###########'),
(0,13,'bfi#kingcountyinternationalairport#seattle#wa#port_10##########'),
(0,13,'bhm#birmingham-shuttlesworthinternationalairport#birmingham#al###########'),
(0,13,'bna#nashvilleinternationalairport#nashville#tn###########'),
(0,13,'boi#boiseairport#boise#id###########'),
(0,13,'bos#generaledwardlawrenceloganinternationalairport#boston#ma###########'),
(0,13,'btv#burlingtoninternationalairport#burlington#vt###########'),
(0,13,'bwi#baltimore_washingtoninternationalairport#baltimore#md###########'),
(0,13,'bzn#bozemanyellowstoneinternationalairport#bozeman#mt###########'),
(0,13,'chs#charlestoninternationalairport#charleston#sc###########'),
(0,13,'cle#clevelandhopkinsinternationalairport#cleveland#oh###########'),
(0,13,'clt#charlottedouglasinternationalairport#charlotte#nc###########'),
(0,13,'crw#yeagerairport#charleston#wv###########'),
(0,13,'dal#dallaslovefield#dallas#tx#port_7##########'),
(0,13,'dca#ronaldreaganwashingtonnationalairport#washington#dc#port_9##########'),
(0,13,'den#denverinternationalairport#denver#co#port_3##########'),
(0,13,'dfw#dallas-fortworthinternationalairport#dallas#tx#port_2##########'),
(0,13,'dsm#desmoinesinternationalairport#desmoines#ia###########'),
(0,13,'dtw#detroitmetrowaynecountyairport#detroit#mi###########'),
(0,13,'ewr#newarklibertyinternationalairport#newark#nj###########'),
(0,13,'far#hectorinternationalairport#fargo#nd###########'),
(0,13,'fsd#joefossfield#siouxfalls#sd###########'),
(0,13,'gsn#saipaninternationalairport#obyansaipanisland#mp###########'),
(0,13,'gum#antoniob_wonpatinternationalairport#aganatamuning#gu###########'),
(0,13,'hnl#danielk.inouyeinternationalairport#honoluluoahu#hi###########'),
(0,13,'hou#williamp_hobbyairport#houston#tx#port_18##########'),
(0,13,'iad#washingtondullesinternationalairport#washington#dc#port_11##########'),
(0,13,'iah#georgebushintercontinentalhoustonairport#houston#tx#port_13##########'),
(0,13,'ict#wichitadwightd_eisenhowernationalairport#wichita#ks###########'),
(0,13,'ilg#wilmingtonairport#wilmington#de###########'),
(0,13,'ind#indianapolisinternationalairport#indianapolis#in###########'),
(0,13,'isp#longislandmacarthurairport#newyorkislip#ny#port_14##########'),
(0,13,'jac#jacksonholeairport#jackson#wy###########'),
(0,13,'jan#jackson_medgarwileyeversinternationalairport#jackson#ms###########'),
(0,13,'jfk#johnf_kennedyinternationalairport#newyork#ny#port_15##########'),
(0,13,'las#harryreidinternationalairport#lasvegas#nv###########'),
(0,13,'lax#losangelesinternationalairport#losangeles#ca#port_5##########'),
(0,13,'lga#laguardiaairport#newyork#ny###########'),
(0,13,'lit#billandhillaryclintonnationalairport#littlerock#ar###########'),
(0,13,'mco#orlandointernationalairport#orlando#fl###########'),
(0,13,'mdw#chicagomidwayinternationalairport#chicago#il###########'),
(0,13,'mht#manchester_bostonregionalairport#manchester#nh###########'),
(0,13,'mke#milwaukeemitchellinternationalairport#milwaukee#wi###########'),
(0,13,'mri#merrillfield#anchorage#ak###########'),
(0,13,'msp#minneapolis_st_paulinternationalwold_chamberlainairport#minneapolissaintpaul#mn###########'),
(0,13,'msy#louisarmstrongneworleansinternationalairport#neworleans#la###########'),
(0,13,'okc#willrogersworldairport#oklahomacity#ok###########'),
(0,13,'oma#eppleyairfield#omaha#ne###########'),
(0,13,'ord#o_hareinternationalairport#chicago#il#port_4##########'),
(0,13,'pdx#portlandinternationalairport#portland#or###########'),
(0,13,'phl#philadelphiainternationalairport#philadelphia#pa###########'),
(0,13,'phx#phoenixskyharborinternationalairport#phoenix#az###########'),
(0,13,'pvd#rhodeislandt_f_greeninternationalairport#providence#ri###########'),
(0,13,'pwm#portlandinternationaljetport#portland#me###########'),
(0,13,'sdf#louisvilleinternationalairport#louisville#ky###########'),
(0,13,'sea#seattle-tacomainternationalairport#seattletacoma#wa#port_17##########'),
(0,13,'sju#luismunozmarininternationalairport#sanjuancarolina#pr###########'),
(0,13,'slc#saltlakecityinternationalairport#saltlakecity#ut###########'),
(0,13,'stl#st_louislambertinternationalairport#saintlouis#mo###########'),
(0,13,'stt#cyrile_kingairport#charlotteamaliesaintthomas#vi###########'),
(0,14,'p1#jeanne#nelson#plane_1###########'),
(0,14,'p10#lawrence#morgan#plane_9###########'),
(0,14,'p11#sandra#cruz#plane_9###########'),
(0,14,'p12#dan#ball#plane_11###########'),
(0,14,'p13#bryant#figueroa#plane_2###########'),
(0,14,'p14#dana#perry#plane_2###########'),
(0,14,'p15#matt#hunt#plane_2###########'),
(0,14,'p16#edna#brown#plane_15###########'),
(0,14,'p17#ruby#burgess#plane_15###########'),
(0,14,'p18#esther#pittman#port_2###########'),
(0,14,'p19#doug#fowler#port_4###########'),
(0,14,'p2#roxanne#byrd#plane_1###########'),
(0,14,'p20#thomas#olson#port_3###########'),
(0,14,'p21#mona#harrison#port_4###########'),
(0,14,'p22#arlene#massey#port_2###########'),
(0,14,'p23#judith#patrick#port_3###########'),
(0,14,'p24#reginald#rhodes#plane_1###########'),
(0,14,'p25#vincent#garcia#plane_1###########'),
(0,14,'p26#cheryl#moore#plane_4###########'),
(0,14,'p27#michael#rivera#plane_7###########'),
(0,14,'p28#luther#matthews#plane_8###########'),
(0,14,'p29#moses#parks#plane_8###########'),
(0,14,'p3#tanya#nguyen#plane_4###########'),
(0,14,'p30#ora#steele#plane_9###########'),
(0,14,'p31#antonio#flores#plane_9###########'),
(0,14,'p32#glenn#ross#plane_11###########'),
(0,14,'p33#irma#thomas#plane_11###########'),
(0,14,'p34#ann#maldonado#plane_2###########'),
(0,14,'p35#jeffrey#cruz#plane_2###########'),
(0,14,'p36#sonya#price#plane_15###########'),
(0,14,'p37#tracy#hale#plane_15###########'),
(0,14,'p38#albert#simmons#port_1###########'),
(0,14,'p39#karen#terry#port_9###########'),
(0,14,'p4#kendra#jacobs#plane_4###########'),
(0,14,'p40#glen#kelley#plane_4###########'),
(0,14,'p41#brooke#little#port_4###########'),
(0,14,'p42#daryl#nguyen#port_3###########'),
(0,14,'p43#judy#willis#port_1###########'),
(0,14,'p44#marco#klein#port_2###########'),
(0,14,'p45#angelica#hampton#port_5###########'),
(0,14,'p5#jeff#burton#plane_4###########'),
(0,14,'p6#randal#parks#plane_7###########'),
(0,14,'p7#sonya#owens#plane_7###########'),
(0,14,'p8#bennie#palmer#plane_8###########'),
(0,14,'p9#marlene#warner#plane_8###########'),
(0,15,'p1#330-12-6907#31#delta#n106js##########'),
(0,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(0,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(0,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(0,15,'p13#513-40-4168#24#delta#n110jn##########'),
(0,15,'p14#454-71-7847#13#delta#n110jn##########'),
(0,15,'p15#153-47-8101#30#delta#n110jn##########'),
(0,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(0,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(0,15,'p18#250-86-2784#23############'),
(0,15,'p19#386-39-7881#2############'),
(0,15,'p2#842-88-1257#9#delta#n106js##########'),
(0,15,'p20#522-44-3098#28############'),
(0,15,'p21#621-34-5755#2############'),
(0,15,'p22#177-47-9877#3############'),
(0,15,'p23#528-64-7912#12############'),
(0,15,'p24#803-30-1789#34############'),
(0,15,'p25#986-76-1587#13############'),
(0,15,'p26#584-77-5105#20############'),
(0,15,'p3#750-24-7616#11#american#n330ss##########'),
(0,15,'p4#776-21-8098#24#american#n330ss##########'),
(0,15,'p5#933-93-2165#27#american#n330ss##########'),
(0,15,'p6#707-84-4555#38#united#n517ly##########'),
(0,15,'p7#450-25-5617#13#united#n517ly##########'),
(0,15,'p8#701-38-2179#12#united#n620la##########'),
(0,15,'p9#936-44-6941#13#united#n620la##########'),
(0,16,'p1#jet#############'),
(0,16,'p10#jet#############'),
(0,16,'p11#jet#############'),
(0,16,'p11#prop#############'),
(0,16,'p12#prop#############'),
(0,16,'p13#jet#############'),
(0,16,'p14#jet#############'),
(0,16,'p15#jet#############'),
(0,16,'p15#prop#############'),
(0,16,'p15#testing#############'),
(0,16,'p16#jet#############'),
(0,16,'p17#jet#############'),
(0,16,'p17#prop#############'),
(0,16,'p18#jet#############'),
(0,16,'p19#jet#############'),
(0,16,'p2#jet#############'),
(0,16,'p2#prop#############'),
(0,16,'p20#jet#############'),
(0,16,'p21#jet#############'),
(0,16,'p21#prop#############'),
(0,16,'p22#jet#############'),
(0,16,'p23#jet#############'),
(0,16,'p24#jet#############'),
(0,16,'p24#prop#############'),
(0,16,'p24#testing#############'),
(0,16,'p25#jet#############'),
(0,16,'p26#jet#############'),
(0,16,'p3#jet#############'),
(0,16,'p4#jet#############'),
(0,16,'p4#prop#############'),
(0,16,'p5#jet#############'),
(0,16,'p6#jet#############'),
(0,16,'p6#prop#############'),
(0,16,'p7#jet#############'),
(0,16,'p8#prop#############'),
(0,16,'p9#jet#############'),
(0,16,'p9#prop#############'),
(0,16,'p9#testing#############'),
(0,17,'p21#771#############'),
(0,17,'p22#374#############'),
(0,17,'p23#414#############'),
(0,17,'p24#292#############'),
(0,17,'p25#390#############'),
(0,17,'p26#302#############'),
(0,17,'p27#470#############'),
(0,17,'p28#208#############'),
(0,17,'p29#292#############'),
(0,17,'p30#686#############'),
(0,17,'p31#547#############'),
(0,17,'p32#257#############'),
(0,17,'p33#564#############'),
(0,17,'p34#211#############'),
(0,17,'p35#233#############'),
(0,17,'p36#293#############'),
(0,17,'p37#552#############'),
(0,17,'p38#812#############'),
(0,17,'p39#541#############'),
(0,17,'p40#441#############'),
(0,17,'p41#875#############'),
(0,17,'p42#691#############'),
(0,17,'p43#572#############'),
(0,17,'p44#572#############'),
(0,17,'p45#663#############'),
(0,18,'leg_1#600#atl#iad###########'),
(0,18,'leg_10#800#dfw#ord###########'),
(0,18,'leg_11#600#iad#ord###########'),
(0,18,'leg_12#200#iah#dal###########'),
(0,18,'leg_13#1400#iah#lax###########'),
(0,18,'leg_14#2400#isp#bfi###########'),
(0,18,'leg_15#800#jfk#atl###########'),
(0,18,'leg_16#800#jfk#ord###########'),
(0,18,'leg_17#2400#jfk#sea###########'),
(0,18,'leg_18#1200#lax#dfw###########'),
(0,18,'leg_19#1000#lax#sea###########'),
(0,18,'leg_2#600#atl#iah###########'),
(0,18,'leg_20#600#ord#dca###########'),
(0,18,'leg_21#800#ord#dfw###########'),
(0,18,'leg_22#800#ord#lax###########'),
(0,18,'leg_23#2400#sea#jfk###########'),
(0,18,'leg_24#1800#sea#ord###########'),
(0,18,'leg_25#600#ord#atl###########'),
(0,18,'leg_26#800#lax#ord###########'),
(0,18,'leg_27#1600#atl#lax###########'),
(0,18,'leg_3#800#atl#jfk###########'),
(0,18,'leg_4#600#atl#ord###########'),
(0,18,'leg_5#1000#bfi#lax###########'),
(0,18,'leg_6#200#dal#hou###########'),
(0,18,'leg_7#600#dca#atl###########'),
(0,18,'leg_8#200#dca#jfk###########'),
(0,18,'leg_9#800#dfw#atl###########'),
(0,19,'circle_east_coast##############'),
(0,19,'circle_west_coast##############'),
(0,19,'eastbound_north_milk_run##############'),
(0,19,'eastbound_north_nonstop##############'),
(0,19,'eastbound_south_milk_run##############'),
(0,19,'hub_xchg_southeast##############'),
(0,19,'hub_xchg_southwest##############'),
(0,19,'local_texas##############'),
(0,19,'northbound_east_coast##############'),
(0,19,'northbound_west_coast##############'),
(0,19,'southbound_midwest##############'),
(0,19,'westbound_north_milk_run##############'),
(0,19,'westbound_north_nonstop##############'),
(0,19,'westbound_south_nonstop##############'),
(0,20,'eastbound_south_milk_run#leg_1#3############'),
(0,20,'circle_west_coast#leg_10#2############'),
(0,20,'local_texas#leg_12#1############'),
(0,20,'westbound_north_milk_run#leg_16#1############'),
(0,20,'westbound_north_nonstop#leg_17#1############'),
(0,20,'circle_west_coast#leg_18#1############'),
(0,20,'eastbound_south_milk_run#leg_18#1############'),
(0,20,'northbound_west_coast#leg_19#1############'),
(0,20,'westbound_north_milk_run#leg_19#3############'),
(0,20,'circle_east_coast#leg_20#2############'),
(0,20,'eastbound_north_milk_run#leg_20#2############'),
(0,20,'southbound_midwest#leg_21#1############'),
(0,20,'circle_west_coast#leg_22#3############'),
(0,20,'hub_xchg_southwest#leg_22#1############'),
(0,20,'westbound_north_milk_run#leg_22#2############'),
(0,20,'eastbound_north_nonstop#leg_23#1############'),
(0,20,'eastbound_north_milk_run#leg_24#1############'),
(0,20,'hub_xchg_southeast#leg_25#1############'),
(0,20,'hub_xchg_southwest#leg_26#2############'),
(0,20,'westbound_south_nonstop#leg_27#1############'),
(0,20,'northbound_east_coast#leg_3#1############'),
(0,20,'circle_east_coast#leg_4#1############'),
(0,20,'hub_xchg_southeast#leg_4#2############'),
(0,20,'local_texas#leg_6#2############'),
(0,20,'circle_east_coast#leg_7#3############'),
(0,20,'eastbound_north_milk_run#leg_8#3############'),
(0,20,'eastbound_south_milk_run#leg_9#2############'),
(0,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(0,21,'dl_1174#northbound_east_coast#delta#n106js#0#on_ground#08:00:00########'),
(0,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(0,21,'dl_3410#circle_east_coast#############'),
(0,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(0,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(0,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(0,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(0,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(0,21,'un_717#circle_west_coast#############'),
(0,22,'tkt_am_17#375#am_1523#p40#ord##########'),
(0,22,'tkt_am_18#275#am_1523#p41#lax##########'),
(0,22,'tkt_am_3#250#am_1523#p26#lax##########'),
(0,22,'tkt_dl_1#450#dl_1174#p24#jfk##########'),
(0,22,'tkt_dl_11#500#dl_1243#p34#lax##########'),
(0,22,'tkt_dl_12#250#dl_1243#p35#lax##########'),
(0,22,'tkt_dl_2#225#dl_1174#p25#jfk##########'),
(0,22,'tkt_sp_13#225#sp_1880#p36#atl##########'),
(0,22,'tkt_sp_14#150#sp_1880#p37#dca##########'),
(0,22,'tkt_sp_16#475#sp_1880#p39#atl##########'),
(0,22,'tkt_sw_10#425#sw_610#p33#hou##########'),
(0,22,'tkt_sw_7#400#sw_1776#p30#ord##########'),
(0,22,'tkt_sw_8#175#sw_1776#p31#ord##########'),
(0,22,'tkt_sw_9#125#sw_610#p32#hou##########'),
(0,22,'tkt_un_15#150#un_523#p38#ord##########'),
(0,22,'tkt_un_4#175#un_1899#p27#dca##########'),
(0,22,'tkt_un_5#225#un_523#p28#atl##########'),
(0,22,'tkt_un_6#100#un_523#p29#ord##########'),
(0,23,'tkt_am_17#2b#############'),
(0,23,'tkt_am_18#2a#############'),
(0,23,'tkt_am_3#3b#############'),
(0,23,'tkt_dl_1#1c#############'),
(0,23,'tkt_dl_1#2f#############'),
(0,23,'tkt_dl_11#1b#############'),
(0,23,'tkt_dl_11#1e#############'),
(0,23,'tkt_dl_11#2f#############'),
(0,23,'tkt_dl_12#2a#############'),
(0,23,'tkt_dl_2#2d#############'),
(0,23,'tkt_sp_13#1a#############'),
(0,23,'tkt_sw_10#1d#############'),
(0,23,'tkt_sw_7#3c#############'),
(0,23,'tkt_sw_8#3e#############'),
(0,23,'tkt_sw_9#1c#############'),
(0,23,'tkt_un_4#2b#############'),
(0,23,'tkt_un_5#1a#############'),
(0,23,'tkt_un_6#3b#############'),
(20,12,'american#n330ss#4#200#plane_4#jet###2######'),
(20,12,'american#n380sd#5#400##jet###2######'),
(20,12,'delta#n106js#4#200#plane_1#jet###2######'),
(20,12,'delta#n110jn#5#600#plane_2#jet###4######'),
(20,12,'delta#n120jn#10#350##jet###4######'),
(20,12,'delta#n127js#4#800###########'),
(20,12,'delta#n156sq#8#100###########'),
(20,12,'jetblue#n161fk#4#200##jet###2######'),
(20,12,'jetblue#n337as#5#400##jet###2######'),
(20,12,'southwest#n118fm#4#100#plane_11#prop#1#1#######'),
(20,12,'southwest#n401fj#4#200#plane_9#jet###2######'),
(20,12,'southwest#n653fk#6#400##jet###2######'),
(20,12,'southwest#n815pw#3#200##prop#0#2#######'),
(20,12,'spirit#n256ap#4#400#plane_15#jet###2######'),
(20,12,'united#n451fi#5#400##jet###4######'),
(20,12,'united#n517ly#4#400#plane_7#jet###2######'),
(20,12,'united#n616lt#7#400##jet###4######'),
(20,12,'united#n620la#4#200#plane_8#prop#0#2#######'),
(40,13,'abq#albuquerqueinternationalsunport#albuquerque#nm###########'),
(40,13,'anc#tedstevensanchorageinternationalairport#anchorage#ak###########'),
(40,13,'atl#hartsfield-jacksonatlantainternationalairport#atlanta#ga#port_1##########'),
(40,13,'bdl#bradleyinternationalairport#hartford#ct###########'),
(40,13,'bfi#kingcountyinternationalairport#seattle#wa#port_10##########'),
(40,13,'bhm#birmingham-shuttlesworthinternationalairport#birmingham#al###########'),
(40,13,'bna#nashvilleinternationalairport#nashville#tn###########'),
(40,13,'boi#boiseairport#boise#id###########'),
(40,13,'bos#generaledwardlawrenceloganinternationalairport#boston#ma###########'),
(40,13,'btv#burlingtoninternationalairport#burlington#vt###########'),
(40,13,'bwi#baltimore_washingtoninternationalairport#baltimore#md###########'),
(40,13,'bzn#bozemanyellowstoneinternationalairport#bozeman#mt###########'),
(40,13,'chs#charlestoninternationalairport#charleston#sc###########'),
(40,13,'cle#clevelandhopkinsinternationalairport#cleveland#oh###########'),
(40,13,'clt#charlottedouglasinternationalairport#charlotte#nc###########'),
(40,13,'crw#yeagerairport#charleston#wv###########'),
(40,13,'dal#dallaslovefield#dallas#tx#port_7##########'),
(40,13,'dca#ronaldreaganwashingtonnationalairport#washington#dc#port_9##########'),
(40,13,'den#denverinternationalairport#denver#co#port_3##########'),
(40,13,'dfw#dallas-fortworthinternationalairport#dallas#tx#port_2##########'),
(40,13,'dsm#desmoinesinternationalairport#desmoines#ia###########'),
(40,13,'dtw#detroitmetrowaynecountyairport#detroit#mi###########'),
(40,13,'ewr#newarklibertyinternationalairport#newark#nj###########'),
(40,13,'far#hectorinternationalairport#fargo#nd###########'),
(40,13,'fsd#joefossfield#siouxfalls#sd###########'),
(40,13,'gsn#saipaninternationalairport#obyansaipanisland#mp###########'),
(40,13,'gum#antoniob_wonpatinternationalairport#aganatamuning#gu###########'),
(40,13,'hnl#danielk.inouyeinternationalairport#honoluluoahu#hi###########'),
(40,13,'hou#williamp_hobbyairport#houston#tx#port_18##########'),
(40,13,'iad#washingtondullesinternationalairport#washington#dc#port_11##########'),
(40,13,'iah#georgebushintercontinentalhoustonairport#houston#tx#port_13##########'),
(40,13,'ict#wichitadwightd_eisenhowernationalairport#wichita#ks###########'),
(40,13,'ilg#wilmingtonairport#wilmington#de###########'),
(40,13,'ind#indianapolisinternationalairport#indianapolis#in###########'),
(40,13,'isp#longislandmacarthurairport#newyorkislip#ny#port_14##########'),
(40,13,'jac#jacksonholeairport#jackson#wy###########'),
(40,13,'jan#jackson_medgarwileyeversinternationalairport#jackson#ms###########'),
(40,13,'jfk#johnf_kennedyinternationalairport#newyork#ny#port_15##########'),
(40,13,'las#harryreidinternationalairport#lasvegas#nv###########'),
(40,13,'lax#losangelesinternationalairport#losangeles#ca#port_5##########'),
(40,13,'lga#laguardiaairport#newyork#ny###########'),
(40,13,'lit#billandhillaryclintonnationalairport#littlerock#ar###########'),
(40,13,'mco#orlandointernationalairport#orlando#fl###########'),
(40,13,'mdw#chicagomidwayinternationalairport#chicago#il###########'),
(40,13,'mht#manchester_bostonregionalairport#manchester#nh###########'),
(40,13,'mke#milwaukeemitchellinternationalairport#milwaukee#wi###########'),
(40,13,'mri#merrillfield#anchorage#ak###########'),
(40,13,'msp#minneapolis_st_paulinternationalwold_chamberlainairport#minneapolissaintpaul#mn###########'),
(40,13,'msy#louisarmstrongneworleansinternationalairport#neworleans#la###########'),
(40,13,'okc#willrogersworldairport#oklahomacity#ok###########'),
(40,13,'oma#eppleyairfield#omaha#ne###########'),
(40,13,'ord#o_hareinternationalairport#chicago#il#port_4##########'),
(40,13,'pdx#portlandinternationalairport#portland#or###########'),
(40,13,'phl#philadelphiainternationalairport#philadelphia#pa###########'),
(40,13,'phx#phoenixskyharborinternationalairport#phoenix#az###########'),
(40,13,'pvd#rhodeislandt_f_greeninternationalairport#providence#ri###########'),
(40,13,'pwm#portlandinternationaljetport#portland#me###########'),
(40,13,'sdf#louisvilleinternationalairport#louisville#ky###########'),
(40,13,'sea#seattle-tacomainternationalairport#seattletacoma#wa#port_17##########'),
(40,13,'sjc#sanjoseminetainternationalairport#sanjose#ca###########'),
(40,13,'sju#luismunozmarininternationalairport#sanjuancarolina#pr###########'),
(40,13,'slc#saltlakecityinternationalairport#saltlakecity#ut###########'),
(40,13,'stl#st_louislambertinternationalairport#saintlouis#mo###########'),
(40,13,'stt#cyrile_kingairport#charlotteamaliesaintthomas#vi###########'),
(60,14,'p1#jeanne#nelson#plane_1###########'),
(60,14,'p10#lawrence#morgan#plane_9###########'),
(60,14,'p11#sandra#cruz#plane_9###########'),
(60,14,'p12#dan#ball#plane_11###########'),
(60,14,'p13#bryant#figueroa#plane_2###########'),
(60,14,'p14#dana#perry#plane_2###########'),
(60,14,'p15#matt#hunt#plane_2###########'),
(60,14,'p16#edna#brown#plane_15###########'),
(60,14,'p17#ruby#burgess#plane_15###########'),
(60,14,'p18#esther#pittman#port_2###########'),
(60,14,'p19#doug#fowler#port_4###########'),
(60,14,'p2#roxanne#byrd#plane_1###########'),
(60,14,'p20#thomas#olson#port_3###########'),
(60,14,'p21#mona#harrison#port_4###########'),
(60,14,'p22#arlene#massey#port_2###########'),
(60,14,'p23#judith#patrick#port_3###########'),
(60,14,'p24#reginald#rhodes#plane_1###########'),
(60,14,'p25#vincent#garcia#plane_1###########'),
(60,14,'p26#cheryl#moore#plane_4###########'),
(60,14,'p27#michael#rivera#plane_7###########'),
(60,14,'p28#luther#matthews#plane_8###########'),
(60,14,'p29#moses#parks#plane_8###########'),
(60,14,'p3#tanya#nguyen#plane_4###########'),
(60,14,'p30#ora#steele#plane_9###########'),
(60,14,'p31#antonio#flores#plane_9###########'),
(60,14,'p32#glenn#ross#plane_11###########'),
(60,14,'p33#irma#thomas#plane_11###########'),
(60,14,'p34#ann#maldonado#plane_2###########'),
(60,14,'p35#jeffrey#cruz#plane_2###########'),
(60,14,'p36#sonya#price#plane_15###########'),
(60,14,'p37#tracy#hale#plane_15###########'),
(60,14,'p38#albert#simmons#port_1###########'),
(60,14,'p39#karen#terry#port_9###########'),
(60,14,'p4#kendra#jacobs#plane_4###########'),
(60,14,'p40#glen#kelley#plane_4###########'),
(60,14,'p41#brooke#little#port_4###########'),
(60,14,'p42#daryl#nguyen#port_3###########'),
(60,14,'p43#judy#willis#port_1###########'),
(60,14,'p44#marco#klein#port_2###########'),
(60,14,'p45#angelica#hampton#port_5###########'),
(60,14,'p5#jeff#burton#plane_4###########'),
(60,14,'p6#randal#parks#plane_7###########'),
(60,14,'p7#sonya#owens#plane_7###########'),
(60,14,'p78#sam#jones#port_2###########'),
(60,14,'p8#bennie#palmer#plane_8###########'),
(60,14,'p9#marlene#warner#plane_8###########'),
(60,15,'p1#330-12-6907#31#delta#n106js##########'),
(60,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(60,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(60,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(60,15,'p13#513-40-4168#24#delta#n110jn##########'),
(60,15,'p14#454-71-7847#13#delta#n110jn##########'),
(60,15,'p15#153-47-8101#30#delta#n110jn##########'),
(60,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(60,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(60,15,'p18#250-86-2784#23############'),
(60,15,'p19#386-39-7881#2############'),
(60,15,'p2#842-88-1257#9#delta#n106js##########'),
(60,15,'p20#522-44-3098#28############'),
(60,15,'p21#621-34-5755#2############'),
(60,15,'p22#177-47-9877#3############'),
(60,15,'p23#528-64-7912#12############'),
(60,15,'p24#803-30-1789#34############'),
(60,15,'p25#986-76-1587#13############'),
(60,15,'p26#584-77-5105#20############'),
(60,15,'p3#750-24-7616#11#american#n330ss##########'),
(60,15,'p4#776-21-8098#24#american#n330ss##########'),
(60,15,'p5#933-93-2165#27#american#n330ss##########'),
(60,15,'p6#707-84-4555#38#united#n517ly##########'),
(60,15,'p7#450-25-5617#13#united#n517ly##########'),
(60,15,'p8#701-38-2179#12#united#n620la##########'),
(60,15,'p9#936-44-6941#13#united#n620la##########'),
(60,17,'p21#771#############'),
(60,17,'p22#374#############'),
(60,17,'p23#414#############'),
(60,17,'p24#292#############'),
(60,17,'p25#390#############'),
(60,17,'p26#302#############'),
(60,17,'p27#470#############'),
(60,17,'p28#208#############'),
(60,17,'p29#292#############'),
(60,17,'p30#686#############'),
(60,17,'p31#547#############'),
(60,17,'p32#257#############'),
(60,17,'p33#564#############'),
(60,17,'p34#211#############'),
(60,17,'p35#233#############'),
(60,17,'p36#293#############'),
(60,17,'p37#552#############'),
(60,17,'p38#812#############'),
(60,17,'p39#541#############'),
(60,17,'p40#441#############'),
(60,17,'p41#875#############'),
(60,17,'p42#691#############'),
(60,17,'p43#572#############'),
(60,17,'p44#572#############'),
(60,17,'p45#663#############'),
(60,17,'p78#20#############'),
(80,16,'p1#jet#############'),
(80,16,'p1#prop#############'),
(80,16,'p10#jet#############'),
(80,16,'p11#jet#############'),
(80,16,'p11#prop#############'),
(80,16,'p12#prop#############'),
(80,16,'p13#jet#############'),
(80,16,'p14#jet#############'),
(80,16,'p15#jet#############'),
(80,16,'p15#prop#############'),
(80,16,'p15#testing#############'),
(80,16,'p16#jet#############'),
(80,16,'p17#jet#############'),
(80,16,'p17#prop#############'),
(80,16,'p18#jet#############'),
(80,16,'p19#jet#############'),
(80,16,'p2#jet#############'),
(80,16,'p2#prop#############'),
(80,16,'p20#jet#############'),
(80,16,'p21#jet#############'),
(80,16,'p21#prop#############'),
(80,16,'p22#jet#############'),
(80,16,'p23#jet#############'),
(80,16,'p24#jet#############'),
(80,16,'p24#prop#############'),
(80,16,'p24#testing#############'),
(80,16,'p25#jet#############'),
(80,16,'p26#jet#############'),
(80,16,'p3#jet#############'),
(80,16,'p4#jet#############'),
(80,16,'p4#prop#############'),
(80,16,'p5#jet#############'),
(80,16,'p6#jet#############'),
(80,16,'p6#prop#############'),
(80,16,'p7#jet#############'),
(80,16,'p8#prop#############'),
(80,16,'p9#jet#############'),
(80,16,'p9#prop#############'),
(80,16,'p9#testing#############'),
(100,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(100,21,'dl_1174#northbound_east_coast#delta#n106js#0#on_ground#08:00:00########'),
(100,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(100,21,'dl_3410#circle_east_coast#############'),
(100,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(100,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(100,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(100,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(100,21,'un_3403#westbound_north_milk_run#american#n380sd#0#on_ground#15:30:00########'),
(100,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(100,21,'un_717#circle_west_coast#############'),
(120,22,'tkt_am_17#375#am_1523#p40#ord##########'),
(120,22,'tkt_am_18#275#am_1523#p41#lax##########'),
(120,22,'tkt_am_3#250#am_1523#p26#lax##########'),
(120,22,'tkt_dl_1#450#dl_1174#p24#jfk##########'),
(120,22,'tkt_dl_11#500#dl_1243#p34#lax##########'),
(120,22,'tkt_dl_12#250#dl_1243#p35#lax##########'),
(120,22,'tkt_dl_2#225#dl_1174#p25#jfk##########'),
(120,22,'tkt_dl_20#450#dl_1174#p23#jfk##########'),
(120,22,'tkt_sp_13#225#sp_1880#p36#atl##########'),
(120,22,'tkt_sp_14#150#sp_1880#p37#dca##########'),
(120,22,'tkt_sp_16#475#sp_1880#p39#atl##########'),
(120,22,'tkt_sw_10#425#sw_610#p33#hou##########'),
(120,22,'tkt_sw_7#400#sw_1776#p30#ord##########'),
(120,22,'tkt_sw_8#175#sw_1776#p31#ord##########'),
(120,22,'tkt_sw_9#125#sw_610#p32#hou##########'),
(120,22,'tkt_un_15#150#un_523#p38#ord##########'),
(120,22,'tkt_un_4#175#un_1899#p27#dca##########'),
(120,22,'tkt_un_5#225#un_523#p28#atl##########'),
(120,22,'tkt_un_6#100#un_523#p29#ord##########'),
(120,23,'tkt_am_17#2b#############'),
(120,23,'tkt_am_18#2a#############'),
(120,23,'tkt_am_3#3b#############'),
(120,23,'tkt_dl_1#1c#############'),
(120,23,'tkt_dl_1#2f#############'),
(120,23,'tkt_dl_11#1b#############'),
(120,23,'tkt_dl_11#1e#############'),
(120,23,'tkt_dl_11#2f#############'),
(120,23,'tkt_dl_12#2a#############'),
(120,23,'tkt_dl_2#2d#############'),
(120,23,'tkt_dl_20#5a#############'),
(120,23,'tkt_sp_13#1a#############'),
(120,23,'tkt_sw_10#1d#############'),
(120,23,'tkt_sw_7#3c#############'),
(120,23,'tkt_sw_8#3e#############'),
(120,23,'tkt_sw_9#1c#############'),
(120,23,'tkt_un_4#2b#############'),
(120,23,'tkt_un_5#1a#############'),
(120,23,'tkt_un_6#3b#############'),
(140,18,'leg_1#600#atl#iad###########'),
(140,18,'leg_10#800#dfw#ord###########'),
(140,18,'leg_11#600#iad#ord###########'),
(140,18,'leg_12#200#iah#dal###########'),
(140,18,'leg_13#1400#iah#lax###########'),
(140,18,'leg_14#2400#isp#bfi###########'),
(140,18,'leg_15#800#jfk#atl###########'),
(140,18,'leg_16#800#jfk#ord###########'),
(140,18,'leg_17#2400#jfk#sea###########'),
(140,18,'leg_18#1200#lax#dfw###########'),
(140,18,'leg_19#1000#lax#sea###########'),
(140,18,'leg_2#600#atl#iah###########'),
(140,18,'leg_20#600#ord#dca###########'),
(140,18,'leg_21#800#ord#dfw###########'),
(140,18,'leg_22#800#ord#lax###########'),
(140,18,'leg_23#2400#sea#jfk###########'),
(140,18,'leg_24#1800#sea#ord###########'),
(140,18,'leg_25#600#ord#atl###########'),
(140,18,'leg_26#800#lax#ord###########'),
(140,18,'leg_27#1600#atl#lax###########'),
(140,18,'leg_28#2800#dca#sea###########'),
(140,18,'leg_3#800#atl#jfk###########'),
(140,18,'leg_4#600#atl#ord###########'),
(140,18,'leg_5#1000#bfi#lax###########'),
(140,18,'leg_6#200#dal#hou###########'),
(140,18,'leg_7#600#dca#atl###########'),
(140,18,'leg_8#200#dca#jfk###########'),
(140,18,'leg_9#800#dfw#atl###########'),
(160,19,'circle_east_coast##############'),
(160,19,'circle_west_coast##############'),
(160,19,'eastbound_north_milk_run##############'),
(160,19,'eastbound_north_nonstop##############'),
(160,19,'eastbound_south_milk_run##############'),
(160,19,'hub_xchg_southeast##############'),
(160,19,'hub_xchg_southwest##############'),
(160,19,'local_texas##############'),
(160,19,'new_eastbound_west_milk_run##############'),
(160,19,'northbound_east_coast##############'),
(160,19,'northbound_west_coast##############'),
(160,19,'southbound_midwest##############'),
(160,19,'westbound_north_milk_run##############'),
(160,19,'westbound_north_nonstop##############'),
(160,19,'westbound_south_nonstop##############'),
(160,20,'eastbound_south_milk_run#leg_1#3############'),
(160,20,'circle_west_coast#leg_10#2############'),
(160,20,'new_eastbound_west_milk_run#leg_10#1############'),
(160,20,'local_texas#leg_12#1############'),
(160,20,'westbound_north_milk_run#leg_16#1############'),
(160,20,'westbound_north_nonstop#leg_17#1############'),
(160,20,'circle_west_coast#leg_18#1############'),
(160,20,'eastbound_south_milk_run#leg_18#1############'),
(160,20,'northbound_west_coast#leg_19#1############'),
(160,20,'westbound_north_milk_run#leg_19#3############'),
(160,20,'circle_east_coast#leg_20#2############'),
(160,20,'eastbound_north_milk_run#leg_20#2############'),
(160,20,'southbound_midwest#leg_21#1############'),
(160,20,'circle_west_coast#leg_22#3############'),
(160,20,'hub_xchg_southwest#leg_22#1############'),
(160,20,'westbound_north_milk_run#leg_22#2############'),
(160,20,'eastbound_north_nonstop#leg_23#1############'),
(160,20,'eastbound_north_milk_run#leg_24#1############'),
(160,20,'hub_xchg_southeast#leg_25#1############'),
(160,20,'hub_xchg_southwest#leg_26#2############'),
(160,20,'westbound_south_nonstop#leg_27#1############'),
(160,20,'northbound_east_coast#leg_3#1############'),
(160,20,'circle_east_coast#leg_4#1############'),
(160,20,'hub_xchg_southeast#leg_4#2############'),
(160,20,'local_texas#leg_6#2############'),
(160,20,'circle_east_coast#leg_7#3############'),
(160,20,'eastbound_north_milk_run#leg_8#3############'),
(160,20,'eastbound_south_milk_run#leg_9#2############'),
(180,20,'eastbound_south_milk_run#leg_1#3############'),
(180,20,'circle_west_coast#leg_10#2############'),
(180,20,'eastbound_south_milk_run#leg_11#4############'),
(180,20,'local_texas#leg_12#1############'),
(180,20,'westbound_north_milk_run#leg_16#1############'),
(180,20,'westbound_north_nonstop#leg_17#1############'),
(180,20,'circle_west_coast#leg_18#1############'),
(180,20,'eastbound_south_milk_run#leg_18#1############'),
(180,20,'northbound_west_coast#leg_19#1############'),
(180,20,'westbound_north_milk_run#leg_19#3############'),
(180,20,'circle_east_coast#leg_20#2############'),
(180,20,'eastbound_north_milk_run#leg_20#2############'),
(180,20,'southbound_midwest#leg_21#1############'),
(180,20,'circle_west_coast#leg_22#3############'),
(180,20,'hub_xchg_southwest#leg_22#1############'),
(180,20,'westbound_north_milk_run#leg_22#2############'),
(180,20,'eastbound_north_nonstop#leg_23#1############'),
(180,20,'eastbound_north_milk_run#leg_24#1############'),
(180,20,'hub_xchg_southeast#leg_25#1############'),
(180,20,'hub_xchg_southwest#leg_26#2############'),
(180,20,'westbound_south_nonstop#leg_27#1############'),
(180,20,'northbound_east_coast#leg_3#1############'),
(180,20,'circle_east_coast#leg_4#1############'),
(180,20,'hub_xchg_southeast#leg_4#2############'),
(180,20,'local_texas#leg_6#2############'),
(180,20,'circle_east_coast#leg_7#3############'),
(180,20,'eastbound_north_milk_run#leg_8#3############'),
(180,20,'eastbound_south_milk_run#leg_9#2############'),
(200,15,'p1#330-12-6907#31#delta#n106js##########'),
(200,15,'p10#769-60-1266#16#southwest#n401fj##########'),
(200,15,'p11#369-22-9505#23#southwest#n401fj##########'),
(200,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(200,15,'p13#513-40-4168#24#delta#n110jn##########'),
(200,15,'p14#454-71-7847#13#delta#n110jn##########'),
(200,15,'p15#153-47-8101#30#delta#n110jn##########'),
(200,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(200,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(200,15,'p18#250-86-2784#23############'),
(200,15,'p19#386-39-7881#2############'),
(200,15,'p2#842-88-1257#9#delta#n106js##########'),
(200,15,'p20#522-44-3098#28############'),
(200,15,'p21#621-34-5755#2############'),
(200,15,'p22#177-47-9877#3############'),
(200,15,'p23#528-64-7912#12############'),
(200,15,'p24#803-30-1789#34############'),
(200,15,'p25#986-76-1587#13############'),
(200,15,'p26#584-77-5105#20############'),
(200,15,'p3#750-24-7616#11#american#n330ss##########'),
(200,15,'p4#776-21-8098#24#american#n330ss##########'),
(200,15,'p5#933-93-2165#27#american#n330ss##########'),
(200,15,'p6#707-84-4555#38#united#n517ly##########'),
(200,15,'p7#450-25-5617#13#united#n517ly##########'),
(200,15,'p8#701-38-2179#12#united#n620la##########'),
(200,15,'p9#936-44-6941#13#united#n620la##########'),
(200,17,'p21#771#############'),
(200,17,'p22#374#############'),
(200,17,'p23#414#############'),
(200,17,'p24#292#############'),
(200,17,'p25#390#############'),
(200,17,'p26#302#############'),
(200,17,'p27#470#############'),
(200,17,'p28#208#############'),
(200,17,'p29#292#############'),
(200,17,'p30#1486#############'),
(200,17,'p31#1347#############'),
(200,17,'p32#257#############'),
(200,17,'p33#564#############'),
(200,17,'p34#211#############'),
(200,17,'p35#233#############'),
(200,17,'p36#293#############'),
(200,17,'p37#552#############'),
(200,17,'p38#812#############'),
(200,17,'p39#541#############'),
(200,17,'p40#441#############'),
(200,17,'p41#875#############'),
(200,17,'p42#691#############'),
(200,17,'p43#572#############'),
(200,17,'p44#572#############'),
(200,17,'p45#663#############'),
(200,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(200,21,'dl_1174#northbound_east_coast#delta#n106js#0#on_ground#08:00:00########'),
(200,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(200,21,'dl_3410#circle_east_coast#############'),
(200,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(200,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#on_ground#15:00:00########'),
(200,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(200,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(200,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(200,21,'un_717#circle_west_coast#############'),
(220,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(220,21,'dl_1174#northbound_east_coast#delta#n106js#1#in_flight#12:00:00########'),
(220,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(220,21,'dl_3410#circle_east_coast#############'),
(220,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(220,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(220,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(220,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(220,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(220,21,'un_717#circle_west_coast#############'),
(240,14,'p1#jeanne#nelson#plane_1###########'),
(240,14,'p10#lawrence#morgan#plane_9###########'),
(240,14,'p11#sandra#cruz#plane_9###########'),
(240,14,'p12#dan#ball#plane_11###########'),
(240,14,'p13#bryant#figueroa#plane_2###########'),
(240,14,'p14#dana#perry#plane_2###########'),
(240,14,'p15#matt#hunt#plane_2###########'),
(240,14,'p16#edna#brown#plane_15###########'),
(240,14,'p17#ruby#burgess#plane_15###########'),
(240,14,'p18#esther#pittman#port_2###########'),
(240,14,'p19#doug#fowler#port_4###########'),
(240,14,'p2#roxanne#byrd#plane_1###########'),
(240,14,'p20#thomas#olson#port_3###########'),
(240,14,'p21#mona#harrison#port_4###########'),
(240,14,'p22#arlene#massey#port_2###########'),
(240,14,'p23#judith#patrick#port_3###########'),
(240,14,'p24#reginald#rhodes#plane_1###########'),
(240,14,'p25#vincent#garcia#plane_1###########'),
(240,14,'p26#cheryl#moore#plane_4###########'),
(240,14,'p27#michael#rivera#plane_7###########'),
(240,14,'p28#luther#matthews#plane_8###########'),
(240,14,'p29#moses#parks#plane_8###########'),
(240,14,'p3#tanya#nguyen#plane_4###########'),
(240,14,'p30#ora#steele#plane_9###########'),
(240,14,'p31#antonio#flores#plane_9###########'),
(240,14,'p32#glenn#ross#plane_11###########'),
(240,14,'p33#irma#thomas#plane_11###########'),
(240,14,'p34#ann#maldonado#plane_2###########'),
(240,14,'p35#jeffrey#cruz#plane_2###########'),
(240,14,'p36#sonya#price#plane_15###########'),
(240,14,'p37#tracy#hale#plane_15###########'),
(240,14,'p38#albert#simmons#port_1###########'),
(240,14,'p39#karen#terry#port_9###########'),
(240,14,'p4#kendra#jacobs#plane_4###########'),
(240,14,'p40#glen#kelley#plane_4###########'),
(240,14,'p41#brooke#little#plane_4###########'),
(240,14,'p42#daryl#nguyen#port_3###########'),
(240,14,'p43#judy#willis#port_1###########'),
(240,14,'p44#marco#klein#port_2###########'),
(240,14,'p45#angelica#hampton#port_5###########'),
(240,14,'p5#jeff#burton#plane_4###########'),
(240,14,'p6#randal#parks#plane_7###########'),
(240,14,'p7#sonya#owens#plane_7###########'),
(240,14,'p8#bennie#palmer#plane_8###########'),
(240,14,'p9#marlene#warner#plane_8###########'),
(260,14,'p1#jeanne#nelson#plane_1###########'),
(260,14,'p10#lawrence#morgan#plane_9###########'),
(260,14,'p11#sandra#cruz#plane_9###########'),
(260,14,'p12#dan#ball#plane_11###########'),
(260,14,'p13#bryant#figueroa#plane_2###########'),
(260,14,'p14#dana#perry#plane_2###########'),
(260,14,'p15#matt#hunt#plane_2###########'),
(260,14,'p16#edna#brown#plane_15###########'),
(260,14,'p17#ruby#burgess#plane_15###########'),
(260,14,'p18#esther#pittman#port_2###########'),
(260,14,'p19#doug#fowler#port_4###########'),
(260,14,'p2#roxanne#byrd#plane_1###########'),
(260,14,'p20#thomas#olson#port_3###########'),
(260,14,'p21#mona#harrison#port_4###########'),
(260,14,'p22#arlene#massey#port_2###########'),
(260,14,'p23#judith#patrick#port_3###########'),
(260,14,'p24#reginald#rhodes#plane_1###########'),
(260,14,'p25#vincent#garcia#plane_1###########'),
(260,14,'p26#cheryl#moore#plane_4###########'),
(260,14,'p27#michael#rivera#plane_7###########'),
(260,14,'p28#luther#matthews#plane_8###########'),
(260,14,'p29#moses#parks#plane_8###########'),
(260,14,'p3#tanya#nguyen#plane_4###########'),
(260,14,'p30#ora#steele#plane_9###########'),
(260,14,'p31#antonio#flores#plane_9###########'),
(260,14,'p32#glenn#ross#plane_11###########'),
(260,14,'p33#irma#thomas#plane_11###########'),
(260,14,'p34#ann#maldonado#plane_2###########'),
(260,14,'p35#jeffrey#cruz#plane_2###########'),
(260,14,'p36#sonya#price#plane_15###########'),
(260,14,'p37#tracy#hale#plane_15###########'),
(260,14,'p38#albert#simmons#port_1###########'),
(260,14,'p39#karen#terry#port_9###########'),
(260,14,'p4#kendra#jacobs#plane_4###########'),
(260,14,'p40#glen#kelley#port_4###########'),
(260,14,'p41#brooke#little#port_4###########'),
(260,14,'p42#daryl#nguyen#port_3###########'),
(260,14,'p43#judy#willis#port_1###########'),
(260,14,'p44#marco#klein#port_2###########'),
(260,14,'p45#angelica#hampton#port_5###########'),
(260,14,'p5#jeff#burton#plane_4###########'),
(260,14,'p6#randal#parks#plane_7###########'),
(260,14,'p7#sonya#owens#plane_7###########'),
(260,14,'p8#bennie#palmer#plane_8###########'),
(260,14,'p9#marlene#warner#plane_8###########'),
(280,14,'p1#jeanne#nelson#plane_1###########'),
(280,14,'p10#lawrence#morgan#plane_9###########'),
(280,14,'p11#sandra#cruz#plane_9###########'),
(280,14,'p12#dan#ball#plane_11###########'),
(280,14,'p13#bryant#figueroa#plane_2###########'),
(280,14,'p14#dana#perry#plane_2###########'),
(280,14,'p15#matt#hunt#plane_2###########'),
(280,14,'p16#edna#brown#plane_15###########'),
(280,14,'p17#ruby#burgess#plane_15###########'),
(280,14,'p18#esther#pittman#port_2###########'),
(280,14,'p19#doug#fowler#plane_4###########'),
(280,14,'p2#roxanne#byrd#plane_1###########'),
(280,14,'p20#thomas#olson#port_3###########'),
(280,14,'p21#mona#harrison#port_4###########'),
(280,14,'p22#arlene#massey#port_2###########'),
(280,14,'p23#judith#patrick#port_3###########'),
(280,14,'p24#reginald#rhodes#plane_1###########'),
(280,14,'p25#vincent#garcia#plane_1###########'),
(280,14,'p26#cheryl#moore#plane_4###########'),
(280,14,'p27#michael#rivera#plane_7###########'),
(280,14,'p28#luther#matthews#plane_8###########'),
(280,14,'p29#moses#parks#plane_8###########'),
(280,14,'p3#tanya#nguyen#plane_4###########'),
(280,14,'p30#ora#steele#plane_9###########'),
(280,14,'p31#antonio#flores#plane_9###########'),
(280,14,'p32#glenn#ross#plane_11###########'),
(280,14,'p33#irma#thomas#plane_11###########'),
(280,14,'p34#ann#maldonado#plane_2###########'),
(280,14,'p35#jeffrey#cruz#plane_2###########'),
(280,14,'p36#sonya#price#plane_15###########'),
(280,14,'p37#tracy#hale#plane_15###########'),
(280,14,'p38#albert#simmons#port_1###########'),
(280,14,'p39#karen#terry#port_9###########'),
(280,14,'p4#kendra#jacobs#plane_4###########'),
(280,14,'p40#glen#kelley#plane_4###########'),
(280,14,'p41#brooke#little#port_4###########'),
(280,14,'p42#daryl#nguyen#port_3###########'),
(280,14,'p43#judy#willis#port_1###########'),
(280,14,'p44#marco#klein#port_2###########'),
(280,14,'p45#angelica#hampton#port_5###########'),
(280,14,'p5#jeff#burton#plane_4###########'),
(280,14,'p6#randal#parks#plane_7###########'),
(280,14,'p7#sonya#owens#plane_7###########'),
(280,14,'p8#bennie#palmer#plane_8###########'),
(280,14,'p9#marlene#warner#plane_8###########'),
(280,15,'p1#330-12-6907#31#delta#n106js##########'),
(280,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(280,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(280,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(280,15,'p13#513-40-4168#24#delta#n110jn##########'),
(280,15,'p14#454-71-7847#13#delta#n110jn##########'),
(280,15,'p15#153-47-8101#30#delta#n110jn##########'),
(280,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(280,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(280,15,'p18#250-86-2784#23############'),
(280,15,'p19#386-39-7881#2#american#n330ss##########'),
(280,15,'p2#842-88-1257#9#delta#n106js##########'),
(280,15,'p20#522-44-3098#28############'),
(280,15,'p21#621-34-5755#2############'),
(280,15,'p22#177-47-9877#3############'),
(280,15,'p23#528-64-7912#12############'),
(280,15,'p24#803-30-1789#34############'),
(280,15,'p25#986-76-1587#13############'),
(280,15,'p26#584-77-5105#20############'),
(280,15,'p3#750-24-7616#11#american#n330ss##########'),
(280,15,'p4#776-21-8098#24#american#n330ss##########'),
(280,15,'p5#933-93-2165#27#american#n330ss##########'),
(280,15,'p6#707-84-4555#38#united#n517ly##########'),
(280,15,'p7#450-25-5617#13#united#n517ly##########'),
(280,15,'p8#701-38-2179#12#united#n620la##########'),
(280,15,'p9#936-44-6941#13#united#n620la##########'),
(300,14,'p1#jeanne#nelson#plane_1###########'),
(300,14,'p10#lawrence#morgan#plane_9###########'),
(300,14,'p11#sandra#cruz#plane_9###########'),
(300,14,'p12#dan#ball#plane_11###########'),
(300,14,'p13#bryant#figueroa#plane_2###########'),
(300,14,'p14#dana#perry#plane_2###########'),
(300,14,'p15#matt#hunt#plane_2###########'),
(300,14,'p16#edna#brown#plane_15###########'),
(300,14,'p17#ruby#burgess#plane_15###########'),
(300,14,'p18#esther#pittman#port_2###########'),
(300,14,'p19#doug#fowler#port_4###########'),
(300,14,'p2#roxanne#byrd#plane_1###########'),
(300,14,'p20#thomas#olson#port_3###########'),
(300,14,'p21#mona#harrison#port_4###########'),
(300,14,'p22#arlene#massey#port_2###########'),
(300,14,'p23#judith#patrick#port_3###########'),
(300,14,'p24#reginald#rhodes#plane_1###########'),
(300,14,'p25#vincent#garcia#plane_1###########'),
(300,14,'p26#cheryl#moore#port_5###########'),
(300,14,'p27#michael#rivera#plane_7###########'),
(300,14,'p28#luther#matthews#plane_8###########'),
(300,14,'p29#moses#parks#plane_8###########'),
(300,14,'p3#tanya#nguyen#port_5###########'),
(300,14,'p30#ora#steele#plane_9###########'),
(300,14,'p31#antonio#flores#plane_9###########'),
(300,14,'p32#glenn#ross#plane_11###########'),
(300,14,'p33#irma#thomas#plane_11###########'),
(300,14,'p34#ann#maldonado#plane_2###########'),
(300,14,'p35#jeffrey#cruz#plane_2###########'),
(300,14,'p36#sonya#price#plane_15###########'),
(300,14,'p37#tracy#hale#plane_15###########'),
(300,14,'p38#albert#simmons#port_1###########'),
(300,14,'p39#karen#terry#port_9###########'),
(300,14,'p4#kendra#jacobs#port_5###########'),
(300,14,'p40#glen#kelley#port_5###########'),
(300,14,'p41#brooke#little#port_5###########'),
(300,14,'p42#daryl#nguyen#port_3###########'),
(300,14,'p43#judy#willis#port_1###########'),
(300,14,'p44#marco#klein#port_2###########'),
(300,14,'p45#angelica#hampton#port_5###########'),
(300,14,'p5#jeff#burton#port_5###########'),
(300,14,'p6#randal#parks#plane_7###########'),
(300,14,'p7#sonya#owens#plane_7###########'),
(300,14,'p8#bennie#palmer#plane_8###########'),
(300,14,'p9#marlene#warner#plane_8###########'),
(300,15,'p1#330-12-6907#31#delta#n106js##########'),
(300,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(300,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(300,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(300,15,'p13#513-40-4168#24#delta#n110jn##########'),
(300,15,'p14#454-71-7847#13#delta#n110jn##########'),
(300,15,'p15#153-47-8101#30#delta#n110jn##########'),
(300,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(300,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(300,15,'p18#250-86-2784#23############'),
(300,15,'p19#386-39-7881#2############'),
(300,15,'p2#842-88-1257#9#delta#n106js##########'),
(300,15,'p20#522-44-3098#28############'),
(300,15,'p21#621-34-5755#2############'),
(300,15,'p22#177-47-9877#3############'),
(300,15,'p23#528-64-7912#12############'),
(300,15,'p24#803-30-1789#34############'),
(300,15,'p25#986-76-1587#13############'),
(300,15,'p26#584-77-5105#20############'),
(300,15,'p3#750-24-7616#11############'),
(300,15,'p4#776-21-8098#24############'),
(300,15,'p5#933-93-2165#27############'),
(300,15,'p6#707-84-4555#38#united#n517ly##########'),
(300,15,'p7#450-25-5617#13#united#n517ly##########'),
(300,15,'p8#701-38-2179#12#united#n620la##########'),
(300,15,'p9#936-44-6941#13#united#n620la##########'),
(320,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(320,21,'dl_1174#northbound_east_coast#delta#n106js#0#on_ground#08:00:00########'),
(320,21,'dl_3410#circle_east_coast#############'),
(320,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(320,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(320,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(320,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(320,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(320,21,'un_717#circle_west_coast#############'),
(340,14,'p1#jeanne#nelson#plane_1###########'),
(340,14,'p10#lawrence#morgan#plane_9###########'),
(340,14,'p11#sandra#cruz#plane_9###########'),
(340,14,'p12#dan#ball#plane_11###########'),
(340,14,'p13#bryant#figueroa#plane_2###########'),
(340,14,'p14#dana#perry#plane_2###########'),
(340,14,'p15#matt#hunt#plane_2###########'),
(340,14,'p16#edna#brown#plane_15###########'),
(340,14,'p17#ruby#burgess#plane_15###########'),
(340,14,'p18#esther#pittman#port_2###########'),
(340,14,'p19#doug#fowler#port_4###########'),
(340,14,'p2#roxanne#byrd#plane_1###########'),
(340,14,'p20#thomas#olson#port_3###########'),
(340,14,'p21#mona#harrison#port_4###########'),
(340,14,'p22#arlene#massey#port_2###########'),
(340,14,'p23#judith#patrick#port_3###########'),
(340,14,'p24#reginald#rhodes#plane_1###########'),
(340,14,'p25#vincent#garcia#plane_1###########'),
(340,14,'p26#cheryl#moore#plane_4###########'),
(340,14,'p27#michael#rivera#plane_7###########'),
(340,14,'p28#luther#matthews#plane_8###########'),
(340,14,'p29#moses#parks#plane_8###########'),
(340,14,'p3#tanya#nguyen#plane_4###########'),
(340,14,'p30#ora#steele#plane_9###########'),
(340,14,'p31#antonio#flores#plane_9###########'),
(340,14,'p32#glenn#ross#plane_11###########'),
(340,14,'p33#irma#thomas#plane_11###########'),
(340,14,'p34#ann#maldonado#plane_2###########'),
(340,14,'p35#jeffrey#cruz#plane_2###########'),
(340,14,'p36#sonya#price#plane_15###########'),
(340,14,'p37#tracy#hale#plane_15###########'),
(340,14,'p38#albert#simmons#port_1###########'),
(340,14,'p39#karen#terry#port_9###########'),
(340,14,'p4#kendra#jacobs#plane_4###########'),
(340,14,'p40#glen#kelley#plane_4###########'),
(340,14,'p41#brooke#little#port_4###########'),
(340,14,'p42#daryl#nguyen#port_3###########'),
(340,14,'p43#judy#willis#port_1###########'),
(340,14,'p44#marco#klein#port_2###########'),
(340,14,'p5#jeff#burton#plane_4###########'),
(340,14,'p6#randal#parks#plane_7###########'),
(340,14,'p7#sonya#owens#plane_7###########'),
(340,14,'p8#bennie#palmer#plane_8###########'),
(340,14,'p9#marlene#warner#plane_8###########'),
(340,17,'p21#771#############'),
(340,17,'p22#374#############'),
(340,17,'p23#414#############'),
(340,17,'p24#292#############'),
(340,17,'p25#390#############'),
(340,17,'p26#302#############'),
(340,17,'p27#470#############'),
(340,17,'p28#208#############'),
(340,17,'p29#292#############'),
(340,17,'p30#686#############'),
(340,17,'p31#547#############'),
(340,17,'p32#257#############'),
(340,17,'p33#564#############'),
(340,17,'p34#211#############'),
(340,17,'p35#233#############'),
(340,17,'p36#293#############'),
(340,17,'p37#552#############'),
(340,17,'p38#812#############'),
(340,17,'p39#541#############'),
(340,17,'p40#441#############'),
(340,17,'p41#875#############'),
(340,17,'p42#691#############'),
(340,17,'p43#572#############'),
(340,17,'p44#572#############'),
(340,22,'tkt_am_17#375#am_1523#p40#ord##########'),
(340,22,'tkt_am_18#275#am_1523#p41#lax##########'),
(340,22,'tkt_am_3#250#am_1523#p26#lax##########'),
(340,22,'tkt_dl_1#450#dl_1174#p24#jfk##########'),
(340,22,'tkt_dl_11#500#dl_1243#p34#lax##########'),
(340,22,'tkt_dl_12#250#dl_1243#p35#lax##########'),
(340,22,'tkt_dl_2#225#dl_1174#p25#jfk##########'),
(340,22,'tkt_sp_13#225#sp_1880#p36#atl##########'),
(340,22,'tkt_sp_14#150#sp_1880#p37#dca##########'),
(340,22,'tkt_sp_16#475#sp_1880#p39#atl##########'),
(340,22,'tkt_sw_10#425#sw_610#p33#hou##########'),
(340,22,'tkt_sw_7#400#sw_1776#p30#ord##########'),
(340,22,'tkt_sw_8#175#sw_1776#p31#ord##########'),
(340,22,'tkt_sw_9#125#sw_610#p32#hou##########'),
(340,22,'tkt_un_15#150#un_523#p38#ord##########'),
(340,22,'tkt_un_4#175#un_1899#p27#dca##########'),
(340,22,'tkt_un_5#225#un_523#p28#atl##########'),
(340,22,'tkt_un_6#100#un_523#p29#ord##########'),
(360,14,'p1#jeanne#nelson#plane_1###########'),
(360,14,'p10#lawrence#morgan#plane_9###########'),
(360,14,'p11#sandra#cruz#plane_9###########'),
(360,14,'p12#dan#ball#plane_11###########'),
(360,14,'p13#bryant#figueroa#plane_2###########'),
(360,14,'p14#dana#perry#plane_2###########'),
(360,14,'p15#matt#hunt#plane_2###########'),
(360,14,'p16#edna#brown#plane_15###########'),
(360,14,'p17#ruby#burgess#plane_15###########'),
(360,14,'p18#esther#pittman#port_2###########'),
(360,14,'p19#doug#fowler#port_4###########'),
(360,14,'p2#roxanne#byrd#plane_1###########'),
(360,14,'p21#mona#harrison#port_4###########'),
(360,14,'p22#arlene#massey#port_2###########'),
(360,14,'p23#judith#patrick#port_3###########'),
(360,14,'p24#reginald#rhodes#plane_1###########'),
(360,14,'p25#vincent#garcia#plane_1###########'),
(360,14,'p26#cheryl#moore#plane_4###########'),
(360,14,'p27#michael#rivera#plane_7###########'),
(360,14,'p28#luther#matthews#plane_8###########'),
(360,14,'p29#moses#parks#plane_8###########'),
(360,14,'p3#tanya#nguyen#plane_4###########'),
(360,14,'p30#ora#steele#plane_9###########'),
(360,14,'p31#antonio#flores#plane_9###########'),
(360,14,'p32#glenn#ross#plane_11###########'),
(360,14,'p33#irma#thomas#plane_11###########'),
(360,14,'p34#ann#maldonado#plane_2###########'),
(360,14,'p35#jeffrey#cruz#plane_2###########'),
(360,14,'p36#sonya#price#plane_15###########'),
(360,14,'p37#tracy#hale#plane_15###########'),
(360,14,'p38#albert#simmons#port_1###########'),
(360,14,'p39#karen#terry#port_9###########'),
(360,14,'p4#kendra#jacobs#plane_4###########'),
(360,14,'p40#glen#kelley#plane_4###########'),
(360,14,'p41#brooke#little#port_4###########'),
(360,14,'p42#daryl#nguyen#port_3###########'),
(360,14,'p43#judy#willis#port_1###########'),
(360,14,'p44#marco#klein#port_2###########'),
(360,14,'p45#angelica#hampton#port_5###########'),
(360,14,'p5#jeff#burton#plane_4###########'),
(360,14,'p6#randal#parks#plane_7###########'),
(360,14,'p7#sonya#owens#plane_7###########'),
(360,14,'p8#bennie#palmer#plane_8###########'),
(360,14,'p9#marlene#warner#plane_8###########'),
(360,15,'p1#330-12-6907#31#delta#n106js##########'),
(360,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(360,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(360,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(360,15,'p13#513-40-4168#24#delta#n110jn##########'),
(360,15,'p14#454-71-7847#13#delta#n110jn##########'),
(360,15,'p15#153-47-8101#30#delta#n110jn##########'),
(360,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(360,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(360,15,'p18#250-86-2784#23############'),
(360,15,'p19#386-39-7881#2############'),
(360,15,'p2#842-88-1257#9#delta#n106js##########'),
(360,15,'p21#621-34-5755#2############'),
(360,15,'p22#177-47-9877#3############'),
(360,15,'p23#528-64-7912#12############'),
(360,15,'p24#803-30-1789#34############'),
(360,15,'p25#986-76-1587#13############'),
(360,15,'p26#584-77-5105#20############'),
(360,15,'p3#750-24-7616#11#american#n330ss##########'),
(360,15,'p4#776-21-8098#24#american#n330ss##########'),
(360,15,'p5#933-93-2165#27#american#n330ss##########'),
(360,15,'p6#707-84-4555#38#united#n517ly##########'),
(360,15,'p7#450-25-5617#13#united#n517ly##########'),
(360,15,'p8#701-38-2179#12#united#n620la##########'),
(360,15,'p9#936-44-6941#13#united#n620la##########'),
(360,16,'p1#jet#############'),
(360,16,'p10#jet#############'),
(360,16,'p11#jet#############'),
(360,16,'p11#prop#############'),
(360,16,'p12#prop#############'),
(360,16,'p13#jet#############'),
(360,16,'p14#jet#############'),
(360,16,'p15#jet#############'),
(360,16,'p15#prop#############'),
(360,16,'p15#testing#############'),
(360,16,'p16#jet#############'),
(360,16,'p17#jet#############'),
(360,16,'p17#prop#############'),
(360,16,'p18#jet#############'),
(360,16,'p19#jet#############'),
(360,16,'p2#jet#############'),
(360,16,'p2#prop#############'),
(360,16,'p21#jet#############'),
(360,16,'p21#prop#############'),
(360,16,'p22#jet#############'),
(360,16,'p23#jet#############'),
(360,16,'p24#jet#############'),
(360,16,'p24#prop#############'),
(360,16,'p24#testing#############'),
(360,16,'p25#jet#############'),
(360,16,'p26#jet#############'),
(360,16,'p3#jet#############'),
(360,16,'p4#jet#############'),
(360,16,'p4#prop#############'),
(360,16,'p5#jet#############'),
(360,16,'p6#jet#############'),
(360,16,'p6#prop#############'),
(360,16,'p7#jet#############'),
(360,16,'p8#prop#############'),
(360,16,'p9#jet#############'),
(360,16,'p9#prop#############'),
(360,16,'p9#testing#############'),
(380,30,'dal#hou#1#sw_610#11:30:00#11:30:00#plane_11########'),
(380,30,'lax#ord#1#sw_1776#14:00:00#14:00:00#plane_9########'),
(380,30,'ord#atl#1#un_523#11:00:00#11:00:00#plane_8########'),
(380,30,'ord#dca#1#sp_1880#15:00:00#15:00:00#plane_15########'),
(380,30,'dal#hou#1#sw_610#11:30:00#11:30:00#plane_11########'),
(380,30,'lax#ord#1#sw_1776#14:00:00#14:00:00#plane_9########'),
(380,30,'ord#atl#1#un_523#11:00:00#11:00:00#plane_8########'),
(380,30,'ord#dca#1#sp_1880#15:00:00#15:00:00#plane_15########'),
(400,31,'ord#1#am_1523#14:30:00#14:30:00#plane_4#########'),
(400,31,'atl#1#dl_1174#08:00:00#08:00:00#plane_1#########'),
(400,31,'jfk#1#dl_1243#09:30:00#09:30:00#plane_2#########'),
(400,31,'sea#1#un_1899#09:30:00#09:30:00#plane_7#########'),
(420,32,'dal#hou#1#plane_11#sw_610#11:30:00#11:30:00#1#2#3#p12,p32,p33####'),
(420,32,'lax#ord#1#plane_9#sw_1776#14:00:00#14:00:00#2#2#4#p10,p11,p30,p31####'),
(420,32,'ord#atl#1#plane_8#un_523#11:00:00#11:00:00#2#2#4#p28,p29,p8,p9####'),
(420,32,'ord#dca#1#plane_15#sp_1880#15:00:00#15:00:00#2#2#4#p16,p17,p36,p37####'),
(440,33,'atl#port_1#hartsfield-jacksonatlantainternationalairport#atlanta#ga#0#2#2#p38,p43######'),
(440,33,'dca#port_9#ronaldreaganwashingtonnationalairport#washington#dc#0#1#1#p39######'),
(440,33,'den#port_3#denverinternationalairport#denver#co#2#2#3#p20,p23,p42######'),
(440,33,'dfw#port_2#dallas-fortworthinternationalairport#dallas#tx#2#2#3#p18,p22,p44######'),
(440,33,'lax#port_5#losangelesinternationalairport#losangeles#ca#0#1#1#p45######'),
(440,33,'ord#port_4#o_hareinternationalairport#chicago#il#2#2#3#p19,p21,p41######'),
(460,34,'circle_east_coast#3#leg_4,leg_20,leg_7#1800#2#dl_3410,sp_1880#atl->ord,ord->dca,dca->atl########'),
(460,34,'circle_west_coast#3#leg_18,leg_10,leg_22#2800#2#am_1523,un_717#lax->dfw,dfw->ord,ord->lax########'),
(460,34,'eastbound_north_milk_run#3#leg_24,leg_20,leg_8#2600#1#un_1899#sea->ord,ord->dca,dca->jfk########'),
(460,34,'eastbound_north_nonstop#1#leg_23#2400#0##sea->jfk########'),
(460,34,'eastbound_south_milk_run#3#leg_18,leg_9,leg_1#2600#0##lax->dfw,dfw->atl,atl->iad########'),
(460,34,'hub_xchg_southeast#2#leg_25,leg_4#1200#1#un_523#ord->atl,atl->ord########'),
(460,34,'hub_xchg_southwest#2#leg_22,leg_26#1600#1#sw_1776#ord->lax,lax->ord########'),
(460,34,'local_texas#2#leg_12,leg_6#400#1#sw_610#iah->dal,dal->hou########'),
(460,34,'northbound_east_coast#1#leg_3#800#1#dl_1174#atl->jfk########'),
(460,34,'northbound_west_coast#1#leg_19#1000#0##lax->sea########'),
(460,34,'southbound_midwest#1#leg_21#800#0##ord->dfw########'),
(460,34,'westbound_north_milk_run#3#leg_16,leg_22,leg_19#2600#0##jfk->ord,ord->lax,lax->sea########'),
(460,34,'westbound_north_nonstop#1#leg_17#2400#1#dl_1243#jfk->sea########'),
(460,34,'westbound_south_nonstop#1#leg_27#1600#0##atl->lax########'),
(480,35,'anchorage#ak#2#anc,mri#tedstevensanchorageinternationalairport,merrillfield##########'),
(480,35,'chicago#il#2#mdw,ord#chicagomidwayinternationalairport,o_hareinternationalairport##########'),
(480,35,'dallas#tx#2#dal,dfw#dallaslovefield,dallas-fortworthinternationalairport##########'),
(480,35,'houston#tx#2#hou,iah#williamp_hobbyairport,georgebushintercontinentalhoustonairport##########'),
(480,35,'newyork#ny#2#jfk,lga#johnf_kennedyinternationalairport,laguardiaairport##########'),
(480,35,'washington#dc#2#dca,iad#ronaldreaganwashingtonnationalairport,washingtondullesinternationalairport##########'),
(500,12,'american#n330ss#4#200#plane_4#jet###2######'),
(500,12,'american#n380sd#5#400##jet###2######'),
(500,12,'delta#n106js#4#200#plane_1#jet###2######'),
(500,12,'delta#n110jn#5#600#plane_2#jet###4######'),
(500,12,'delta#n127js#4#800###########'),
(500,12,'delta#n156sq#8#100###########'),
(500,12,'jetblue#n161fk#4#200##jet###2######'),
(500,12,'jetblue#n337as#5#400##jet###2######'),
(500,12,'southwest#n118fm#4#100#plane_11#prop#1#1#######'),
(500,12,'southwest#n401fj#4#200#plane_9#jet###2######'),
(500,12,'southwest#n653fk#6#400##jet###2######'),
(500,12,'southwest#n815pw#3#200##prop#0#2#######'),
(500,12,'spirit#n256ap#4#400#plane_15#jet###2######'),
(500,12,'united#n451fi#5#400##jet###4######'),
(500,12,'united#n517ly#4#400#plane_7#jet###2######'),
(500,12,'united#n616lt#7#400##jet###4######'),
(500,12,'united#n620la#4#200#plane_8#prop#0#2#######'),
(500,13,'abq#albuquerqueinternationalsunport#albuquerque#nm###########'),
(500,13,'anc#tedstevensanchorageinternationalairport#anchorage#ak###########'),
(500,13,'atl#hartsfield-jacksonatlantainternationalairport#atlanta#ga#port_1##########'),
(500,13,'bdl#bradleyinternationalairport#hartford#ct###########'),
(500,13,'bfi#kingcountyinternationalairport#seattle#wa#port_10##########'),
(500,13,'bhm#birmingham-shuttlesworthinternationalairport#birmingham#al###########'),
(500,13,'bna#nashvilleinternationalairport#nashville#tn###########'),
(500,13,'boi#boiseairport#boise#id###########'),
(500,13,'bos#generaledwardlawrenceloganinternationalairport#boston#ma###########'),
(500,13,'btv#burlingtoninternationalairport#burlington#vt###########'),
(500,13,'bwi#baltimore_washingtoninternationalairport#baltimore#md###########'),
(500,13,'bzn#bozemanyellowstoneinternationalairport#bozeman#mt###########'),
(500,13,'chs#charlestoninternationalairport#charleston#sc###########'),
(500,13,'cle#clevelandhopkinsinternationalairport#cleveland#oh###########'),
(500,13,'clt#charlottedouglasinternationalairport#charlotte#nc###########'),
(500,13,'crw#yeagerairport#charleston#wv###########'),
(500,13,'dal#dallaslovefield#dallas#tx#port_7##########'),
(500,13,'dca#ronaldreaganwashingtonnationalairport#washington#dc#port_9##########'),
(500,13,'den#denverinternationalairport#denver#co#port_3##########'),
(500,13,'dfw#dallas-fortworthinternationalairport#dallas#tx#port_2##########'),
(500,13,'dsm#desmoinesinternationalairport#desmoines#ia###########'),
(500,13,'dtw#detroitmetrowaynecountyairport#detroit#mi###########'),
(500,13,'ewr#newarklibertyinternationalairport#newark#nj###########'),
(500,13,'far#hectorinternationalairport#fargo#nd###########'),
(500,13,'fsd#joefossfield#siouxfalls#sd###########'),
(500,13,'gsn#saipaninternationalairport#obyansaipanisland#mp###########'),
(500,13,'gum#antoniob_wonpatinternationalairport#aganatamuning#gu###########'),
(500,13,'hnl#danielk.inouyeinternationalairport#honoluluoahu#hi###########'),
(500,13,'hou#williamp_hobbyairport#houston#tx#port_18##########'),
(500,13,'iad#washingtondullesinternationalairport#washington#dc#port_11##########'),
(500,13,'iah#georgebushintercontinentalhoustonairport#houston#tx#port_13##########'),
(500,13,'ict#wichitadwightd_eisenhowernationalairport#wichita#ks###########'),
(500,13,'ilg#wilmingtonairport#wilmington#de###########'),
(500,13,'ind#indianapolisinternationalairport#indianapolis#in###########'),
(500,13,'isp#longislandmacarthurairport#newyorkislip#ny#port_14##########'),
(500,13,'jac#jacksonholeairport#jackson#wy###########'),
(500,13,'jan#jackson_medgarwileyeversinternationalairport#jackson#ms###########'),
(500,13,'jfk#johnf_kennedyinternationalairport#newyork#ny#port_15##########'),
(500,13,'las#harryreidinternationalairport#lasvegas#nv###########'),
(500,13,'lax#losangelesinternationalairport#losangeles#ca#port_5##########'),
(500,13,'lga#laguardiaairport#newyork#ny###########'),
(500,13,'lit#billandhillaryclintonnationalairport#littlerock#ar###########'),
(500,13,'mco#orlandointernationalairport#orlando#fl###########'),
(500,13,'mdw#chicagomidwayinternationalairport#chicago#il###########'),
(500,13,'mht#manchester_bostonregionalairport#manchester#nh###########'),
(500,13,'mke#milwaukeemitchellinternationalairport#milwaukee#wi###########'),
(500,13,'mri#merrillfield#anchorage#ak###########'),
(500,13,'msp#minneapolis_st_paulinternationalwold_chamberlainairport#minneapolissaintpaul#mn###########'),
(500,13,'msy#louisarmstrongneworleansinternationalairport#neworleans#la###########'),
(500,13,'okc#willrogersworldairport#oklahomacity#ok###########'),
(500,13,'oma#eppleyairfield#omaha#ne###########'),
(500,13,'ord#o_hareinternationalairport#chicago#il#port_4##########'),
(500,13,'pdx#portlandinternationalairport#portland#or###########'),
(500,13,'phl#philadelphiainternationalairport#philadelphia#pa###########'),
(500,13,'phx#phoenixskyharborinternationalairport#phoenix#az###########'),
(500,13,'pvd#rhodeislandt_f_greeninternationalairport#providence#ri###########'),
(500,13,'pwm#portlandinternationaljetport#portland#me###########'),
(500,13,'sdf#louisvilleinternationalairport#louisville#ky###########'),
(500,13,'sea#seattle-tacomainternationalairport#seattletacoma#wa#port_17##########'),
(500,13,'sju#luismunozmarininternationalairport#sanjuancarolina#pr###########'),
(500,13,'slc#saltlakecityinternationalairport#saltlakecity#ut###########'),
(500,13,'stl#st_louislambertinternationalairport#saintlouis#mo###########'),
(500,13,'stt#cyrile_kingairport#charlotteamaliesaintthomas#vi###########'),
(500,14,'p1#jeanne#nelson#plane_1###########'),
(500,14,'p10#lawrence#morgan#plane_9###########'),
(500,14,'p11#sandra#cruz#plane_9###########'),
(500,14,'p12#dan#ball#plane_11###########'),
(500,14,'p13#bryant#figueroa#plane_2###########'),
(500,14,'p14#dana#perry#plane_2###########'),
(500,14,'p15#matt#hunt#plane_2###########'),
(500,14,'p16#edna#brown#plane_15###########'),
(500,14,'p17#ruby#burgess#plane_15###########'),
(500,14,'p18#esther#pittman#port_2###########'),
(500,14,'p19#doug#fowler#port_4###########'),
(500,14,'p2#roxanne#byrd#plane_1###########'),
(500,14,'p20#thomas#olson#port_3###########'),
(500,14,'p21#mona#harrison#port_4###########'),
(500,14,'p22#arlene#massey#port_2###########'),
(500,14,'p23#judith#patrick#port_3###########'),
(500,14,'p24#reginald#rhodes#plane_1###########'),
(500,14,'p25#vincent#garcia#plane_1###########'),
(500,14,'p26#cheryl#moore#plane_4###########'),
(500,14,'p27#michael#rivera#plane_7###########'),
(500,14,'p28#luther#matthews#plane_8###########'),
(500,14,'p29#moses#parks#plane_8###########'),
(500,14,'p3#tanya#nguyen#plane_4###########'),
(500,14,'p30#ora#steele#plane_9###########'),
(500,14,'p31#antonio#flores#plane_9###########'),
(500,14,'p32#glenn#ross#plane_11###########'),
(500,14,'p33#irma#thomas#plane_11###########'),
(500,14,'p34#ann#maldonado#plane_2###########'),
(500,14,'p35#jeffrey#cruz#plane_2###########'),
(500,14,'p36#sonya#price#plane_15###########'),
(500,14,'p37#tracy#hale#plane_15###########'),
(500,14,'p38#albert#simmons#port_1###########'),
(500,14,'p39#karen#terry#port_9###########'),
(500,14,'p4#kendra#jacobs#plane_4###########'),
(500,14,'p40#glen#kelley#plane_4###########'),
(500,14,'p41#brooke#little#port_4###########'),
(500,14,'p42#daryl#nguyen#port_3###########'),
(500,14,'p43#judy#willis#port_1###########'),
(500,14,'p44#marco#klein#port_2###########'),
(500,14,'p45#angelica#hampton#port_5###########'),
(500,14,'p5#jeff#burton#plane_4###########'),
(500,14,'p6#randal#parks#plane_7###########'),
(500,14,'p7#sonya#owens#plane_7###########'),
(500,14,'p8#bennie#palmer#plane_8###########'),
(500,14,'p9#marlene#warner#plane_8###########'),
(500,15,'p1#330-12-6907#31#delta#n106js##########'),
(500,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(500,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(500,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(500,15,'p13#513-40-4168#24#delta#n110jn##########'),
(500,15,'p14#454-71-7847#13#delta#n110jn##########'),
(500,15,'p15#153-47-8101#30#delta#n110jn##########'),
(500,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(500,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(500,15,'p18#250-86-2784#23############'),
(500,15,'p19#386-39-7881#2############'),
(500,15,'p2#842-88-1257#9#delta#n106js##########'),
(500,15,'p20#522-44-3098#28############'),
(500,15,'p21#621-34-5755#2############'),
(500,15,'p22#177-47-9877#3############'),
(500,15,'p23#528-64-7912#12############'),
(500,15,'p24#803-30-1789#34############'),
(500,15,'p25#986-76-1587#13############'),
(500,15,'p26#584-77-5105#20############'),
(500,15,'p3#750-24-7616#11#american#n330ss##########'),
(500,15,'p4#776-21-8098#24#american#n330ss##########'),
(500,15,'p5#933-93-2165#27#american#n330ss##########'),
(500,15,'p6#707-84-4555#38#united#n517ly##########'),
(500,15,'p7#450-25-5617#13#united#n517ly##########'),
(500,15,'p8#701-38-2179#12#united#n620la##########'),
(500,15,'p9#936-44-6941#13#united#n620la##########'),
(500,16,'p1#jet#############'),
(500,16,'p10#jet#############'),
(500,16,'p11#jet#############'),
(500,16,'p11#prop#############'),
(500,16,'p12#prop#############'),
(500,16,'p13#jet#############'),
(500,16,'p14#jet#############'),
(500,16,'p15#jet#############'),
(500,16,'p15#prop#############'),
(500,16,'p15#testing#############'),
(500,16,'p16#jet#############'),
(500,16,'p17#jet#############'),
(500,16,'p17#prop#############'),
(500,16,'p18#jet#############'),
(500,16,'p19#jet#############'),
(500,16,'p2#jet#############'),
(500,16,'p2#prop#############'),
(500,16,'p20#jet#############'),
(500,16,'p21#jet#############'),
(500,16,'p21#prop#############'),
(500,16,'p22#jet#############'),
(500,16,'p23#jet#############'),
(500,16,'p24#jet#############'),
(500,16,'p24#prop#############'),
(500,16,'p24#testing#############'),
(500,16,'p25#jet#############'),
(500,16,'p26#jet#############'),
(500,16,'p3#jet#############'),
(500,16,'p4#jet#############'),
(500,16,'p4#prop#############'),
(500,16,'p5#jet#############'),
(500,16,'p6#jet#############'),
(500,16,'p6#prop#############'),
(500,16,'p7#jet#############'),
(500,16,'p8#prop#############'),
(500,16,'p9#jet#############'),
(500,16,'p9#prop#############'),
(500,16,'p9#testing#############'),
(500,17,'p21#771#############'),
(500,17,'p22#374#############'),
(500,17,'p23#414#############'),
(500,17,'p24#292#############'),
(500,17,'p25#390#############'),
(500,17,'p26#302#############'),
(500,17,'p27#470#############'),
(500,17,'p28#208#############'),
(500,17,'p29#292#############'),
(500,17,'p30#686#############'),
(500,17,'p31#547#############'),
(500,17,'p32#257#############'),
(500,17,'p33#564#############'),
(500,17,'p34#211#############'),
(500,17,'p35#233#############'),
(500,17,'p36#293#############'),
(500,17,'p37#552#############'),
(500,17,'p38#812#############'),
(500,17,'p39#541#############'),
(500,17,'p40#441#############'),
(500,17,'p41#875#############'),
(500,17,'p42#691#############'),
(500,17,'p43#572#############'),
(500,17,'p44#572#############'),
(500,17,'p45#663#############'),
(500,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(500,21,'dl_1174#northbound_east_coast#delta#n106js#1#in_flight#12:00:00########'),
(500,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(500,21,'dl_3410#circle_east_coast#############'),
(500,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(500,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(500,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(500,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(500,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(500,21,'un_717#circle_west_coast#############'),
(500,22,'tkt_am_17#375#am_1523#p40#ord##########'),
(500,22,'tkt_am_18#275#am_1523#p41#lax##########'),
(500,22,'tkt_am_3#250#am_1523#p26#lax##########'),
(500,22,'tkt_dl_1#450#dl_1174#p24#jfk##########'),
(500,22,'tkt_dl_11#500#dl_1243#p34#lax##########'),
(500,22,'tkt_dl_12#250#dl_1243#p35#lax##########'),
(500,22,'tkt_dl_2#225#dl_1174#p25#jfk##########'),
(500,22,'tkt_sp_13#225#sp_1880#p36#atl##########'),
(500,22,'tkt_sp_14#150#sp_1880#p37#dca##########'),
(500,22,'tkt_sp_16#475#sp_1880#p39#atl##########'),
(500,22,'tkt_sw_10#425#sw_610#p33#hou##########'),
(500,22,'tkt_sw_7#400#sw_1776#p30#ord##########'),
(500,22,'tkt_sw_8#175#sw_1776#p31#ord##########'),
(500,22,'tkt_sw_9#125#sw_610#p32#hou##########'),
(500,22,'tkt_un_15#150#un_523#p38#ord##########'),
(500,22,'tkt_un_4#175#un_1899#p27#dca##########'),
(500,22,'tkt_un_5#225#un_523#p28#atl##########'),
(500,22,'tkt_un_6#100#un_523#p29#ord##########'),
(500,23,'tkt_am_17#2b#############'),
(500,23,'tkt_am_18#2a#############'),
(500,23,'tkt_am_3#3b#############'),
(500,23,'tkt_dl_1#1c#############'),
(500,23,'tkt_dl_1#2f#############'),
(500,23,'tkt_dl_11#1b#############'),
(500,23,'tkt_dl_11#1e#############'),
(500,23,'tkt_dl_11#2f#############'),
(500,23,'tkt_dl_12#2a#############'),
(500,23,'tkt_dl_2#2d#############'),
(500,23,'tkt_sp_13#1a#############'),
(500,23,'tkt_sw_10#1d#############'),
(500,23,'tkt_sw_7#3c#############'),
(500,23,'tkt_sw_8#3e#############'),
(500,23,'tkt_sw_9#1c#############'),
(500,23,'tkt_un_4#2b#############'),
(500,23,'tkt_un_5#1a#############'),
(500,23,'tkt_un_6#3b#############'),
(600,14,'p1#jeanne#nelson#plane_1###########'),
(600,14,'p10#lawrence#morgan#plane_9###########'),
(600,14,'p11#sandra#cruz#plane_9###########'),
(600,14,'p12#dan#ball#plane_11###########'),
(600,14,'p13#bryant#figueroa#plane_2###########'),
(600,14,'p14#dana#perry#plane_2###########'),
(600,14,'p15#matt#hunt#plane_2###########'),
(600,14,'p16#edna#brown#plane_15###########'),
(600,14,'p17#ruby#burgess#plane_15###########'),
(600,14,'p18#esther#pittman#port_2###########'),
(600,14,'p19#doug#fowler#port_4###########'),
(600,14,'p2#roxanne#byrd#plane_1###########'),
(600,14,'p20#thomas#olson#port_3###########'),
(600,14,'p21#mona#harrison#port_4###########'),
(600,14,'p22#arlene#massey#port_2###########'),
(600,14,'p23#judith#patrick#port_3###########'),
(600,14,'p24#reginald#rhodes#plane_1###########'),
(600,14,'p25#vincent#garcia#plane_1###########'),
(600,14,'p26#cheryl#moore#plane_4###########'),
(600,14,'p27#michael#rivera#plane_7###########'),
(600,14,'p28#luther#matthews#plane_8###########'),
(600,14,'p29#moses#parks#plane_8###########'),
(600,14,'p3#tanya#nguyen#plane_4###########'),
(600,14,'p30#ora#steele#plane_9###########'),
(600,14,'p31#antonio#flores#plane_9###########'),
(600,14,'p32#glenn#ross#plane_11###########'),
(600,14,'p33#irma#thomas#plane_11###########'),
(600,14,'p34#ann#maldonado#plane_2###########'),
(600,14,'p35#jeffrey#cruz#plane_2###########'),
(600,14,'p36#sonya#price#plane_15###########'),
(600,14,'p37#tracy#hale#plane_15###########'),
(600,14,'p38#albert#simmons#port_1###########'),
(600,14,'p39#karen#terry#port_9###########'),
(600,14,'p4#kendra#jacobs#plane_4###########'),
(600,14,'p40#glen#kelley#plane_4###########'),
(600,14,'p41#brooke#little#port_4###########'),
(600,14,'p42#daryl#nguyen#port_3###########'),
(600,14,'p43#judy#willis#port_1###########'),
(600,14,'p44#marco#klein#port_2###########'),
(600,14,'p45#angelica#hampton#port_5###########'),
(600,14,'p5#jeff#burton#plane_4###########'),
(600,14,'p6#randal#parks#plane_7###########'),
(600,14,'p7#sonya#owens#plane_7###########'),
(600,14,'p8#bennie#palmer#plane_8###########'),
(600,14,'p9#marlene#warner#plane_8###########'),
(600,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(600,21,'dl_1174#northbound_east_coast#delta#n106js#1#in_flight#12:00:00########'),
(600,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(600,21,'dl_3410#circle_east_coast#############'),
(600,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(600,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(600,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(600,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(600,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(600,21,'un_717#circle_west_coast#############'),
(601,14,'p1#jeanne#nelson#plane_1###########'),
(601,14,'p10#lawrence#morgan#plane_9###########'),
(601,14,'p11#sandra#cruz#plane_9###########'),
(601,14,'p12#dan#ball#plane_11###########'),
(601,14,'p13#bryant#figueroa#plane_2###########'),
(601,14,'p14#dana#perry#plane_2###########'),
(601,14,'p15#matt#hunt#plane_2###########'),
(601,14,'p16#edna#brown#plane_15###########'),
(601,14,'p17#ruby#burgess#plane_15###########'),
(601,14,'p18#esther#pittman#port_2###########'),
(601,14,'p19#doug#fowler#port_4###########'),
(601,14,'p2#roxanne#byrd#plane_1###########'),
(601,14,'p20#thomas#olson#port_3###########'),
(601,14,'p21#mona#harrison#port_4###########'),
(601,14,'p22#arlene#massey#port_2###########'),
(601,14,'p23#judith#patrick#port_3###########'),
(601,14,'p24#reginald#rhodes#port_15###########'),
(601,14,'p25#vincent#garcia#port_15###########'),
(601,14,'p26#cheryl#moore#plane_4###########'),
(601,14,'p27#michael#rivera#plane_7###########'),
(601,14,'p28#luther#matthews#plane_8###########'),
(601,14,'p29#moses#parks#plane_8###########'),
(601,14,'p3#tanya#nguyen#plane_4###########'),
(601,14,'p30#ora#steele#plane_9###########'),
(601,14,'p31#antonio#flores#plane_9###########'),
(601,14,'p32#glenn#ross#plane_11###########'),
(601,14,'p33#irma#thomas#plane_11###########'),
(601,14,'p34#ann#maldonado#plane_2###########'),
(601,14,'p35#jeffrey#cruz#plane_2###########'),
(601,14,'p36#sonya#price#plane_15###########'),
(601,14,'p37#tracy#hale#plane_15###########'),
(601,14,'p38#albert#simmons#port_1###########'),
(601,14,'p39#karen#terry#port_9###########'),
(601,14,'p4#kendra#jacobs#plane_4###########'),
(601,14,'p40#glen#kelley#plane_4###########'),
(601,14,'p41#brooke#little#port_4###########'),
(601,14,'p42#daryl#nguyen#port_3###########'),
(601,14,'p43#judy#willis#port_1###########'),
(601,14,'p44#marco#klein#port_2###########'),
(601,14,'p45#angelica#hampton#port_5###########'),
(601,14,'p5#jeff#burton#plane_4###########'),
(601,14,'p6#randal#parks#plane_7###########'),
(601,14,'p7#sonya#owens#plane_7###########'),
(601,14,'p8#bennie#palmer#plane_8###########'),
(601,14,'p9#marlene#warner#plane_8###########'),
(601,15,'p1#330-12-6907#32#delta#n106js##########'),
(601,15,'p10#769-60-1266#15#southwest#n401fj##########'),
(601,15,'p11#369-22-9505#22#southwest#n401fj##########'),
(601,15,'p12#680-92-5329#24#southwest#n118fm##########'),
(601,15,'p13#513-40-4168#24#delta#n110jn##########'),
(601,15,'p14#454-71-7847#13#delta#n110jn##########'),
(601,15,'p15#153-47-8101#30#delta#n110jn##########'),
(601,15,'p16#598-47-5172#28#spirit#n256ap##########'),
(601,15,'p17#865-71-6800#36#spirit#n256ap##########'),
(601,15,'p18#250-86-2784#23############'),
(601,15,'p19#386-39-7881#2############'),
(601,15,'p2#842-88-1257#10#delta#n106js##########'),
(601,15,'p20#522-44-3098#28############'),
(601,15,'p21#621-34-5755#2############'),
(601,15,'p22#177-47-9877#3############'),
(601,15,'p23#528-64-7912#12############'),
(601,15,'p24#803-30-1789#34############'),
(601,15,'p25#986-76-1587#13############'),
(601,15,'p26#584-77-5105#20############'),
(601,15,'p3#750-24-7616#11#american#n330ss##########'),
(601,15,'p4#776-21-8098#24#american#n330ss##########'),
(601,15,'p5#933-93-2165#27#american#n330ss##########'),
(601,15,'p6#707-84-4555#38#united#n517ly##########'),
(601,15,'p7#450-25-5617#13#united#n517ly##########'),
(601,15,'p8#701-38-2179#12#united#n620la##########'),
(601,15,'p9#936-44-6941#13#united#n620la##########'),
(601,17,'p21#771#############'),
(601,17,'p22#374#############'),
(601,17,'p23#414#############'),
(601,17,'p24#1092#############'),
(601,17,'p25#1190#############'),
(601,17,'p26#302#############'),
(601,17,'p27#470#############'),
(601,17,'p28#208#############'),
(601,17,'p29#292#############'),
(601,17,'p30#686#############'),
(601,17,'p31#547#############'),
(601,17,'p32#257#############'),
(601,17,'p33#564#############'),
(601,17,'p34#211#############'),
(601,17,'p35#233#############'),
(601,17,'p36#293#############'),
(601,17,'p37#552#############'),
(601,17,'p38#812#############'),
(601,17,'p39#541#############'),
(601,17,'p40#441#############'),
(601,17,'p41#875#############'),
(601,17,'p42#691#############'),
(601,17,'p43#572#############'),
(601,17,'p44#572#############'),
(601,17,'p45#663#############'),
(601,21,'am_1523#circle_west_coast#american#n330ss#2#on_ground#14:30:00########'),
(601,21,'dl_1174#northbound_east_coast#delta#n106js#1#on_ground#13:00:00########'),
(601,21,'dl_1243#westbound_north_nonstop#delta#n110jn#0#on_ground#09:30:00########'),
(601,21,'dl_3410#circle_east_coast#############'),
(601,21,'sp_1880#circle_east_coast#spirit#n256ap#2#in_flight#15:00:00########'),
(601,21,'sw_1776#hub_xchg_southwest#southwest#n401fj#2#in_flight#14:00:00########'),
(601,21,'sw_610#local_texas#southwest#n118fm#2#in_flight#11:30:00########'),
(601,21,'un_1899#eastbound_north_milk_run#united#n517ly#0#on_ground#09:30:00########'),
(601,21,'un_523#hub_xchg_southeast#united#n620la#1#in_flight#11:00:00########'),
(601,21,'un_717#circle_west_coast#############');

create or replace view magic44_test_case_frequencies as
select test_case_category, count(distinct step_id) as num_test_cases
from (select step_id, query_id, row_hash, 20 * truncate(step_id / 20, 0) as test_case_category
from magic44_expected_results where step_id < 600) as combine_tests
group by test_case_category
union
select test_case_category, count(distinct step_id) as num_test_cases
from (select step_id, query_id, row_hash, 50 * truncate(step_id / 50, 0) as test_case_category
from magic44_expected_results where step_id >= 600) as combine_tests
group by test_case_category;

-- ----------------------------------------------------------------------------------
-- [7] Compare & evaluate the testing results
-- ----------------------------------------------------------------------------------

-- Delete the unneeded rows from the answers table to simplify later analysis
-- delete from magic44_expected_results where not magic44_query_exists(query_id);

-- Modify the row hash results for the results table to eliminate spaces and convert all characters to lowercase
update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

-- The magic44_count_differences view displays the differences between the number of rows contained in the answers
-- and the test results.  The value null in the answer_total and result_total columns represents zero (0) rows for
-- that query result.

drop view if exists magic44_count_answers;
create view magic44_count_answers as
select step_id, query_id, count(*) as answer_total
from magic44_expected_results group by step_id, query_id;

drop view if exists magic44_count_test_results;
create view magic44_count_test_results as
select step_id, query_id, count(*) as result_total
from magic44_test_results group by step_id, query_id;

drop view if exists magic44_count_differences;
create view magic44_count_differences as
select magic44_count_answers.query_id, magic44_count_answers.step_id, answer_total, result_total
from magic44_count_answers left outer join magic44_count_test_results
	on magic44_count_answers.step_id = magic44_count_test_results.step_id
	and magic44_count_answers.query_id = magic44_count_test_results.query_id
where answer_total <> result_total or result_total is null
union
select magic44_count_test_results.query_id, magic44_count_test_results.step_id, answer_total, result_total
from magic44_count_test_results left outer join magic44_count_answers
	on magic44_count_test_results.step_id = magic44_count_answers.step_id
	and magic44_count_test_results.query_id = magic44_count_answers.query_id
where result_total <> answer_total or answer_total is null
order by query_id, step_id;

-- The magic44_content_differences view displays the differences between the answers and test results
-- in terms of the row attributes and values.  the error_category column contains missing for rows that
-- are not included in the test results but should be, while extra represents the rows that should not
-- be included in the test results.  the row_hash column contains the values of the row in a single
-- string with the attribute values separated by a selected delimiter (i.e., the pound sign/#).

drop view if exists magic44_content_differences;
create view magic44_content_differences as
select query_id, step_id, 'missing' as category, row_hash
from magic44_expected_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_test_results)
union
select query_id, step_id, 'extra' as category, row_hash
from magic44_test_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_expected_results)
order by query_id, step_id, row_hash;

drop view if exists magic44_result_set_size_errors;
create view magic44_result_set_size_errors as
select step_id, query_id, 'result_set_size' as err_category from magic44_count_differences
group by step_id, query_id;

drop view if exists magic44_attribute_value_errors;
create view magic44_attribute_value_errors as
select step_id, query_id, 'attribute_values' as err_category from magic44_content_differences
where row(step_id, query_id) not in (select step_id, query_id from magic44_count_differences)
group by step_id, query_id;

drop view if exists magic44_errors_assembled;
create view magic44_errors_assembled as
select * from magic44_result_set_size_errors
union
select * from magic44_attribute_value_errors;

drop table if exists magic44_row_count_errors;
create table magic44_row_count_errors
select * from magic44_count_differences
order by query_id, step_id;

drop table if exists magic44_column_errors;
create table magic44_column_errors
select * from magic44_content_differences
order by query_id, step_id, row_hash;

drop view if exists magic44_fast_expected_results;
create view magic44_fast_expected_results as
select step_id, query_id, query_label, query_name
from magic44_expected_results, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_row_based_errors;
create view magic44_fast_row_based_errors as
select step_id, query_id, query_label, query_name
from magic44_row_count_errors, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_column_based_errors;
create view magic44_fast_column_based_errors as
select step_id, query_id, query_label, query_name
from magic44_column_errors, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_total_test_cases;
create view magic44_fast_total_test_cases as
select query_label, query_name, count(*) as total_cases
from magic44_fast_expected_results group by query_label, query_name;

drop view if exists magic44_fast_correct_test_cases;
create view magic44_fast_correct_test_cases as
select query_label, query_name, count(*) as correct_cases
from magic44_fast_expected_results where row(step_id, query_id) not in
(select step_id, query_id from magic44_fast_row_based_errors
union select step_id, query_id from magic44_fast_column_based_errors)
group by query_label, query_name;

drop table if exists magic44_autograding_low_level;
create table magic44_autograding_low_level
select magic44_fast_total_test_cases.*, ifnull(correct_cases, 0) as passed_cases
from magic44_fast_total_test_cases left outer join magic44_fast_correct_test_cases
on magic44_fast_total_test_cases.query_label = magic44_fast_correct_test_cases.query_label
and magic44_fast_total_test_cases.query_name = magic44_fast_correct_test_cases.query_name;

drop table if exists magic44_autograding_score_summary;
create table magic44_autograding_score_summary
select query_label, query_name,
	round(scoring_weight * passed_cases / total_cases, 2) as final_score, scoring_weight
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases < total_cases
union
select null, 'REMAINING CORRECT CASES', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases = total_cases
union
select null, 'TOTAL SCORE', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory;

drop table if exists magic44_autograding_high_level;
create table magic44_autograding_high_level
select score_tag, score_category, sum(total_cases) as total_possible,
	sum(passed_cases) as total_passed
from magic44_scores_guide natural join
(select *, mid(query_label, 2, 1) as score_tag from magic44_autograding_low_level) as temp
group by score_tag, score_category; -- order by display_order;

-- Evaluate potential query errors against the original state and the modified state
drop view if exists magic44_result_errs_original;
create view magic44_result_errs_original as
select distinct 'row_count_errors_initial_state' as title, query_id
from magic44_row_count_errors where step_id = 0;

drop view if exists magic44_result_errs_modified;
create view magic44_result_errs_modified as
select distinct 'row_count_errors_test_cases' as title, query_id
from magic44_row_count_errors
where query_id not in (select query_id from magic44_result_errs_original)
union
select * from magic44_result_errs_original;

drop view if exists magic44_attribute_errs_original;
create view magic44_attribute_errs_original as
select distinct 'column_errors_initial_state' as title, query_id
from magic44_column_errors where step_id = 0
and query_id not in (select query_id from magic44_result_errs_modified)
union
select * from magic44_result_errs_modified;

drop view if exists magic44_attribute_errs_modified;
create view magic44_attribute_errs_modified as
select distinct 'column_errors_test_cases' as title, query_id
from magic44_column_errors
where query_id not in (select query_id from magic44_attribute_errs_original)
union
select * from magic44_attribute_errs_original;

drop view if exists magic44_correct_remainders;
create view magic44_correct_remainders as
select distinct 'fully_correct' as title, query_id
from magic44_test_results
where query_id not in (select query_id from magic44_attribute_errs_modified)
union
select * from magic44_attribute_errs_modified;

drop view if exists magic44_grading_rollups;
create view magic44_grading_rollups as
select title, count(*) as number_affected, group_concat(query_id order by query_id asc) as queries_affected
from magic44_correct_remainders
group by title;

drop table if exists magic44_autograding_directory;
create table magic44_autograding_directory (query_status_category varchar(1000));
insert into magic44_autograding_directory values ('fully_correct'),
('column_errors_initial_state'), ('row_count_errors_initial_state'),
('column_errors_test_cases'), ('row_count_errors_test_cases');

drop table if exists magic44_autograding_query_level;
create table magic44_autograding_query_level
select query_status_category, number_affected, queries_affected
from magic44_autograding_directory left outer join magic44_grading_rollups
on query_status_category = title;

-- ----------------------------------------------------------------------------------
-- Validate/verify that the test case results are correct
-- The test case results are compared to the initial database state contents
-- ----------------------------------------------------------------------------------

drop function if exists magic44_check_test_case;
delimiter //
create procedure magic44_check_test_case(in ip_test_case_number integer)
begin
	select * from (select query_id, 'added' as category, row_hash
	from magic44_test_results where step_id = ip_test_case_number and row(query_id, row_hash) not in
		(select query_id, row_hash from magic44_expected_results where step_id = 0)
	union
	select temp.query_id, 'removed' as category, temp.row_hash
	from (select query_id, row_hash from magic44_expected_results where step_id = 0) as temp
	where row(temp.query_id, temp.row_hash) not in
		(select query_id, row_hash from magic44_test_results where step_id = ip_test_case_number)
	and temp.query_id in
		(select query_id from magic44_test_results where step_id = ip_test_case_number)) as unified
	order by query_id, row_hash;
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [8] Generate views to help interpret the test results more easily
-- ----------------------------------------------------------------------------------
drop table if exists magic44_table_name_lookup;
create table magic44_table_name_lookup (
	query_id integer,
	table_or_view_name varchar(2000),
    primary key (query_id)
);

insert into magic44_table_name_lookup values
(10, 'airline'), (11, 'location'), (12, 'airplane'), (13, 'airport'), (14, 'person'),
(15, 'pilot'), (16, 'pilot_licenses'), (17, 'passenger'), (18, 'leg'), (19, 'route'),
(20, 'route_path'), (21, 'flight'), (22, 'ticket'), (23, 'ticket_seats'),
(30, 'flights_in_the_air'), (31, 'flights_on_the_ground'), (32, 'people_in_the_air'),
(33, 'people_on_the_ground'),(34, 'route_summary'),(35, 'alternative_airports');

create or replace view magic44_column_errors_traceable as
select query_label as test_category, query_name as test_name, step_id as test_step_counter,
	table_or_view_name, category as error_category, row_hash
from (magic44_column_errors join magic44_test_case_directory
on (step_id between base_step_id and base_step_id + number_of_steps - 1))
natural join magic44_table_name_lookup
order by test_category, test_step_counter, row_hash;

-- ----------------------------------------------------------------------------------
-- [9] Remove unneeded tables, views, stored procedures and functions
-- ----------------------------------------------------------------------------------
-- Keep only those structures needed to provide student feedback
drop table if exists magic44_autograding_directory;

drop view if exists magic44_grading_rollups;
drop view if exists magic44_correct_remainders;
drop view if exists magic44_attribute_errs_modified;
drop view if exists magic44_attribute_errs_original;
drop view if exists magic44_result_errs_modified;
drop view if exists magic44_result_errs_original;
drop view if exists magic44_errors_assembled;
drop view if exists magic44_attribute_value_errors;
drop view if exists magic44_result_set_size_errors;
drop view if exists magic44_content_differences;
drop view if exists magic44_count_differences;
drop view if exists magic44_count_test_results;
drop view if exists magic44_count_answers;

drop procedure if exists magic44_query_check_and_run;

drop function if exists magic44_query_exists;
drop function if exists magic44_query_capture;
drop function if exists magic44_gen_simple_template;

drop table if exists magic44_column_listing;

-- The magic44_reset_database_state() and magic44_check_test_case procedures can be
-- dropped if desired, but they might be helpful for troubleshooting
-- drop procedure if exists magic44_reset_database_state;
-- drop procedure if exists magic44_check_test_case;

drop view if exists practiceQuery10;
drop view if exists practiceQuery11;
drop view if exists practiceQuery12;
drop view if exists practiceQuery13;
drop view if exists practiceQuery14;
drop view if exists practiceQuery15;
drop view if exists practiceQuery16;
drop view if exists practiceQuery17;
drop view if exists practiceQuery18;
drop view if exists practiceQuery19;
drop view if exists practiceQuery20;
drop view if exists practiceQuery21;

drop view if exists practiceQuery30;
drop view if exists practiceQuery31;
drop view if exists practiceQuery32;
drop view if exists practiceQuery33;
drop view if exists practiceQuery34;
drop view if exists practiceQuery35;

drop view if exists magic44_fast_correct_test_cases;
drop view if exists magic44_fast_total_test_cases;
drop view if exists magic44_fast_column_based_errors;
drop view if exists magic44_fast_row_based_errors;
drop view if exists magic44_fast_expected_results;

drop table if exists magic44_scores_guide;