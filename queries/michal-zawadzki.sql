-- Report: clicks and impressions by client and channel
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * one row per client and channel, sorted by client
--   * columns: client, channel, impressions, clicks, conversions, total_spend
--   * skip search campaigns (they have their own report)
--   * skip the Internal client
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.client,
    c.channel,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    SUM(s.conversions) AS conversions
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
    AND c.client <> 'Internal'
GROUP BY
    c.client,
    c.channel
ORDER BY
    c.client
