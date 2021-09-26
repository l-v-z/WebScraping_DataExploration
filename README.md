# WebScraping_DataExploration
Web scraping and exploratory data analysis on historical weather data


Before we explore any data, it needs to be scraped from the DarkSky website by running scraping.py. After the csv file is created, we need
to change the date format in excel to yyyy-mm-dd that will be accepted by Azure Data Studio by using a simple formula (=TEXT(A2, "yyyy-mm-dd")
in a new column and then replacing the original column with its contents. 
Finally, the dataset is ready to be imported and queried with weather_data_exploration.sql with all columns allowing nulls and all the default data types in place.
