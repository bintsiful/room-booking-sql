-- Accurate Query with Explicit Beds

SELECT
    r.room_name,
    COUNT(b.bed_id) -
    COUNT(
        CASE
            WHEN bb.arrival_date <= :P_DEPARTURE
            AND bb.departure_date >= :P_ARRIVAL
            THEN 1
        END
    ) beds_remaining
FROM room r
JOIN bed b
    ON b.room_id = r.room_id
LEFT JOIN bed_booking bb
    ON bb.bed_id = b.bed_id
WHERE r.place = :P_PLACE
GROUP BY r.room_name
HAVING COUNT(b.bed_id) -
       COUNT(
           CASE
               WHEN bb.arrival_date <= :P_DEPARTURE
               AND bb.departure_date >= :P_ARRIVAL
               THEN 1
           END
       ) > 0
ORDER BY r.room_name;