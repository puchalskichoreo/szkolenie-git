-- Report: clicks and impressions by channel
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * one row per channel, sorted by channel
--   * columns: channel, conversions (total per channel), impressions, clicks, cost_per_click, total_spend
--   * skip campaigns without budget
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.channel,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    SUM(s.spend) / NULLIF(SUM(s.clicks), 0) AS cost_per_click
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
    AND c.budget > 0
GROUP BY
    c.channel
ORDER BY
    c.channel
