module.exports = (robot) ->
  robot.hear /badger/i, (msg) ->
    msg.send "Badgers? BADGERS? We don't need no stinkin badgers"

  robot.respond /ladi dadi/i, (msg) ->
    msg.reply "We like to party."

  robot.hear /I like pie/i, (msg) ->
    msg.emote "Makes a freshly baked pie"

   robot.respond /(.*) welcome/i, (msg) ->
    resType = msg.match[1]
    if resType is "friend"
      msg.reply "Thank you so much"
    else
      msg.reply "Ohh #{resType}"

  robot.router.post '/hubot/:room', (req, res) ->
    

  robot.router.post '/hubot/:room', (req, res) ->
    room = req.params.room
    # data = JSON.parse req.body
    # secret = data.secret
    robot.messageRoom room, "Ohh, after 3 hours"
    res.send 'OK'


  robot.router.post '/hubot/:room', (req, res) ->
    # room   = req.params.room
    # data   = JSON.parse req.body.payload
    # secret = data.secret

    # robot.messageRoom "#ahhlife-team", "I have a secret"
    res.send 'OK'

  robot.router.get "/hubot", (req, res) ->
    room = "#ahhlife-team"
    message = "Testing the GET method"
    # robot.messageRoom room, message
    res.send 'OK'


  robot.router.post "/entry", (req, res) ->
    body = req.body
    entries = body.entry
    robot.logger.info entries

    res.send "Ok"


  robot.router.post "/hubot/say", (req, res) ->
    body = req.body
    room = body.room
    message = body.message
    array = body.array
    foods = ['broccoli', 'spinach', 'chocolate']
    for food in foods
      do (food) ->
        robot.logger.info  " why are you not showing #{food}"

    eat = time:20, period:"evening", call:"anytime"
    for child, time of eat
      robot.logger.info "#{child} is #{time}"


    # robot.logger.info "Message '#{message}' received for room #{room}"
    # robot.logger.info "The array guy #{array}"
    


    envelope = robot.brain.userForId 'broadcast'
    envelope.user = {}
    envelope.user.room = envelope.room = room if room
    envelope.user.type = body.type or 'groupchat'

    # if message
    #   robot.send envelope, message

    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks\n'

