# stuffs to do

* design schema for user, organizer, events, rating
* design rest api for accesing required data
* design the storyboard in the iOS
* find about modules like google map, async operations in swift


## Schema of Entities Involved

### User Schema

Name of column|Type of column
--------------|--------------
username | String(Unique)
email | String
password | hash String
phone | String
fname | String
lname | String
event | [ObjectID_Event_1, ObjectID_Event_2, ObjectID_Event_3]

### Organization Schema

Name of column|Type of column
--------------|--------------
organization_name | String(Unique)
email | String
password | hash String
phone | String


### Event Schema

Name of column|Type of column
--------------|--------------
time | int
name | String
location | String
tag | [String_1, String_2]
organizer | ObjectID_organization
subscribed_users | [ObjectID_User1, ObjectID_User2, ObjectID_User3 ]

### Rating Schema

Name of column|Type of column
--------------|--------------
event | ObjectID_Event
map | dictionary(ObjectID_User1 : Integer, ObjectID_User2 : Integer)


## Examples of Entities
##### User Example

```json
{
    "username" : "bidhya",
    "phone" : 2561234123,
    "email" : "asdf@asd.com"
    "password" : "SOME_HASH_HERE",
    "fname" : "Bidhya",
    "lname" : "Sharma",
    "event" : [ObjectId("57c099afc51c0e51a0051751"), ObjectId("some_other_id")],
    "_id" : ObjectId("some_id_of_user") 
}
```

##### Organizer Example

```json
{
    "username" : "UAH Chargers",
    "phone" : 1234567890,
    "email" : "dsaf@dsaf.com"
    "password" : "SOME_HASH_HERE",
    "_id" : ObjectId("some_id_of_organizer") 
}
```

##### Event Example

```json
{
    "time" : 1472240387,
    "name" : "Event from UAH Chargers",
    "location" : "301 Sparkman Drive",
    "tag" : ["free_food", "sports"],
    "organizer" : ObjectId("some_id_of_organizer"),
    "subscribed_users" : [ObjectId("some_id_of_user_1"), ObjectId("some_id_of_user_2")],
    "_id" : ObjectId("some_id_of_event") 
}
```

##### Rating Example

```json
{
    "event" : ObjectId("some_id_of_event"),
    "_id" : ObjectId("some_id_of_map"),
    "map" : {
    ObjectId("some_id_of_user_1") : 3,
    ObjectId("some_id_of_user_2") : 8,
    ObjectId("some_id_of_user_3") : 7,
    }
}
```