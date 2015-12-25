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
  robot.respond /\b(.*) health of host (.*)\b/i, (msg) ->
    host = msg.match[1]
    if (host.match("(.*).your.domain.com") == null)
      host = "#{host}.your.domain.com"
    msg.reply "Asking the captain! HOLD ON!"
    msg
      .http("https://superawesomecompany.logicmonitor.com/santaba/rpc/getAlerts?&type=alert&host=#{host}&#{exports.creds}")
      .get() (err, res, body) ->
        result = JSON.parse(body)
        data = result["data"]
        alerts = data["alerts"]
        total = data['total']
        if (total == 0)
          msg.reply "Looking good! No alerts!"
        else if ((total >= 1) && (total < 5))
          msg.reply "Looks like there are an alert or two. #{total} to be exact!"
        else if (total >= 5)
          msg.reply "Issues ahoy! Fix them before hook sees! #{total} alerts!"
          msg.reply "Hold on while I write up the list!"
        counter = 0
        while counter < total
          tempAlerts = "null"
          tempAlerts = alerts[counter]
          msg.reply "The datasource is: #{tempAlerts.dataSource}\nThe level is: #{tempAlerts.level}\nThe thresholds are set to #{tempAlerts.thresholds} and the current value is #{tempAlerts.value}"
          counter += 1