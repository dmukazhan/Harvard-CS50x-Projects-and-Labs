-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Pull crime scene report on July 28 on Humphrey Steet
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = 'Humphrey Street';

-- 3 witnesses, each of their interview transcripts mentions the bakery. Littering took place at 16:36.
SELECT transcript FROM interviews
WHERE year = 2021 AND month = 7 AND day = 28
AND transcript LIKE '%bakery%';

-- transcript 1: licence plate
SELECT b.activity, b.license_plate, p.name
FROM bakery_security_logs AS b
JOIN people AS p
ON b.license_plate = p.license_plate
WHERE year = 2021 AND month = 7 AND day = 28
AND hour = 10 AND minute >= 15 AND minute <= 25;

-- trans 2: atm
SELECT p.name, a.transaction_type FROM people AS p
JOIN bank_accounts AS b ON p.id = b.person_id
JOIN atm_transactions AS a ON a.account_number = b.account_number
WHERE a.year = 2021 AND a.month = 7 AND a.day = 28
AND a.atm_location = 'Leggett Street'
AND a.transaction_type = 'withdraw';

-- trans 3: phone call duration
-- adding name columns
--ALTER TABLE phone_calls
--ADD caller_name text;
--ALTER TABLE phone_calls
--ADD receiver_name text;

-- adding names to phone calls table
--UPDATE phone_calls
--SET caller_name = p.name
--FROM people AS p
--WHERE phone_calls.caller = p.phone_number;

--UPDATE phone_calls
--SET receiver_name = p.name
--FROM people AS p
--WHERE phone_calls.receiver = p.phone_number;

-- caller and reciever names tables
SELECT caller, caller_name, receiver, receiver_name FROM phone_calls AS ph
WHERE ph.year = 2021 AND ph.month = 7 AND ph.day = 28 AND ph.duration < 60;

-- flights columns from id to city names
UPDATE flights
SET origin_airport_id = a.city
FROM airports AS a
WHERE flights.origin_airport_id = a.id;

UPDATE flights
SET destination_airport_id = a.city
FROM airports AS a
WHERE flights.destination_airport_id = a.id;

-- first flights next day from Fiftyville
SELECT id, hour, minute, origin_airport_id, destination_airport_id
FROM flights
WHERE year = 2021 AND month = 7 AND day = 29 ORDER BY hour ASC LIMIT 1;

-- destination city from Fiftyville on next day
SELECT f.destination_airport_id, name, phone_number, license_plate
FROM people AS p
JOIN passengers AS ps ON p.passport_number = ps.passport_number
JOIN flights AS f ON f.id = ps.flight_id
WHERE f.id = 36 ORDER BY f.hour ASC;

SELECT name FROM people AS p
JOIN passengers AS ps ON p.passport_number = ps.passport_number
JOIN flights AS f ON f.id = ps.flight_id
WHERE (f.year = 2021 AND f.month = 7 AND f.day = 29 AND f.id = 36)
AND name IN
(SELECT ph.caller_name FROM phone_calls AS ph
WHERE ph.year = 2021 AND ph.month = 7 AND ph.day = 28 AND ph.duration < 60)
AND name IN
(SELECT p.name FROM people AS p
JOIN bank_accounts AS b ON p.id = b.person_id
JOIN atm_transactions AS a ON a.account_number = b.account_number
WHERE a.year = 2021 AND a.month = 7 AND a.day = 28
AND a.atm_location = 'Leggett Street'
AND a.transaction_type = 'withdraw')
AND name IN
(SELECT p.name FROM bakery_security_logs AS b
JOIN people AS p
ON b.license_plate = p.license_plate
WHERE year = 2021 AND month = 7 AND day = 28
AND hour = 10 AND minute >= 15 AND minute <= 25);