"""Importing neccessary Libraries"""

import firebase_admin
from firebase_admin import credentials,firestore

import pandas as pd #to store the articles in dataframe and process
import nltk
nltk.download('stopwords') #used to remove stop words
nltk.download('punkt')  #used in word tokenize
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import unicodedata #to convert the sentence to unicode
import re #used to remove punctuations

from tensorflow.keras.preprocessing.text import Tokenizer #tokenize the articles and fit
from tensorflow.keras.preprocessing.sequence import pad_sequences #pad the text with max length

import numpy as np #
from numpy.linalg import norm #to find magnitude

import heapq
"""connecting to db"""

cred = credentials.Certificate("python_modules/ServiceAccountKey.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()

#getting the docs from the database
docs = db.collection(u'articles').stream()


"""Prepocessing"""

stop_words = set(stopwords.words('english'))

#Converting unicode to ascii 
def unicode_to_ascii(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn')
    
def preprocess(w):
  #lowercase all the text
  w = unicode_to_ascii(w.lower().strip())

  #Remove puntuations
  w = re.sub(r"([?.!,¿])", r" ", w)
  w = re.sub(r'[" "]+', " ", w)
  w = re.sub(r"[^a-zA-Z?.!,¿]+", " ", w)

  #tokenizes into words
  word_tokens = word_tokenize(w)
  
  #remove stopwords
  new_sent = [w for w in word_tokens if w not in stop_words]
  
  #join the words
  new_sent = ' '.join(str(elem) for elem in new_sent)
  
  return new_sent

# function to return the dataframe with the preprocessed articles
def get_articles():
  articles = pd.DataFrame()
  for doc in docs:
    new_dic = doc.to_dict()
    articles = articles.append({"id":doc.id,"content":preprocess(new_dic["content"]),"similar_id":list(),"similar_per":list()},ignore_index=True)
  return articles

#get the preprocessed articles
articles = get_articles()

"""Tokenizing and storing the vocubulary"""


tokenizer = Tokenizer(num_words=10000, oov_token='<UNK>')
tokenizer.fit_on_texts(articles["content"])

maxlen = 100
#A function to return padded article
def get_sequences(tokenizer, article):
  sequences = tokenizer.texts_to_sequences([article])
  padded = pad_sequences(sequences, truncating='post', padding='post', maxlen=maxlen)
  return padded


# define two lists or array
def get_cosine_similarity(l1,l2):
 
  return round(l1[0].dot(l2[0])/ (np.linalg.norm(l1) * np.linalg.norm(l2)),3)

"""adding the similarity to the dataframe articles"""

length = len(articles)
for i in range(length):
  for j in range(length):
    if(i!=j):
      similarity = get_cosine_similarity(get_sequences(tokenizer,articles["content"][i]),get_sequences(tokenizer,articles['content'][j]))
      articles.iloc[i]["similar_per"].append(similarity)
      articles.iloc[i]["similar_id"].append(articles.iloc[j]["id"])

"""Updating the top 3 related artocles to the article"""


for index in range(len(articles)):
  related = list()
  #largest 3 related articles
  larg3 = heapq.nlargest(3, zip( articles['similar_per'][index] , articles['similar_id'][index]))
  for i in larg3:
    related.append({"id":i[1],"per":i[0]})
  db.collection(u"articles").document(articles['id'][index]).update({"related":related})
