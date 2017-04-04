from bottle import route, template, request
from Models import *
import time
import 	datetime
import json
from bson import ObjectId

class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)

def string_to_datetime(date_str,time_str):
	date = date_str+"/"+time_str[:-2]
	if "PM" in time_str:
		time = time_str[:-2].split(":")
		time[0] = str((int(time[0]) + 12) % 24)
		time = ":".join(time)
		date = date_str+"/"+time
	print date
	return datetime.datetime.strptime(date, '%m/%d/%Y/%H:%M')

def datetime_to_string(datetime_val):
	return datetime.datetime.strftime(datetime_val, '%m/%d/%Y')

@route('/user/create', method = 'POST')
def create_user():
	q = request.params
	save_param = {'event':[]}
	keys = ['fname','lname','email','gender','uid']
	for key in keys: save_param[key] = q.get(key)
	# check if user already exists in db
	res = db.User.find_one({"uid" : save_param["uid"]})
	if res:
		return {"status" : 0, "msg" : "User Already Exists. Please reset password if you lost it."}
	else:
		try:
			db.User(save_param).save()
		except Exception as e:
			print e
			return {"status" : 0, "msg" : "There is some error. Please try again later."}
	return {"status" : 1, "msg" : "Your username is created. Please proceed to login."}

@route('/user/<uid>')
def get_user_info(uid):
	resUser = db.User.find_one({"uid":uid})
	resOrg = db.Organization.find_one({"uid":uid})
	if resUser:
		return {"status":1,	"name":resUser["fname"],"org":False, "id": str(resUser["_id"])}
	elif resOrg:
		return {"status":1, "name":resOrg["name"], "org":True, "id":str(resOrg["_id"])}
	else:
		return {"status":0, "msg":"The user doesnot exist"}


# All the past event of the user.
@route('/<uid>/user/event/past', method = 'GET')
def get_past_event_user(uid):
	user_event = db.User.find_one({"uid" : uid}, {"event" : 1, "_id" : 0}).get("event")
	user_event_info = db.Event.find({"_id" : {"$in" : user_event}, "date" : {"$lt" : datetime.datetime.now()}})
	events = {}
	for i,event in enumerate(user_event_info):
		org_info = db.Organization.find_one({'uid':event['uid']})
		rating_db = db.chevent.rating.find_one({'uid':uid, 'eid':str(event["_id"])})
		rating = 0
		if rating_db:
			rating = rating_db.get("rating",0)
		event["rating"] = int(rating)
		event["org_name"] = org_info['name']
		event["org_email"] = org_info['email']
		users = event["user"]
		event["joined"] = str(len(users))
		event["date"] = datetime_to_string(event["date"])
		events[i] = JSONEncoder().encode(event)
	return events


# All of the upcoming event of the user.#subscribed
@route('/<uid>/user/event/upcoming', method = 'GET')
def get_upcoming_event_user(uid):
	user_event = db.User.find_one({"uid" : uid}, {"event" : 1, "_id" : 0}).get("event")
	user_event_info = db.chevent.event.find({"_id" : {"$in" : user_event}, "date" : {"$gte" : datetime.datetime.now()}})
	events = {}
	for i,event in enumerate(user_event_info):
		org_info = db.Organization.find_one({'uid':event['uid']})
		event["org_name"] = org_info['name']
		event["org_email"] = org_info['email']
		users = event["user"]
		event["joined"] = str(len(users))
		event["date"] = datetime_to_string(event["date"])
		events[i] = JSONEncoder().encode(event)
	return events


##########################################################################


############# ORGANIZATION RELATED QUERIES ARE HERE ######################
@route('/organization/create',method= 'POST')
def index():
	q = request.params
	keys = ['name','email','uid']
	save_param = {}
	for key in keys: save_param[key] = q.get(key)
	# check if user already exists in db
	res = db.Organization.find_one({"uid" : save_param["uid"]})
	if res:
		return {"status" : 0, "msg" : "Organization Already Exists. Please reset password if you lost it."}
	else:
		try:
			db.Organization(save_param).save()
		except Exception as e:
			return {"status" : 0, "msg" : "There is some error. Please try again later."}
	return {"status" : 1, "msg" : "Your organization is created. Please proceed to login."}


# Past event created by the organizer.
@route('/<uid>/organizer/past-events', method = 'GET')
def organizer_past_events(uid):
	organizer = db.Organization.find_one({'uid':uid})
	org_name = organizer["name"]
	org_email = organizer["email"]
	events = {}
	for i,event in enumerate(db.Event.find({'uid' : uid, 'date':{'$lt':datetime.datetime.now()} })):

		ratings = db.chevent.rating.find({'eid':str(event["_id"])})
		numb_of_ratings = 0
		total_ratings = 0
		for rating in ratings:
			numb_of_ratings = numb_of_ratings +1
			total_ratings = total_ratings + int(rating.get("rating",0))

		avg_rating = 0
		if numb_of_ratings >0:
			avg_rating = int(total_ratings/numb_of_ratings)

		event["rating"] = avg_rating
		event["org_name"] = org_name
		event["org_email"] = org_email
		users = event["user"]
		event["joined"] = str(len(users))
		event["date"] = datetime_to_string(event["date"])
		events[i] = JSONEncoder().encode(event)
	return events

# Upcoming event by the organizer.
@route('/<uid>/organizer/upcoming-events', method = 'GET')
def organizer_past_events(uid):
	organizer = db.Organization.find_one({'uid':uid})
	org_name = organizer["name"]
	org_email = organizer["email"]
	events = {}
	for i,event in enumerate(db.Event.find({'uid' : uid, 'date':{'$gte':datetime.datetime.now()} })):
		event["org_name"] = org_name
		event["org_email"] = org_email
		users = event["user"]
		event["joined"] = str(len(users))
		event["date"] = datetime_to_string(event["date"])
		events[i] = JSONEncoder().encode(event)
	return events


