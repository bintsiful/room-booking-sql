-- Basic Overlap Logic (Capacity-based)

WITH params AS (
    SELECT 
        DATE '2026-01-01' AS arrival_date,
        DATE '2026-01-10' AS departure_date,
        'Berlin' AS place
    FROM dual
)
SELECT
    r.name_room,
    r.number_beds -
    NVL(SUM(
        CASE
            WHEN v.status = 'Confirmed'
            AND rc.arrival_date <= p.departure_date
            AND rc.departure_date >= p.arrival_date
            THEN 1
        END
    ),0) AS beds_remaining
FROM me_room r
LEFT JOIN me_room_calendar rc
    ON r.name_room = rc.room_name
   AND r.place = rc.place
LEFT JOIN me_volunteers v
    ON rc.booked__for__volunteer = v.name
JOIN params p
    ON r.place = p.place
GROUP BY r.name_room, r.number_beds
ORDER BY r.name_room;