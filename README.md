# Real Estate Market Trends Analysis

Tools: Excel | SQL | Power BI (DAX) Author: Souvik Dutta Dataset: 2,000 property listings (synthetic, created for practice)

An end-to-end data analysis project that studies how property prices, demand and selling speed vary across Indian cities, localities and property types from 2023 to 2026. Data was cleaned in Excel, analysed with SQL, and presented in an interactive 3-page Power BI dashboard.

Business Problem

A real estate company wants to understand its market so it can price properties correctly, focus on the right locations and improve sales performance.

Questions answered

Which city has the highest and lowest price per sq ft?
How have prices changed year over year?
Which property type sells fastest?
Which localities are the most expensive?
How do property age, furnishing, parking and lift affect price?
What share of listings are sold, available or under negotiation?
How are agents performing?
Dataset

Note: The data is synthetic (generated for learning and portfolio use). It is not real market data, so the findings describe this dataset only, not the real market.

Item	Detail
Rows	2,000 (1,990 after removing duplicates)
Columns	18
Cities	Kolkata, Mumbai, Delhi NCR, Bengaluru, Hyderabad, Chennai, Pune
Period	Jan 2023 to Dec 2026 (listing dates)

Columns: Property_ID, Listing_Date, City, Locality, Property_Type, BHK, Area_SqFt, Property_Age_Years, Furnishing, Price_Lakhs, Price_Per_SqFt, Status, Days_On_Market, Sold_Date, Agent_Name, Parking, Lift, Rating

Deliberate data quality issues (for cleaning practice): 10 duplicate rows, 25 blank Furnishing values, 12 blank Rating values.

Project Workflow
1. Excel: Data Cleaning and Exploration
Converted data to an Excel Table and checked data types.
Removed 10 duplicate rows (2,000 to 1,990).
Replaced blank Furnishing values with "Not Specified"; left blank Ratings untouched instead of inventing values.
Created helper columns: Listing_Year, Listing_Month, Price_Segment, Age_Group.
Built pivot tables, charts and slicers, and a quick Excel dashboard.
Documented every decision in a Cleaning Log sheet.
2. SQL: Analysis
Created a properties table and imported the cleaned CSV.
Validated the import (row counts, distinct IDs).
Wrote queries using aggregations, CASE, subqueries, CTEs and window functions (LAG, RANK).
Created the view vw_properties_summary for Power BI.

Examples of questions solved in SQL: average price per sq ft by city, YoY price growth, fastest-selling property types, top localities, agent ranking, impact of property age on price, and monthly listing trends.

3. Power BI: Dashboard
Loaded vw_properties_summary, cleaned data in Power Query.
Built a Date table and the columns Year-Month, Age_Group (with sort column).
Wrote DAX measures:
DAX
Total Listings   = COUNTROWS(vw_properties_summary)
Avg Price SqFt   = AVERAGE(vw_properties_summary[Price_Per_SqFt])
Avg Price Lakhs  = AVERAGE(vw_properties_summary[Price_Lakhs])
Sold Count       = CALCULATE(COUNTROWS(vw_properties_summary), vw_properties_summary[Status] = "Sold")
Sold %           = DIVIDE([Sold Count], [Total Listings])
Avg Days to Sell = CALCULATE(AVERAGE(vw_properties_summary[Days_On_Market]), vw_properties_summary[Status] = "Sold")
Total Sales Value = CALCULATE(SUM(vw_properties_summary[Price_Lakhs]), vw_properties_summary[Status] = "Sold")
Status Share %   = DIVIDE([Total Listings], CALCULATE([Total Listings], ALL(vw_properties_summary[Status])))

Dashboard pages

Market Overview: KPI cards, price by city, price trend over time, status donut, slicers.
Location & Property Insights: city map, top 10 localities, Property Type x BHK matrix, price by age group and furnishing.
Sales & Agent Performance: deals by agent, area vs price scatter, top 10 sold properties, days-to-sell trend.
Key Results (no filters applied)
KPI	Value
Total Listings	1,990
Avg Price per SqFt	about Rs 13,170
Sold %	55.8%
Avg Days to Sell	60.6 days
Key Insights
Location drives price the most. Mumbai is the most expensive city (about Rs 25,000 per sq ft), roughly 2.7 times Kolkata (about Rs 9,400), the cheapest.
Larger and more bedrooms mean higher prices, and villas are priced above other property types.
Newer properties cost more per sq ft than older ones.
Furnishing showed no meaningful price difference in this dataset.
Agent performance was evenly spread, with no clear top performer (agents were assigned randomly in this synthetic data).
Just over half of all listings are sold; the rest are still available or under negotiation.
Recommendations
Price new listings by city and locality benchmarks, with adjustments for property age.
Focus marketing spend on high-value localities where each sale brings more revenue.
Track days on market by property type to spot slow-moving inventory early.
With real data, use agent and locality analysis to guide training and territory planning.
Dashboard Screenshots

Add your screenshots here.

Page 1: Market Overview Page 2: Location & Property Insights Page 3: Sales & Agent Performance

Repository Structure
RealEstate-Market-Trends/
|-- data/
|   |-- real_estate_dataset_2000.csv      (raw)
|   |-- real_estate_clean.csv             (cleaned)
|-- excel/
|   |-- RealEstate_Project.xlsx
|-- sql/
|   |-- real_estate_queries.sql
|-- powerbi/
|   |-- RealEstate_Dashboard.pbix
|   |-- page1_market_overview.png
|   |-- page2_location_insights.png
|   |-- page3_sales_agents.png
|-- README.md
How to Run
Open excel/RealEstate_Project.xlsx to see the cleaning and pivot analysis.
Create a database, run the table script and import data/real_estate_clean.csv, then run sql/real_estate_queries.sql.
Open powerbi/RealEstate_Dashboard.pbix in Power BI Desktop (update the data source path if needed).
Limitations and Future Work
The dataset is synthetic, so real-world patterns (for example, furnishing affecting price) may not appear.
Next step: repeat the analysis with a real dataset (for example from Kaggle) and add features such as price forecasting.
Contact

Souvik Dutta | Data Analyst (Fresher) | Kolkata
