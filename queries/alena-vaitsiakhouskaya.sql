-- Report: clicks and impressions by campaign
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * one row per campaign, sorted by campaign name
--   * columns: campaign_name, impressions, clicks, budget, total_spend
--   * skip social campaigns
--   * skip campaigns without budget
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.campaign_name,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
    AND c.client = 'Acme'
WHERE
    c.channel = 'social'
    AND s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
GROUP BY
    c.campaign_name
ORDER BY
    c.campaign_name
