-- Report: clicks and impressions by channel
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.channel,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS link_clicks,
    SUM(s.conversions) AS conversions
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
GROUP BY
    c.channel
ORDER BY
    c.channel
