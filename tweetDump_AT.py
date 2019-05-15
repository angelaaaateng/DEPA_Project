# Modified from: https://gist.github.com/yanofsky/5436496

import tweepy #https://github.com/tweepy/tweepy
import csv
import sys
from getTwitterHandles import getTwitterHandles

# Twitter API credentials 
consumer_key = "EFhcDsaecX9e4FlQXyRDHrVaq"
consumer_secret = "LpubHL3haoM2nyI5qOpk0BiC7KZxTSryMZSCvFPIuCfoHd5jCd"
access_key = "307813351-7fl2kA1mvs0K1vF45X1Yaukp5qVzhX3cObb5KNVY"
access_secret = "2f0zBbJRVAnnfN73dDpryPioUu9aOjZcPdA1Gukx02YAa"


def get_all_tweets(screen_name):
	print("Getting tweets from @" + str(screen_name))

	#Twitter only allows access to a users most recent 3240 tweets with this method

	#authorize twitter, initialize tweepy
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_key, access_secret)
	api = tweepy.API(auth)

	#initialize a list to hold all the tweepy Tweets
	alltweets = []

	#make initial request for most recent tweets (200 is the maximum allowed count)
	new_tweets = api.user_timeline(screen_name = screen_name,count=50)

	#save most recent tweets
	alltweets.extend(new_tweets)

	#save the id of the oldest tweet less one
	oldest = alltweets[-1].id - 1

	#keep grabbing tweets until there are no tweets left to grab
	while len(new_tweets) > 0:
		print ("Getting tweets before %s" % (oldest))

		#all subsiquent requests use the max_id param to prevent duplicates
		new_tweets = api.user_timeline(screen_name = screen_name,count=50,max_id=oldest)

		#save most recent tweets
		alltweets.extend(new_tweets)

		#update the id of the oldest tweet less one
		oldest = alltweets[-1].id - 1

		print ("...%s tweets downloaded so far" % (len(alltweets)))

	#transform the tweepy tweets into a 2D array that will populate the csv
	outtweets = [[tweet.id_str, tweet.created_at, tweet.text] for tweet in alltweets]

	#write the csv
	with open('./Tweets/%s_tweets.csv' % screen_name, 'w') as f:
		writer = csv.writer(f)
		writer.writerow(["id","created_at","text"])
		writer.writerows(outtweets)

	pass


if __name__ == '__main__':
	handles = getTwitterHandles()

	startHere = 0
	for i in range(len(handles)):
		if handles[i]=="petertoddbtc":
			handles[i]="peterktodd"
			startHere = i

	for i in range(startHere, len(handles)):
		get_all_tweets(str(handles[i]))

#	for handle in handles:
#		get_all_tweets(str(handle))
