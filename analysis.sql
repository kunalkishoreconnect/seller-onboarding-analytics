-- Synthetic data only. Event order is guaranteed by generator; production pipelines must validate it.
-- Ordered funnel: first occurrence per user, seven-day conversion window.
CREATE VIEW IF NOT EXISTS user_funnel AS
WITH firsts AS (
SELECT user_id, device_type, acquisition_channel,
MIN(CASE WHEN event_name='account_created' THEN event_timestamp END) signup,
MIN(CASE WHEN event_name='business_details_completed' THEN event_timestamp END) details,
MIN(CASE WHEN event_name='first_shipment_created' THEN event_timestamp END) shipment,
MIN(CASE WHEN event_name='first_shipment_picked_up' THEN event_timestamp END) pickup,
MIN(CASE WHEN event_name='second_shipment_created' THEN event_timestamp END) repeat_shipment
FROM events GROUP BY user_id,device_type,acquisition_channel)
SELECT *,
CASE WHEN details>=signup AND julianday(details)-julianday(signup)<=7 THEN 1 ELSE 0 END details_ok,
CASE WHEN shipment>=details AND details>=signup AND julianday(shipment)-julianday(signup)<=7 THEN 1 ELSE 0 END shipment_ok,
CASE WHEN pickup>=shipment AND shipment>=details AND details>=signup AND julianday(pickup)-julianday(signup)<=7 THEN 1 ELSE 0 END pickup_ok
FROM firsts;
-- Funnel
SELECT COUNT(*) signups,SUM(details_ok) details,SUM(shipment_ok) shipments,SUM(pickup_ok) pickups FROM user_funnel;
-- Device segmentation
SELECT device_type,COUNT(*) signups,ROUND(100.0*SUM(details_ok)/COUNT(*),2) details_pct,ROUND(100.0*SUM(pickup_ok)/COUNT(*),2) pickup_pct FROM user_funnel GROUP BY device_type;
-- Channel segmentation
SELECT acquisition_channel,COUNT(*) signups,ROUND(100.0*SUM(pickup_ok)/COUNT(*),2) pickup_pct FROM user_funnel GROUP BY acquisition_channel;
-- Time to shipment, hours (converted users only)
SELECT AVG((julianday(shipment)-julianday(signup))*24) avg_hours FROM user_funnel WHERE shipment_ok=1;
-- Repeat shipment within 14 days of first shipment. Observation ends September 30.
SELECT strftime('%Y-%W',signup) cohort,COUNT(*) eligible_shippers,
SUM(CASE WHEN repeat_shipment>=shipment AND julianday(repeat_shipment)-julianday(shipment)<=14 THEN 1 ELSE 0 END) repeat_shippers
FROM user_funnel WHERE shipment_ok=1 AND shipment<='2026-09-16 00:00:00' GROUP BY cohort;
