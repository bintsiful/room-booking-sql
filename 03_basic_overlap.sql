-- Basic Overlap Logic

SELECT
    r.name_room,
    r.number_beds -
    NVL(SUM(
        CASE
            WHEN v.status = 'Confirmed'
            AND rc.arrival_date <= :P_ARRIVAL
            AND rc.departure_date >= :P_DEPARTURE
            THEN 1
        END
    ),0) AS beds_remaining
FROM me_room r
LEFT JOIN me_room_calendar rc
    ON r.name_room = rc.room_name
   AND r.place = rc.place
LEFT JOIN me_volunteers v
    ON rc.booked__for__volunteer = v.name
WHERE r.place = :P_PLACE
GROUP BY r.name_room, r.number_beds
ORDER BY r.name_room;