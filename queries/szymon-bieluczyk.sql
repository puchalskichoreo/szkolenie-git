-- Report: clicks and impressions by channel
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * one row per channel, sorted by channel
--   * columns: channel, ctr (click-through rate = clicks / impressions), impressions, link_clicks, conversions, total_spend
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.channel,
    SUM(s.clicks) * 1.0 / SUM(s.clicks) AS ctr,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks
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
