-- Report: clicks and impressions by client, Q3 2026
--
-- What the finished report must do:
--   * period: 1 July to 30 September 2026 (both days included)
--   * one row per client, sorted by client
--   * columns: client, impressions, clicks, campaign_count (number of different campaigns), total_spend
--   * skip video campaigns
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.client,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
GROUP BY
    c.client
ORDER BY
    c.client
