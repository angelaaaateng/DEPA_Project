# Modified from: https://gist.github.com/yanofsky/5436496

import tweepy #https://github.com/tweepy/tweepy
import csv
import sys
from getTwitterHandles_AT import getTwitterHandles
import re


# Twitter API credentials 
consumer_key = "7loZ1Jrzi8lEClQpUPZ03AWAJ"
consumer_secret = "OupVSlv6IV3LoP4j7FRg4tiecD6He5XfT035NsDr93CfWkCfqx"
access_key = "307813351-umbg9GQz59PwbMgz2yY7fiDAeUpTUBHcwc05JdU9"
access_secret = "qDOTtQvPrJ2ZRZWP2AcKo9VI4TXpqCByOxhDoqzgl4SK7"


# CSV reader for list of 100 cryptocurrencies
def name_cleaning(filename):
	crypto_final_names = []
	with open(filename) as csvfile:
		cryptonames = csv.reader(csvfile)
		for row in cryptonames:
			for word in row:
				crypto_final_names.append('\\b' + word.lower() + '\\b')
	crypto_regex = '|'.join(crypto_final_names)
	return crypto_regex

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
	crypto_regex = re.compile(name_cleaning('Crypto_names.csv'))

	outtweets = [[tweet.id_str, tweet.created_at, tweet.text] for tweet in alltweets
		if re.search(crypto_regex, tweet.text.lower())]

	test = []

	#write the csv
	with open('./Tweets/%s_tweets.csv' % screen_name, 'w') as f:
		writer = csv.writer(f)
		writer.writerow(["id","created_at","text"])
		writer.writerows(outtweets)

	pass


if __name__ == '__main__':
	handles = getTwitterHandles()

	startHere = 0
	# for i in range(1):
	# #for i in range(len(handles)):
	# 	if handles[i]=="petertoddbtc":
	# 		handles[i]="peterktodd"
	# 		startHere = i

	# for i in range(startHere, ):
	for i in range(startHere, len(handles)):
		get_all_tweets(str(handles[i]))
	#get_all_tweets(str(handles[0]))

#	for handle in handles:
#		get_all_tweets(str(handle))
