import glob
import pandas  as pd

path = "/Users/angelateng/Documents/GitHub/DEPA_Project/Tweets_Labeled"

all_crypto = glob.glob(path + "/*.csv")

li = []

for filename in all_crypto:
    labeled_crypto = pd.read_csv(filename, index_col=None, header=0)
    li.append(labeled_crypto)

crypto_labeled_data = pd.concat(li, axis=0, ignore_index=True)

print(crypto_labeled_data)
