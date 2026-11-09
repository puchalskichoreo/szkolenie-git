-- Report: clicks per client
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * only search and social campaigns
--   * one row per client, sorted by client
--   * columns: client, impressions, clicks, conversions, total_spend
--   * hide clients without clicks
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.client,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
	SUM(s.spend) AS total_spend,
    SUM(s.conversions) AS conversions
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    c.channel = 'search' OR c.channel = 'social'
    AND s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
	AND c.status = 'active'
GROUP BY
    c.client
HAVING
    SUM(s.clicks) > 0
ORDER BY
    c.client
