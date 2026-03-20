-- Daily Expansion (Accurate but heavier)

WITH params AS (
    SELECT 
        DATE '2026-01-01' AS arrival_date,
        DATE '2026-01-10' AS departure_date,
        'Berlin' AS place
    FROM dual
),
driver AS (
    SELECT p.arrival_date + LEVEL - 1 AS dt
    FROM params p
    CONNECT BY LEVEL <= p.departure_date - p.arrival_date + 1
),
room_day_occ AS (
    SELECT rc.room_name,
           d.dt,
           COUNT(*) AS beds_occupied
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    JOIN driver d
      ON d.dt BETWEEN rc.arrival_date AND rc.departure_date
    JOIN params p
      ON rc.place = p.place
    WHERE v.status = 'Confirmed'
    GROUP BY rc.room_name, d.dt
),
max_occ AS (
    SELECT room_name,
           MAX(beds_occupied) AS max_occupied
    FROM room_day_occ
    GROUP BY room_name
)
SELECT r.name_room,
       r.number_beds - NVL(m.max_occupied,0) AS beds_remaining
FROM me_room r
LEFT JOIN max_occ m
  ON r.name_room = m.room_name
JOIN params p
  ON r.place = p.place
ORDER BY r.name_room;