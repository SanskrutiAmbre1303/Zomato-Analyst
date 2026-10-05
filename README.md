# Zomato-Analyst
Project Overview
This project involves taking a raw Zomato restaurant dataset cleaning and restructuring it using MySQL and building interactive dashboards in Power BI and Tableau to evaluate restaurant performance customer preferences pricing strategies and geographic presence The full pipeline moves from raw data through SQL ETL processes to interactive analytics and visualization

Dataset
Zomato restaurant dataset
Key fields-Restaurant ID, Name, Country, City, Address, Locality Cuisines, Average Cost for two, Has Table booking, Has Online delivery, Price, range, Aggregate rating, Rating color, Rating text, Votes
Final dataset Cleaned and structured table mapped to countries with complete spatial and categorical fields

Tools and Features Used
MySQL Data Cleaning and ETL
Checked for and handled missing values across cuisines locations and rating attributes
Standardized country codes by joining the primary restaurant table with the country code reference table.
Cleaned and formatted text fields to ensure consistent naming across cities and cuisines.
Created price range classifications Low Medium High and Luxury to categorize cost for two
Built a dedicated calendar look up table in SQL for time based analytics and year over year tracking.
Calculated service availability metrics focusing on table booking and online delivery adoption.

Power BI and Tableau Visualization
Built multi page interactive dashboards covering executive metrics rating patterns and service features.
Created custom measures for primary KPIs like Total Restaurants Average Rating Total Votes and Average Cost for Two.
Designed distribution charts bar charts rating scatter plots and spatial maps for city level geographical analysis.
Added interactive slicers for Country City Price Range Rating Category and Service Options to allow dynamic filtering.

Analysis and Key Insights
Dataset spans thousands of restaurants across multiple countries and major global cities
Average rating hovers around standard mid range performance with notable clusters in top rated categories.
Restaurants offering online delivery and table booking systematically achieve higher average ratings and vote counts.
The price bucket analysis reveals that medium tier dining options account for the largest share of overall restaurant listings.
India accounts for the highest volume of listings within the dataset followed by representation from other global markets.
Top performing cuisines consistently attract the highest volume of user votes and positive review classifications.
<img width="630" height="308" alt="ZomatoAnalystTableau" src="https://github.com/user-attachments/assets/7697c4e0-8700-48da-ad4f-174a537924c6" />
<img width="630" height="308" alt="ZomatoAnalystTableau" src="https://github.com/user-attachments/assets/ec3fe0b0-afb4-43c4-8cc6-7051de074d4f" />

