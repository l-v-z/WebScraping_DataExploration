import pandas as pd
from bs4 import BeautifulSoup as bs
from datetime import timedelta, date
import csv
try:
    from urllib.request import urlopen
except ImportError:
    from urllib2 import urlopen
    

days = 365*3
data = []


for day in range(days):
    
    date = date.fromisoformat('2018-01-01') + timedelta(day)
    url = 'https://darksky.net/details/50.0593,19.9368/' + str(date) +'/us12/en'
    page = urlopen(url)
    soup = bs(page, 'html.parser')
    

    temp = soup.find(attrs={"class": "temperature"}).find(attrs={"class":"num"})
    precipitation = soup.find(attrs={"class": "precipProbability"}).find(attrs={"class":"num swip"})
    rain = soup.find(attrs={"class": "precipAccum swap"}).find(attrs={"class":"num swip"})
    wind = soup.find(attrs={"class": "wind"}).find(attrs={"class":"num swip"})
    pressure = soup.find(attrs={"class": "pressure"}).find(attrs={"class":"num swip"})
    humidity = soup.find(attrs={"class": "humidity"}).find(attrs={"class":"num swip"})
    low = soup.find(attrs={"class":"highLowTemp swip"}).find(attrs={"class": "lowTemp swap"}).find(attrs={"class": "temp"})
    high = soup.find(attrs={"class":"highLowTemp swip"}).find(attrs={"class": "highTemp swip"}).find(attrs={"class": "temp"})
    
    
    tags= [str(date),temp.text, precipitation.text, rain.text, wind.text, pressure.text, humidity.text, low.text.strip('/')[:2],high.text.strip('/')[:2] ]

    for i,con in enumerate(tags):
    		if con == '???' or con == '-' or con == '< 1 in' or con == 'NaN':
    		   tags[i]= ''

   
     
    data.append(tags)
    headers = ['Date','Temperature', 'Precipitation(%)', 'Rain(in)',  'Wind(mph)', 'Pressure(mb)', 'Humidity(%)', 'Low', 'High'] 


with open('krakow_weather_2018_2020.csv', 'w') as file:
    wr = csv.writer(file, lineterminator = '\n')
    wr.writerow(headers)
    wr.writerows(data)
