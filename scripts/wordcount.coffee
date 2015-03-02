# Description:
#   Lifebot is responsible for calculating previous day's entries wordcount in an organization signed up on Andelife
#
# Dependencies:
#   qs
#
# Configuration:
#   None
#
# Commands:
#   lifebot fetch wordcount - Retrieves all the entries written in Andelife for the previous day and tells you the total wordcount.
#
# Author:
#   Andela

Qs = require('qs');

module.exports = (robot) ->
  robot.router.post "/entries/:room", (req, res) ->
    robotWorker req, res, robot

  robot.respond "/fetch .* wordcount/", (msg)->
    req = {body: []}
    msg.http("http://life.andela.co/send-ms-wordcount/slack")
      .get() (err, res, data) ->
        req.body.allEntries = data
        req.params = {room:""}
        robotWorker req, res, msg

# Function to remove all spaces and linebreaks and replace with commas then
# split the post and return the length of all the words in the entry
wordCount = (entry) ->
  return unless entry

  entry = entry.replace(/\s+/g, " ").split(" ")
  entry.length

# Loop through the array of objects received, 
# calculate wordcount and post to organisation webhook endpoint
robotWorker = (req, res, robot) ->
  allUsers = JSON.parse req.body.allEntries if req.body.allEntries
  console.log allUsers, "all Users"
  totalCount = 0
  for user in allUsers
    sum = 0
    user.entries.map (entry) ->
      sum += wordCount entry
      
    totalCount += sum
    
    measure = {}
    measure["user_id"] = user.uid
    measure["value"] = sum  
    measure["metric_id"] = user.metric
    measure["organization_id"] = user.org

    data = measure
    console.log user, "user"
    if !!user.orgSettings
      if user.orgSettings.state
        robot.http(user.orgSettings.url)
          .headers('Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': data.length)
          .post(Qs.stringify measure: data) (err, res, data) ->
            if err
              console.log err
            console.log res.statusCode, data, "status code and data"
      else
        console.log "Microservice settings is off"
    else
      console.log "No settings found!"

  message = "Andela wrote #{totalCount} words yesterday on Andelife."
  room = req.params.room if req.params.room
  console.log room
  if room == 'general'
    robot.messageRoom room, message
  else 
    robot.send message
  if(res.end)
    res.end '\nThanks for your entries\n'