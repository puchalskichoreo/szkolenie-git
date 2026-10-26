-- Report: clicks and impressions by campaign
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.campaign_name,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    SUM(s.conversions) AS conversions
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
    AND c.budget > 0
GROUP BY
    c.campaign_name
ORDER BY
    c.campaign_name
