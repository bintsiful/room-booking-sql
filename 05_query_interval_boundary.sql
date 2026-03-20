-- Interval Boundary (Optimized)

WITH params AS (
    SELECT 
        DATE '2026-01-01' AS arrival_date,
        DATE '2026-01-10' AS departure_date,
        'Berlin' AS place
    FROM dual
),
booking_events AS (
    SELECT rc.room_name,
           rc.arrival_date AS event_date,
           1 AS change
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    JOIN params p
      ON rc.place = p.place
    WHERE v.status = 'Confirmed'

    UNION ALL

    SELECT rc.room_name,
           rc.departure_date + 1,
           -1
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    JOIN params p
      ON rc.place = p.place
    WHERE v.status = 'Confirmed'
),
occupancy_calc AS (
    SELECT room_name,
           event_date,
           SUM(change) OVER (
             PARTITION BY room_name
             ORDER BY event_date
           ) AS running_occupancy
    FROM booking_events
),
max_occupancy AS (
    SELECT room_name,
           MAX(running_occupancy) AS max_occupied
    FROM occupancy_calc
    GROUP BY room_name
)
SELECT r.name_room,
       r.number_beds - NVL(m.max_occupied,0) AS beds_remaining
FROM me_room r
LEFT JOIN max_occupancy m
  ON r.name_room = m.room_name
JOIN params p
  ON r.place = p.place
ORDER BY r.name_room;