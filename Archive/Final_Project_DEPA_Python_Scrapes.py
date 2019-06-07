#!/usr/bin/env python
# coding: utf-8

# # Coins Table
# #### Stores the cryptocurrency names, symbols & slugs as well as coin_id (PK).

# In[252]:


import pandas as pd
import numpy as np
import datetime as dt
from datetime import date


# In[196]:


#Coins Table : top 100 currencies names/symbols/slugs
df_names = pd.read_csv('/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/crypto_names.csv')
df_names.head()


# # Date ID Table

# In[270]:


dates_df = pd.DataFrame({'date': pd.date_range(start='1/1/2009', end=date.today()), 'date_id' : range(len(pd.date_range(start='1/1/2009', end=date.today())))})


# In[271]:


dates_df.tail()


# # Reddit Table
# #### Reddit posts from /r/Cryptocurrency from 2017-2019

# In[5]:


import praw
from psaw import PushshiftAPI


# In[6]:


#Connect to reddit API
reddit = praw.Reddit(client_id='GjfUHQE8AYnXLg', client_secret='PfbhtsXJGAAUNiEyHPRGPuFJ0ro', user_agent='DEPA_Project')
api = PushshiftAPI()


# In[ ]:


#Extract all posts to /r/CryptoCurrency from 2017-2019

start_epoch=int(dt.datetime(2017, 1, 1).timestamp())
end_epoch = int(dt.datetime(2019, 1, 1).timestamp())

reddit_data = pd.DataFrame(api.search_submissions(after=start_epoch,
                            before=end_epoch,
                            subreddit='CryptoCurrency',
                            filter=['author', 'title', 'subreddit', 'num_comments', 'created', 'score']))


# In[ ]:


#Convert the created_utc column to a date 
reddit_data['created_utc']=(pd.to_datetime(reddit_data['created_utc'],unit='s'))


# In[ ]:


#remove redundant columns
reddit_data = reddit_data.drop(['created', 'd_'], axis = 1)


# In[11]:


#Rename index to post_id
reddit_data.index.names = ['post_id']


# In[ ]:


#convert created_utc to just a date
reddit_data['created_utc'] = reddit_data['created_utc'].dt.date


# In[224]:


reddit_data['created_utc'] = pd.to_datetime(reddit_data['created_utc'])


# In[225]:


reddit_data.head()


# In[272]:


#Add date_id column to reddit_data
reddit_data2 = reddit_data.merge(dates_df, how = 'left', left_on = 'created_utc', right_on = 'date')


# In[ ]:


#Rename created_utc to date
reddit_data2.rename(columns = {'created_utc':'date'}, inplace = True)


# In[362]:


#Drop date column
reddit_data2 = reddit_data2.drop('date', axis = 1)


# In[364]:


reddit_data2.head()


# # Create reddit_coins Join Table 
# #### Matches the reddit posts in reddit_data table to the coins in coins table

# In[13]:


#Zip the names into tuple of (name, slug, symbol)
zipped_names = list(zip(df_names['name'],df_names['slug'],df_names['symbol']))

#Create a search list - seperating the three terms with OR operator (|)
search_list = []
for (name, slug, symbol) in zipped_names:
    listt = [name, slug, symbol]
    pat = '|'.join(listt)
    search_list.append(pat)


# In[15]:


#Add boolean columns
import re
dummy_df = pd.DataFrame(dict((name, reddit_data.title.str.contains(name, re.IGNORECASE))
                             for name in search_list))


# In[16]:


dummy_df.head()


# In[17]:


#Convert dummy columns into rows with post_id as the index
i, j = np.where(dummy_df)

coins_mentioned_series = pd.Series(dict(zip(zip(i, j), dummy_df.columns[j])))


# In[30]:


#Create final join table between reddit and coins table. Rename columns of dataframe. 
coin_reddit_join = pd.DataFrame(coins_mentioned_series).reset_index()
coin_reddit_join.columns = ['post_id', 'coin_id', 'coin_name']
coin_reddit_join = coin_reddit_join.drop('coin_name', axis = 1)
coin_reddit_join.head()


# # Pricing Table

# In[55]:


import requests
import datetime
import pandas as pd


# In[56]:


def daily_price_historical(symbol, comparison_symbol, all_data=True, limit=1, aggregate=1, exchange=''):
    url = 'https://min-api.cryptocompare.com/data/histoday?fsym={}&tsym={}&limit={}&aggregate={}'            .format(symbol.upper(), comparison_symbol.upper(), limit, aggregate)
    if exchange:
        url += '&e={}'.format(exchange)
    if all_data:
        url += '&allData=true'
    page = requests.get(url)
    data = page.json()['Data']
    df = pd.DataFrame(data)
    df['timestamp'] = [datetime.datetime.fromtimestamp(d) for d in df.time]
    return df


