SELECT
    c.start_date,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    COUNT(DISTINCT c.client) AS clients,
    SUM(s.spend) AS total_spend
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    c.start_date >= '2026-07-01'
    AND s.spend_date BETWEEN '2026-06-01' AND '2026-09-30'
    AND c.status = 'active'
    AND c.channel <> 'display'
GROUP BY
    c.start_date
ORDER BY
    c.start_date;