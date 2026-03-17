-- Interval Boundary (Optimized)

WITH booking_events AS (
    SELECT rc.room_name,
           rc.arrival_date event_date,
           1 change
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    WHERE v.status = 'Confirmed'
    AND rc.place = :P_PLACE

    UNION ALL

    SELECT rc.room_name,
           rc.departure_date + 1,
           -1
    FROM me_room_calendar rc
    JOIN me_volunteers v
      ON rc.booked__for__volunteer = v.name
    WHERE v.status = 'Confirmed'
    AND rc.place = :P_PLACE
),
occupancy_calc AS (
    SELECT room_name,
           event_date,
           SUM(change) OVER (
             PARTITION BY room_name
             ORDER BY event_date
           ) running_occupancy
    FROM booking_events
),
max_occupancy AS (
    SELECT room_name,
           MAX(running_occupancy) max_occupied
    FROM occupancy_calc
    GROUP BY room_name
)
SELECT r.name_room,
       r.number_beds - NVL(m.max_occupied,0) beds_remaining
FROM me_room r
LEFT JOIN max_occupancy m
  ON r.name_room = m.room_name
WHERE r.place = :P_PLACE
ORDER BY r.name_room;