# In[57]:


pricing_list = []

for symbol in list(df_names['symbol']):
# initialise scraper with time interval
    try:
        df = daily_price_historical(symbol, 'USD')
        df['name'] = symbol
        pricing_list.append(df)
    except:
        df2 = pd.DataFrame(columns = df.columns)
        pricing_list.append(df2)


# In[59]:


pricing_df = pd.concat(pricing_list)


# In[65]:


pricing_df.head()


# In[79]:


pricing_df2 = pricing_df.merge(df_names[['symbol', 'coin_id']], how = 'left', left_on = 'name', right_on = 'symbol')
pricing_df3 = pricing_df2.drop(['name', 'symbol', 'time'], axis = 1)


# In[80]:


#Convert to date
pricing_df3['timestamp'] = pricing_df3['timestamp'].dt.date


# In[233]:


#Make it a datetime object 
pricing_df3['timestamp'] = pd.to_datetime(pricing_df3['timestamp'])


# In[234]:


pricing_df3.head()


# In[275]:


#Add date_id column to reddit_data
pricing_df4 = pricing_df3.merge(dates_df, how = 'left', left_on = 'timestamp', right_on = 'date')

#remove timestamp (replaced with date)
pricing_df4 = pricing_df4.drop('timestamp', axis = 1)

pricing_df4['date_id'].astype('int')


# In[374]:


#Drop Redundant date columns
pricing_df5 = pricing_df4.drop('date', axis = 1)

pricing_df5.head()


# # Google Trends table

# In[ ]:


#Pulling google trends data from cryptory 

i=1
google_data_list = []
for name in list(df_names['name']):
    if(i>0 and i<101):
        i=i+1
        kw_list = []
        kw_list.append(name)
        try:
            data = my_cryptory.get_google_trends(kw_list)
            google_data_list.append(data)
        except:
            continue;


# In[ ]:


trend_df1 = pd.concat(google_data_list)

trend_df2 = pd.DataFrame(df1.pivot_table(index = 'date').unstack()).reset_index()


# In[118]:


#Adding coin_id column
trend_df3 = trend_df2.merge(df_names[['name', 'coin_id']], how = 'left', left_on = 'level_0', right_on = 'name')

#Dropping columns
trend_df3 = trend_df3.drop(['level_0', 'name'], axis = 1)

#Rename columns
trend_df3.columns = ['date', 'trend', 'coin_id']


# In[367]:


#Add date_id column
trend_df4 = trend_df3.merge(dates_df, how = 'left', left_on = 'date', right_on = 'date').drop('date', axis = 1)
trend_df4.head()


# # Twitter Table

# In[125]:


import re
import csv
import requests
from bs4 import BeautifulSoup
from IPython.display import HTML


# In[182]:


import pandas as pd
tweets_df = pd.DataFrame({'Date': [], 'No. of Tweets': [], 'Coin': []})

for i in range(0,len(df_names['symbol'])-1):
    #len(coin_name["symbol"])-1

    coin = df_names['symbol'][i]
    url = 'https://bitinfocharts.com/comparison/tweets-'+coin.lower()+'.html'
    headers = {'User-Agent': "Chrome/54.0.2840.90"}
    response = requests.get(url, headers=headers)
    html = response.text 

    from bs4 import BeautifulSoup
    soup = BeautifulSoup(html, 'html.parser')

    x = soup.find_all('script')

    data_1 = re.findall(r'(\[new\sDate.*\]])', str(x))
    data_1 = str(data_1)
    
    
    if data_1 == '[]':
        continue
    data_2 = data_1.split("],[")
    data_2[0] = data_2[0][3:]
    data_2[len(data_2) - 1] = data_2[len(data_2) - 1][:-4]
    data_pd = pd.DataFrame(data_2)
    data_clean = data_pd[0].str.split(",", expand = True)
    data_clean = data_clean.iloc[:, 0:2]
    data_clean.columns = ['Date', 'No. of Tweets']
    data_clean["Date"] = data_clean["Date"].str.slice(10,20)
    data_clean["Coin"] = coin.upper()
    tweets_df = tweets_df.append(data_clean, ignore_index = True)


# In[183]:


#Convert Date into datetime object
tweets_df['Date'] = tweets_df['Date'].astype('datetime64')


# In[184]:


#Remove the null rows
tweets_df = tweets_df[tweets_df['No. of Tweets'] != 'null']


# In[185]:


