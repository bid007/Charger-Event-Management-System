from libmongo import get_db
from bson.objectid import ObjectId
from mongokit import Document, Connection 
import datetime
db = get_db()

def max_length(length):
    def validate(value):
        if len(value) <= length:
            return True
        # must have %s in error format string to have mongokit place key in there
        raise ValidationError('%s must be at most {} characters long'.format(length))
    return validate

@db.register
class Rating(Document):
	__collection__ = 'rating'
	__database__ = 'chevent'
	structure = {
		'eid' : basestring,
		'uid' : basestring, 
		'rating' : float
	}
	required_fields = ['eid', 'uid', 'rating']

@db.register
class User(Document):
	__collection__ = 'user'
	__database__ = 'chevent'
	structure = {
		'fname' : basestring,
		'lname' : basestring,
		'email' : basestring,
		'gender': basestring,
		'uid' : basestring,
		'event' : [ObjectId] # event object id
	}
	validators = {
		"fname" : max_length(100),
		"lname" : max_length(100),
		"email" : max_length(100),
	}
	required_fields = ['email','uid','fname','lname','gender']

@db.register
class Organization(Document):
	__collection__ = 'organization'
	__database__ = 'chevent'	
	structure = {
		'name' : basestring,
		'email' : basestring,
		'uid' : basestring,
	}
	validators = {
		"name" : max_length(100),
		"email" : max_length(100),
	}
	required_fields = ['name','email','uid']


@db.register
class Event(Document):
	__collection__ = 'event'
	__database__ = 'chevent'
	structure = {
		'name': basestring,
		'location' : basestring,
		'description' : basestring,
		'date' : datetime.datetime, #mm/dd/yyyy 
		'time' : basestring, #hh:mm 
		'user' : [basestring],
		'uid': basestring,
	}
	validators = {
		"name" : max_length(100),
		"location" : max_length(100),
		"description" : max_length(500),
	}
	required_fields = ['name', 'location', 'date', 'uid', 'description', 'time']