# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

async = require('async');
require('dotenv').load();

module.exports = (robot) ->
  robot.respond /help/i, (res) ->
    res.send "```help- Displays help \nnew- Creates a new hangout link\nnew [slack_usernames]- Creates a new hangout link and sends the link to all slack usernames supplied. e.g new @kay @stephen```"

  robot.respond /new/i, (res) ->
    sender = res.envelope.user.name
    rand = new Date().getTime();
    list = formatText res.envelope.message.text;
    if list.indexOf(res.envelope.room) == -1
      list.push(res.envelope.room);

    feedback = if list.length > 1 then "this link has been sent to your invitees.\n" else ""

    if list.length > 0
      async.whilst (->
        list.length > 0
      ), ((callback) ->
        e = list.pop()
        res.envelope.room = e
        message = if sender == e  then "Below is the google hangout link, #{feedback}\n" else "`@#{sender} just sent you a google hangout invite`\n"
        res.send "#{message}https://plus.google.com/hangouts/_/#{process.env.ORG_NAME}/call#{rand}"
        setTimeout callback, 100
        return
      ), (err, n) ->
        #do nothing
        return

  formatText = (text) ->
    text = text.replace /@/g, ""
    textArray = text.split(' ')
    start = textArray.indexOf('new') + 1
    textArray.slice start, textArray.length
