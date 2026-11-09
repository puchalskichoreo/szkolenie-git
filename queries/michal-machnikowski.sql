-- Report: clicks and impressions of big campaigns by client
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * only campaigns with a budget of 20 000 or more
--   * one row per client, sorted by client
--   * columns: client, impressions, clicks, conversions, total_spend
--   * skip video campaigns
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.client,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    SUM(s.conversions) AS conversions
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
