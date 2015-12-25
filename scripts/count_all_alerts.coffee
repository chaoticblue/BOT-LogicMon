# hubot greeting.
#
# (hi|hello) - say hi to your butler

# To define global variables we need to instantiate
# an instance and then create a function equal to our text.
# The first line is creating the instance with name 'global'
# The subsequent lines are functions in that class equal to text.

# These are variables that are used throughout. You very well could make the URL a variable too
# Work in progress. Testing only. Hence the password info in the script.
exports = this
exports.account = ""
exports.user = ""
exports.pass = ""
exports.creds = "c=#{exports.account}&u=#{exports.user}&p=#{exports.pass}"

module.exports = (robot) ->
  robot.respond /\bcount all alerts\b/i, (msg) ->
    msg.reply "Asking the captain! HOLD ON!"
    msg
      .http("https://superawesomecompany.logicmonitor.com/santaba/rpc/getAlerts?&type=alert&#{exports.creds}")
      .get() (err, res, body) ->
        result = JSON.parse(body)
        data = result["data"]
        total = data["total"]
        msg.reply "There are a total of #{total} alerts."
        if (total == 0)
          msg.reply "NO ALERTS! Our lives are safe! Good work!"
        else if (total >= 100)
          msg.reply "OH MY GOD! We have #{total} alerts?! Hook is steaming!"