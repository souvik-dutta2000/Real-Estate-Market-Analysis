SELECT COUNT(*) FROM [dbo].[Real_estate clean];
SELECT COUNT(DISTINCT Property_ID) FROM [dbo].[Real_estate clean];
  SELECT City, COUNT(*) FROM [dbo].[Real_estate clean] GROUP BY City;

  -- Q1. Average price per sq ft by city
  SELECT City, ROUND(AVG(Price_Per_SqFt), 0) AS avg_ppsf
FROM [dbo].[Real_estate clean] 
GROUP BY City 
ORDER BY avg_ppsf DESC;
 
  --Q2. Yearly price trend
  SELECT YEAR(Listing_Date) AS yr, City, ROUND(AVG(Price_Per_SqFt), 0) AS avg_ppsf
FROM [dbo].[Real_estate clean] 
GROUP BY YEAR(Listing_Date), City 
ORDER BY City, yr;

 -- Q3. YoY growth % per city (window function)

WITH yearly AS (
    SELECT 
        City, 
        YEAR(Listing_Date) AS yr, 
        AVG(Price_Per_SqFt) AS ppsf
    FROM [dbo].[Real_estate clean] 
    GROUP BY City, YEAR(Listing_Date)
)
SELECT 
    City, 
    yr, 
    ROUND(ppsf, 0) AS ppsf,
    ROUND((ppsf - LAG(ppsf) OVER (PARTITION BY City ORDER BY yr)) 
          / LAG(ppsf) OVER (PARTITION BY City ORDER BY yr) * 100.0, 2) AS yoy_pct
FROM yearly;
 
 -- Q4. Fastest selling property types

  SELECT Property_Type, ROUND(AVG(Days_On_Market),1) AS avg_days
  FROM [dbo].[Real_estate clean] WHERE Status='Sold'
  GROUP BY Property_Type ORDER BY avg_days;
 
 -- Q5. Top 10 most expensive localities (min 10 listings)
  SELECT TOP 10 
    City, 
    Locality, 
    COUNT(*) AS listings, 
    ROUND(AVG(Price_Per_SqFt), 0) AS avg_ppsf
FROM [dbo].[Real_estate clean] 
GROUP BY City, Locality
HAVING COUNT(*) >= 10 
ORDER BY avg_ppsf DESC;
 
 -- Q6. Sold / Available / Negotiation share
  SELECT Status, COUNT(*) AS cnt,
         ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM[dbo].[Real_estate clean]),2) AS pct
  FROM [dbo].[Real_estate clean] GROUP BY Status;
 
 -- Q7. Rank agents by sold deals and revenue
  SELECT Agent_Name, COUNT(*) AS deals, ROUND(SUM(Price_Lakhs),2) AS value_lakhs,
         RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
  FROM [dbo].[Real_estate clean] WHERE Status='Sold' GROUP BY Agent_Name;
 
 -- Q8. Impact of property age on price
  -- Q8. Impact of property age on price
SELECT 
    CASE 
        WHEN Property_Age_Years <= 2 THEN 'New'
        WHEN Property_Age_Years <= 10 THEN 'Mid-age' 
        ELSE 'Old' 
    END AS age_group,
    ROUND(AVG(Price_Per_SqFt), 0) AS avg_ppsf
FROM [dbo].[Real_estate clean] 
GROUP BY 
    CASE 
        WHEN Property_Age_Years <= 2 THEN 'New'
        WHEN Property_Age_Years <= 10 THEN 'Mid-age' 
        ELSE 'Old' 
    END;
 
  --Q9. Properties priced above their city average (subquery)
  SELECT Property_ID, City, Price_Per_SqFt
  FROM [dbo].[Real_estate clean] p
  WHERE Price_Per_SqFt > (SELECT AVG(Price_Per_SqFt) FROM [dbo].[Real_estate clean] WHERE City = p.City);
 
  --Q10. Monthly listings trend

SELECT 
    FORMAT(Listing_Date, 'yyyy-MM') AS ym, 
    COUNT(*) AS listings
FROM [dbo].[Real_estate clean] 
GROUP BY FORMAT(Listing_Date, 'yyyy-MM')
ORDER BY ym;
 
--STEP 15: Create a view for Power BI
GO
USE real_estate;
GO

CREATE  VIEW dbo.vw_properties_summary AS
SELECT 
    Property_ID,
    Listing_Date,
    YEAR(Listing_Date) AS Listing_Year,
    City,
    Locality,
    Property_Type,
    BHK,
    Area_SqFt,
    Property_Age_Years,
    Furnishing,
    Price_Lakhs,
    Price_Per_SqFt,
    Status,
    Days_On_Market,
    Sold_Date,
    Agent_Name,
    Parking,
    Lift,
    Rating,
    CASE 
        WHEN Price_Lakhs < 50 THEN 'Budget'
        WHEN Price_Lakhs < 120 THEN 'Mid'
        ELSE 'Premium'
    END AS Price_Segment
FROM [dbo].[Real_estate clean]
WHERE Status = 'Available';
GO