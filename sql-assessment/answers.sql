-- Using MySQL version 8.0.31

-- 1. Write query to get sum of impressions by day
SELECT DATE(date) AS day, SUM(impressions) AS total_impressions
FROM marketing_data
GROUP BY day
-- Not asked to order by day, but ordered returned results shows chronological order and is more interpretable.
ORDER BY day;

/* 2. Write query to get top three revenue-generating states in order of best to worst.
Ans: OH is the third best state and it generated 37577 revenue. */
SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;

-- 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
SELECT 
    ci.name AS campaign_name,
    SUM(md.cost) AS total_cost,
    SUM(md.impressions) AS total_impressions,
    SUM(md.clicks) AS total_clicks,
    SUM(wr.revenue) AS total_revenue
FROM marketing_data md
JOIN website_revenue wr ON md.campaign_id = wr.campaign_id
JOIN campaign_info ci ON md.campaign_id = ci.id
GROUP BY ci.name
-- Not asked to order by name, but ordered returned results is more interpretable.
ORDER BY ci.name;

/* 4. Write a query to get the number of conversions of Campaign5 by state.
Ans: NY has the most conversions (7798) for Campaign5. */
SELECT wr.state, SUM(md.conversions) AS total_conversions
FROM marketing_data md
JOIN campaign_info ci ON md.campaign_id = ci.id
JOIN website_revenue wr ON md.campaign_id = ci.id
WHERE ci.name = 'Campaign5'
GROUP BY wr.state
ORDER BY total_conversions DESC;

/* 5. Ans: I think Campaign4 is the most efficient. 
When evaluating efficiency of campaigns, the first thing that comes to mind is efficiency ratio.
Although the profit of Campaign3 has the highest net profit (revenue - cost), it is a high cost campaign. 
Campaign4 achieved the highest revenue-to-cost ratio, so I believe it is the most efficient.
 */
SELECT 
    ci.name AS campaign_name,
    SUM(wr.revenue) / SUM(md.cost) AS efficiency_ratio,
    SUM(wr.revenue) - SUM(md.cost) AS net_profit,
    -- Other possible variables of interest
    SUM(md.impressions) AS total_impressions,
    SUM(md.clicks) AS total_clicks,
    SUM(md.conversions) AS total_conversions
FROM marketing_data md
JOIN website_revenue wr ON md.campaign_id = wr.campaign_id
JOIN campaign_info ci ON md.campaign_id = ci.id
GROUP BY md.campaign_id, ci.name
ORDER BY efficiency_ratio DESC, net_profit DESC;

/* 6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
Ans: Sunday is the best day as it has the highest average revenue. */
SELECT
    DAYNAME(md.date) AS day_of_week,
    AVG(wr.revenue) AS avg_revenue,
    -- Other possible variables of interest
    AVG(md.impressions) AS avg_impressions,
    AVG(md.clicks) AS avg_clicks,
    AVG(md.conversions) AS avg_conversions
FROM marketing_data md
JOIN website_revenue wr ON md.campaign_id = wr.campaign_id
GROUP BY day_of_week
-- Priorities of tie breakers may be adjusted based on which measure better measures success for the campaign.
ORDER BY avg_revenue DESC, avg_conversions DESC, avg_clicks DESC;