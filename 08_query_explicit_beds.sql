-- Accurate Query with Explicit Beds


WITH params AS (
    SELECT 
        DATE '2026-01-01' AS arrival_date,
        DATE '2026-01-10' AS departure_date,
        'Berlin' AS place
    FROM dual
)
SELECT
    r.room_name,
    COUNT(b.bed_id) -
    COUNT(
        CASE
            WHEN bb.arrival_date <= p.departure_date
            AND bb.departure_date >= p.arrival_date
            THEN 1
        END
    ) AS beds_remaining
FROM room r
JOIN bed b
    ON b.room_id = r.room_id
LEFT JOIN bed_booking bb
    ON bb.bed_id = b.bed_id
JOIN params p
    ON r.place = p.place
GROUP BY r.room_name
ORDER BY r.room_name;