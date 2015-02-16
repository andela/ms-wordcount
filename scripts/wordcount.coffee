module.exports = (robot) ->
  robot.router.post "/entries/:room", (req, res) ->
    allUsers = JSON.parse req.body.allEntries
    
    totalCount = 0
    wordCountArray = []

    # Function to remove all spaces and linebreaks and replace with commas then
    # split the post and return the length of all the words in the entry
    wordCount = (entry) ->
      return  unless entry

      entry = entry.replace(/\s+/g, " ").split(" ")
      entry.length

    for user in allUsers
      sum = 0
      # console.log user unless !user.entries.length
      user.entries.map (entry) ->
        sum += wordCount entry
        
      totalCount += sum
      
      userObject = {}
      userObject.uid = user.uid
      userObject.wordcount = sum  
      wordCountArray.push(userObject)

    console.log '\n', wordCountArray

    message = "The total wordcount for Andela users yesterday was #{totalCount} words."
    user = {}
    user.room = req.params.room if req.params.room
    robot.send user, message
    console.log 'Total = ' + totalCount
      
    
    res.end '\nThanks for your entries\n'