# List the organizer summary like rating, no. of events created and no. of visitor came.
@route('/<uid>/organizer/summary', method = 'GET')
def organizer_summary(uid):
	organizer = db.Organization.find_one({'uid':uid})
	events = db.Event.find({'uid' : uid})
	people_count = 0
	events_count = 0
	avg_rating = 0
	#find avg rating here as well if event rating is available
	for event in events:
		ratings = db.chevent.rating.find({'eid':str(event["_id"])})
		numb_of_ratings = 0
		total_ratings = 0
		for rating in ratings:
			numb_of_ratings = numb_of_ratings +1
			total_ratings = total_ratings + int(rating.get("rating",0))

		if numb_of_ratings >0:
			avg_rating = int(total_ratings/numb_of_ratings)

		people_count = people_count + len(event["user"])
		events_count += 1
	return {"attendance": str(people_count), "events_count": str(events_count), "avg_rating": str(avg_rating)}
############################################################################


################### EVENT RELATED QUERUES ARE HERE #########################
@route('/<eid>/event/delete', method='GET')
def deleteEvent(eid):
	event = db.Event.find_one({'_id':ObjectId(eid)})	
	users = event["user"]
	try:
		db.chevent.user.update({'uid':{"$in":users}},{"$pull":{"event" : ObjectId(eid)}})
		db.chevent.event.remove({"_id": ObjectId(eid)})
	except Exception as e:
		print e
		return {"status" : 0, "msg" : "Event could not be deleted. Try again."}
	return {"status" : 1, "msg" : "Event successfully  deleted"}

# create event by the organizer
@route('/<uid>/event/create', method='POST')
def organizer_create_event(uid):
	q = request.params
	save_param = {'user' : [], 'uid':uid}
	keys = ['name','location', 'description','time']
	for key in keys: save_param[key] = q.get(key,"")
	date = q.get("date","")
	time = q.get("time","")
	if date and time:
		save_param["date"] = string_to_datetime(date, time)

 	_id = q.get("_id",None)
	#for update
	if _id:
		try:
			doc = db.chevent.event.update({"_id":ObjectId(_id)},{"$set":save_param})
		except Exception as e:
			print e
			return {'status' : 0, 'msg' : 'There is error in updating the event'}
		return {'status' : 1, 'msg' : 'Event successfully updated'}
	#for new insert
	try:
		res = db.Event(save_param).save()
		print res
	except Exception as e:
		print e
		return {'status' : 0, 'msg' : 'There is error in creating the event'}
	return {'status' : 1, 'msg' : 'Event successfully created'}

# list all the events from all the organizers.
# Format is {0: {event_dict_1}, 1 : {event_dict_2}}

# list all the events from the specific organizer.
@route('/<uid>/list/event', method = 'GET')
def event_list_by_organizer(uid):
	organizer = db.Organization.find_one({'uid':uid})
	org_name = organizer["name"]
	org_email = organizer["email"]
	events = {}
	for i,event in enumerate(db.Event.find({'uid' : uid})):
		event["org_name"] = org_name
		event["org_email"] = org_email
		users = event["user"]
		event["joined"] = str(len(users))
		event["date"] = datetime_to_string(event["date"])
		events[i] = JSONEncoder().encode(event)
	return events

# list the upcomig events from all of organizers.
@route('/<uid>/event/list/upcoming', method = 'GET')
def event_list_upcoming(uid):
	current_time = int(time.time())
	subscribed_events = db.chevent.user.find_one({"uid":uid}).get("event")
	events = {}
	q = request.params
	for i,event in enumerate(db.Event.find({'date':{'$gte':datetime.datetime.now()}, '_id':{'$nin':subscribed_events}})):
		org_info = db.Organization.find_one({'uid':event['uid']})
		event["org_name"] = org_info['name']
		event["org_email"] = org_info['email']
		users = event["user"]
		event["joined"] = str(len(users))
		event["date"] = datetime_to_string(event["date"])
		events[i] = JSONEncoder().encode(event)
	return events

# users subscribes in an event.
@route('/<uid>/joinevent/<eid>', method = 'GET')
def user_subscribe_event(uid, eid):
	try:
		db.chevent.event.update({"_id" : ObjectId(eid)},{"$push" : {"user":uid}})
		db.chevent.user.update({"uid" : uid}, {"$push" : {"event":ObjectId(eid)}})
	except Exception as e:
		print e
		return {"status":0, "msg":"Could not subscribe the event"}
	return {"status":1, "msg":"Successfully subscribed the event"}


# user unsubscribe from an event.
@route('/<uid>/removeevent/<eid>', method="GET")
def user_unsubscribes_event(uid, eid):
	try:
		db.chevent.event.update({"_id" : ObjectId(eid)},{"$pull" : {"user":uid}})
		db.chevent.user.update({"uid" : uid}, {"$pull" : {"event":ObjectId(eid)}})
	except Exception as e:
		print e
		return {"status":0, "msg":"Could not subscribe the event"}
	return {"status":1, "msg":"Successfully subscribed the event"}

############################################################################
#Rating stuffs
############################################################################
@route('/<uid>/rateevent/<eid>/<rating>', method="GET")
def user_rates_event(uid, eid, rating):
	try:
		db.chevent.rating.update({'uid':uid, 'eid':eid},{'uid':uid, 'eid':eid, 'rating':rating}, upsert=True)
	except Exception as e:
		print e
		return {"status":0 , "msg":"Could not rate the event. Try again"}
	return {"status":1, "msg":"Successfully subscribed the event"}



