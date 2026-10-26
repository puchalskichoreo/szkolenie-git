-- Report: clicks and impressions by campaign start date
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.start_date,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
GROUP BY
    c.start_date
ORDER BY
    c.start_date
