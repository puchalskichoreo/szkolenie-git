-- Report: clicks and impressions by campaign start date
--
-- What the finished report must do:
--   * period: 1 June to 30 September 2026 (both days included)
--   * only campaigns that started on or after 1 July 2026
--   * one row per campaign start date, sorted by start date
--   * columns: start_date, impressions, clicks, clients (number of different clients), total_spend
--   * skip display campaigns
--   * only active campaigns
--
-- TODO: keep only active campaigns and add total_spend = SUM(spend)
SELECT
    c.start_date,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks) AS clicks,
    SUM(s.spend) AS total_spend,
    COUNT(DISTINCT c.client) AS clients
FROM daily_spend AS s
INNER JOIN campaigns AS c
    ON s.campaign_id = c.campaign_id
WHERE
    c.start_date >= '2025-07-01'
    AND s.spend_date >= '2026-06-01'
    AND s.spend_date <= '2026-09-30'
    AND c.status = 'active'
    AND c.channel <> 'display'
GROUP BY
    c.start_date
ORDER BY
    c.start_date
