from mongokit import Connection 
db = Connection()

def get_db():
	return db
