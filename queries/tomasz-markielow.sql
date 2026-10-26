-- Report: top clients by clicks
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.client,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    COUNT(DISTINCT c.channel) AS channels
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date <= '2026-10-31'
    AND s.spend_date >= '2026-06-01'
    AND c.client <> 'Internal'
GROUP BY
    c.client
ORDER BY
    clicks DESC
