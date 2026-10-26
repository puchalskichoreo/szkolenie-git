-- Report: clicks and impressions by client, Q3 2026
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.client,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    COUNT(DISTINCT c.campaign_id) AS campaign_count
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
    AND c.channel <> 'video'
GROUP BY
    c.client
ORDER BY
    c.client
