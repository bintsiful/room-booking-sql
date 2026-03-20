-- Enable timing
SET TIMING ON;

-- Optional: show execution plan after each query
ALTER SESSION SET statistics_level = ALL;

--------------------------------------------------
-- 1. BASIC OVERLAP
--------------------------------------------------
SELECT /*+ gather_plan_statistics */
    r.name_room,
    r.number_beds -
    NVL(SUM(
        CASE
            WHEN v.status = 'Confirmed'
            AND rc.arrival_date <= DATE '2026-01-10'
            AND rc.departure_date >= DATE '2026-01-01'
            THEN 1
        END
    ),0) AS beds_remaining
FROM me_room r
LEFT JOIN me_room_calendar rc
    ON r.name_room = rc.room_name
   AND r.place = rc.place
LEFT JOIN me_volunteers v
    ON rc.booked__for__volunteer = v.name
WHERE r.place = 'Berlin'
GROUP BY r.name_room, r.number_beds;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL,NULL,'ALLSTATS LAST'));

--------------------------------------------------
-- 2. DAILY OCCUPANCY
--------------------------------------------------
WITH driver AS (
  SELECT DATE '2026-01-01' + LEVEL - 1 dt
  FROM dual
  CONNECT BY LEVEL <= 10
),
occ AS (
  SELECT rc.room_name, COUNT(*) beds_occupied
  FROM me_room_calendar rc
  JOIN me_volunteers v
    ON rc.booked__for__volunteer = v.name
  JOIN driver d
    ON d.dt BETWEEN rc.arrival_date AND rc.departure_date
  WHERE v.status = 'Confirmed'
  GROUP BY rc.room_name, d.dt
)
SELECT /*+ gather_plan_statistics */
       room_name, MAX(beds_occupied)
FROM occ
GROUP BY room_name;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL,NULL,'ALLSTATS LAST'));

--------------------------------------------------
-- 3. INTERVAL BOUNDARY (OPTIMIZED)
--------------------------------------------------
WITH booking_events AS (
    SELECT rc.room_name, rc.arrival_date, 1 change
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    WHERE v.status = 'Confirmed'

    UNION ALL

    SELECT rc.room_name, rc.departure_date + 1, -1
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    WHERE v.status = 'Confirmed'
),
calc AS (
    SELECT room_name,
           SUM(change) OVER (PARTITION BY room_name ORDER BY arrival_date) occ
    FROM booking_events
)
SELECT /*+ gather_plan_statistics */
       room_name, MAX(occ)
FROM calc
GROUP BY room_name;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL,NULL,'ALLSTATS LAST'));