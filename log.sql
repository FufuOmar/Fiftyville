-- Keep a log of any SQL queries you execute as you solve the mystery.

--Find crime scene description
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND year = 2023 AND street = 'Humphrey Street';

--Get all crime scene reports from that area
SELECT * FROM crime_scene_reports WHERE street = 'Humphrey Street';

--Bakery witnesses
SELECT * FROM interviews WHERE transcript LIKE '%bakery%';

--Between 10:15 and 10:25, the theif left the parking lot
--Before 10:15 the theif withdrew some money (Leggett Street)
--Between 10:15 and 10:25 theif made a phonecall, leaving on the earliest flight on 7/29/23

--Check License plate
SELECT * FROM bakery_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute <= 25;

--POTENTIAL LICENSE PLATES: 5P2BI95 94KL13X 6P58WS2 4328GD8 G412CB7 L93JTIZ 322W7JE 0NTHK55s

--We need Eugene's License plate because theif withdrew money before eugene arrived to bakery that day
SELECT license_plate FROM people WHERE name = 'Eugene';
--EUGENE'S LICENSE PLATE: 47592FJ,

--Time to check logs to see when Eugene arrived to the backery
SELECT month,day,hour, minute FROM bakery_security_logs WHERE license_plate = '47592FJ';
--no logs :( he walked

--Check credit logs on Leggett Street ATM
SELECT * FROM atm_transactions WHERE month = 7 AND day = 28  AND atm_location = 'Leggett Street';

--Check phonecall
| 221 | (130) 555-0289 | (996) 555-8899 | 2023 | 7     | 28  | 51       |
| 224 | (499) 555-9472 | (892) 555-8872 | 2023 | 7     | 28  | 36       |
| 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
| 251 | (499) 555-9472 | (717) 555-1342 | 2023 | 7     | 28  | 50       |
| 254 | (286) 555-6063 | (676) 555-6554 | 2023 | 7     | 28  | 43       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7     | 28  | 49       |
| 261 | (031) 555-6622 | (910) 555-3251 | 2023 | 7     | 28  | 38       |
| 279 | (826) 555-1652 | (066) 555-9701 | 2023 | 7     | 28  | 55       |
| 281 | (338) 555-6650 | (704) 555-2131 | 2023 | 7     | 28  | 54       |
--Theif must be one of these numbers
--POTENTIAL SUSPECTS:
|   id   | name  |  phone_number  | passport_number | license_plate |
+--------+-------+----------------+-----------------+---------------+
| 398010 | Sofia | (130) 555-0289 | 1695452385      | G412CB7       | --BIG suspect, was at bakery - Nevermind
| 560886 | Kelsey| (499) 555-9472 | 8294398571      | 0NTHK55       | --BIG suspect, was at bakery - Nevermind
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | --BIG suspect, was at bakery
| 449774 | Taylor| (286) 555-6063 | 1988161715      | 1106N58       | --not suspect
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | --BIG suspect, was at bakery
| 907148 | Carina| (031) 555-6622 | 9628244268      | Q12B3Z3       | --not suspect
| 395717 | Kenny | (826) 555-1652 | 9878712108      | 30G67EN       | --not suspect
| 438727 |Benista| (338) 555-6650 | 9586786673      | 8X428L0       | --not suspect

--We can use their ID to see bank accounts
SELECT * FROM bank_accounts WHERE person_id = 686048;
Bruce:
| account_number | person_id | creation_year |
+----------------+-----------+---------------+
| 49610011       | 686048    | 2010          |
Diana:
| 26013199       | 514354    | 2012          |
--Our 2 suspects, now lets see atm transactions one more time
--Both pass
--Lets check their partners
SELECT * FROM people WHERE phone_number = '(375) 555-8161';
Bruce Partner:
| 864400 | Robin | (375) 555-8161  | NULL            | 4V16VO0       | --no passport?
Diana Partner:
| 847116 | Philip | (725) 555-3243 | 3391710505      | GW362R6       |

--Lets see airports
SELECT * FROM airports;
--Lets see flights out of fiftyville

| 36 | 8  | 4 | 2023 | 7  | 29  | 8    | 20  | --earliest flight out

--Lets see passengers
SELECT * FROM passengers  WHERE flight_id = 36 AND passport_number = 5773159633;
+-----------+-----------------+------+
| flight_id | passport_number | seat |
+-----------+-----------------+------+
| 36        | 5773159633      | 4A   |

--It seems like bruce was the theif, and Robin is his partner