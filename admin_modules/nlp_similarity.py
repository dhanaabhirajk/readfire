#pip3 freeze > requirements.txt 

import firebase_admin
from firebase_admin import credentials,firestore

#connecting to db
cred = credentials.Certificate("./ServiceAccountKey.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()