#Convert No. of Tweets into int object
tweets_df['No. of Tweets'] = tweets_df['No. of Tweets'].astype('int')


# In[186]:


#Adding coin_id column
tweets_df = tweets_df.merge(df_names[['symbol', 'coin_id']], how = 'left', left_on = 'Coin', right_on = 'symbol')

#Drop redundant name columns
tweets_df = tweets_df.drop(['Coin', 'symbol'], axis = 1)


# In[279]:


#add date_id column
tweets_df2 = tweets_df.merge(dates_df, how = 'left', left_on = 'Date', right_on = 'date')


# In[370]:


tweets_df3 = tweets_df2.drop(['Date', 'date'], axis = 1)

tweets_df3.head()


# # Reddit Subscribers

# In[282]:


# load package
from cryptory import Cryptory

# initialise object 
# pull data from start of 2017 to present day
my_cryptory = Cryptory(from_date = "2017-01-01",to_date="2019-01-01", ascending=True)


# In[305]:


#Subreddits based on symbol

empty_df = pd.DataFrame(columns = ['date','total_subscribers','subreddit'])
subreddit_list = []
for name in list(df_names['symbol']):
    try:
        subred = my_cryptory.extract_reddit_metrics(subreddit = name, metric = "total-subscribers", col_label="", sub_col=True)
        if (type(subred) == ValueError):
            subreddit_list.append(empty_df)
        else:
            subreddit_list.append(subred)
    except:
        subreddit_list.append(empty_df)


# In[308]:


#Concatenate DF's of symbol-based subreddits
reddit_subscribers = pd.concat(subreddit_list)


# In[331]:


#Add the date_id column
reddit_subscribers1 = reddit_subscribers.merge(dates_df, how = 'left', left_on = 'date', right_on = 'date')

#Add the coin_id column
reddit_subscribers2 = reddit_subscribers1.merge(df_names[['symbol', 'coin_id']], how = 'left', left_on = 'subreddit', right_on = 'symbol')


# In[334]:


#Drop the symbol column
reddit_subscribers3 = reddit_subscribers2.drop(['symbol'], axis = 1)


# In[335]:


reddit_subscribers3.head()


# In[312]:


#Subreddits based on name

empty_df = pd.DataFrame(columns = ['date','total_subscribers','subreddit'])
subreddit_list2 = []
for name in list(df_names['name']):
    try:
        subred = my_cryptory.extract_reddit_metrics(subreddit = name, metric = "total-subscribers", col_label="", sub_col=True)
        if (type(subred) == ValueError):
            subreddit_list2.append(empty_df)
        else:
            subreddit_list2.append(subred)
    except:
        subreddit_list2.append(empty_df)


# In[314]:


#Concatenate DF's of name-based subreddits
reddit_subscribers_name = pd.concat(subreddit_list2)


# In[336]:


#Add the date_id column
reddit_subscribers_name1 = reddit_subscribers_name.merge(dates_df, how = 'left', left_on = 'date', right_on = 'date')

#Add the coin_id column
reddit_subscribers_name2 = reddit_subscribers_name1.merge(df_names[['name', 'coin_id']], how = 'left', left_on = 'subreddit', right_on = 'name')


# In[339]:


#Drop the name column
reddit_subscribers_name3 = reddit_subscribers_name2.drop('name', axis = 1)


# In[343]:


# CONCATENATE BOTH SUBSCRIBERS TABLES INTO ONE

reddit_subscribers_final = pd.concat([reddit_subscribers3, reddit_subscribers_name3])


# In[372]:


#Drop Redundant date columns
reddit_subscribers_final2 = reddit_subscribers_final.drop('date', axis = 1)

reddit_subscribers_final2.head()


# # Saving our tables into CSV files

# In[120]:


reddit_data.to_csv(path_or_buf = '/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/reddit_posts.csv')


# In[122]:


coin_reddit_join.to_csv(path_or_buf = '/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/coin_reddit.csv')


# In[123]:


trend_df3.to_csv(path_or_buf = '/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/google_trends.csv')


# In[124]:


pricing_df3.to_csv(path_or_buf = '/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/pricing.csv')


# In[188]:


tweets_df.to_csv(path_or_buf = '/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/tweets.csv')


# In[344]:


reddit_subscribers_final.to_csv(path_or_buf = '/Users/nazihkalo/Desktop/UChicago_Analytics/Quarter 1/DEPA/Final Project/Data/reddit_subs.csv')


# In[345]:


get_ipython().system('jupyter nbconvert --to script Final_Project_DEPA_Python_Scrapes.ipynb')


# In[ ]:




