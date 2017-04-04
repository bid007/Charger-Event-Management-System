from bottle import route, template, request
from Models import *
# User create request
@route('/user/create',method= 'POST')
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
			return {"status" : 0, "msg" : "There is some error. Please try again later."}
	return {"status" : 1, "msg" : "Your username is created. Please proceed to login."}


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

@route('/user/<uid>')
def get_user_info(uid):
	print("here ")
	resUser = db.User.find_one({"uid":uid})
	resOrg = db.Organization.find_one({"uid":uid})
	if resUser:
		return {"status":1,	"name":resUser["fname"], "org": False, "id" : str(resUser["_id"])}
	elif resOrg:
		return {"status":1, "name":resOrg["name"], "org": True, "id" : str(resOrg["_id"])}
	else:
		return {"status":0, "msg":"The user doesnot exist"}

