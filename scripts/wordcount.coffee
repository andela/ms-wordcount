Qs = require('qs');

module.exports = (robot) ->
  robot.router.post "/entries/:room", (req, res) ->
    allUsers = JSON.parse req.body.allEntries if req.body.allEntries
    
    totalCount = 0
    wordCountArray = []

    # Function to remove all spaces and linebreaks and replace with commas then
    # split the post and return the length of all the words in the entry
    wordCount = (entry) ->
      return unless entry

      entry = entry.replace(/\s+/g, " ").split(" ")
      entry.length

    for user in allUsers
      sum = 0
      console.log user unless !user.entries.length
      user.entries.map (entry) ->
        sum += wordCount entry
        
      totalCount += sum
      
      # console.log user
      measure = {}
      measure["user_id"] = user.uid
      measure["value"] = sum  
      measure["metric_id"] = user.metric
      measure["organization_id"] = user.org
      wordCountArray.push(measure)

      data = measure
      if !!user.orgSettings
        if user.orgSettings.state
          robot.http(user.orgSettings.url)
            .headers('Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': data.length)
            .post(Qs.stringify measure: data) (err, res, data) ->
              if err
                console.log err
              console.log data

    message = "Andela wrote #{totalCount} words yesterday on Andelife."
    user = {}
    user.room = req.params.room if req.params.room
    robot.send user, message
    
    res.end '\nThanks for your entries\n'