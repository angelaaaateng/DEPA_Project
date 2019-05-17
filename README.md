# Data Engineering Platforms Project
A project by: Nazih Kalo, Akarsh Sahu, Sowmya, Angela Teng

Created for: Shree Bharadwaj 

## Cryptocurrency Prediction Platform
### Cryptocurrency Information
- Pricing Data
- Reddit Comments
  - Overall Website Engagement --> mentions in posts/comments
  - Specific Subreddit Engagement --> subscribers to specific sub
- Twitter
  - Hashtags
- News Articles
  - TechCrunch


*Note that this is a time-based analysis*

To Do:
- Visualization
- Recommendations
- Manually matching subreddits to cryptocurrency
  - Ticker + hashtags

Data Sources: 
- Crypto Pricing 
  - Crypto name 
  - time 
  - price
- Reddit 
  - Time 
  - Title 
  - Score
  - Number of Comments
  - Body 
- Twitter
  - Time 
  - Post
  - Tags 
  - Number of Retweets

Next Steps:
- Webscraping
- Pricing Information
- Timeframe: April 1 2017 to April 1 2019

Data Sources + Useful Resources:
- https://coinmetrics.io/data-downloads/
- https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyInfo
- https://www.reddit.com/r/datasets/comments/65o7py/updated_reddit_comment_dataset_as_torrents/
- https://praw.readthedocs.io/en/latest/code_overview/reddit_instance.html
- http://www.storybench.org/how-to-scrape-reddit-with-python/
- https://praw.readthedocs.io/en/latest/getting_started/authentication.html#script-application
- https://www.reddit.com/r/redditdev/comments/2dew9d/which_base_url_should_i_use_for_api_calls/
- https://www.reddit.com/r/redditdev/comments/85n0wc/what_do_i_put_to_these_fields_in_create/
- https://docs.google.com/document/d/1qxpYFnbUG4oKRUxjfE6TMBOYn8mMvA6IljWaI8Jh7QM/edit
- http://cryptohypetrader.com
- https://github.com/karthik111/Cryptocurrency-price-analysis/blob/master/Crypto_analysis.ipynb


FOR GOOGLE TRENDS:


level 1
call_me_cookie
1 point
·
5 years ago
Ok, me again.
Sorry I didn't reply to your last comment. I didn't quite understand what exactly you were after.
If I understand you correctly, you want to compare the Google Trends Data for 500 different keywords, because GT only lets you view 5 at a time, and you want to compare more than 5 on an objective basis.
If this is the question, you are bang in luck! I solved this problem for my employer long ago.
What you want to do is download each keyword individually, but each time with another 'reference' keyword with quite high and quite stable volume. When GT displays data for a keyword, the search volume displayed is normalised to a percentage of the maximum search volume (there are some other normalisations to remove global trends in Google traffic but these aren't important.)
I'll give you an example: Say you wanted to compare the trends for the word 'ferrari' and the word 'porsche', without having to type them in on GT. Lets choose 'book' as a reference keyword. Using the gist I posted, download the trends for the keywords ['book','porsche'] and the keywords ['book','ferrari']. Now, you have downloaded two reports, one comparing the keywords book and ferrari, the other comparing the words book and porsche. Because in the individual reports, each keyword is normalised against the keyword 'book', the trends for 'porsche' and 'ferrari' have the same normalisation factor, i.e. when you plot the downoaded trends for 'porsche' and 'ferrari' against each other, it will look the same as if you had searched on Google Trends for ['porsche','ferrari'].
This is then trivially extended to as many keywords you want. For each keyword you want Trends for, download the report for that keyword and a reference keyword, the trends you have for each keyword will then have the same normalisation factor and you can compare them objectively!
Hope this has answered your question, if not, keep 'em coming :)
