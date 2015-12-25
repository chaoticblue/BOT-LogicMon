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
  robot.respond /\ball (.*) alerts\b/i, (msg) ->
    input = msg.match[1]
    input = input.toLowerCase()
    #msg.reply "#{input}"
    level = "null"
    switch input
      when "critical"
        #msg.reply "#{input}"
        level = input
        #msg.reply "#{level}"
      when "error"
        level = input
      when "warning"
        level = input
      else 
        msg.reply "Invalid input!\nValid Methods:\nWarning\nCritical\nError"
        return
    msg.reply "Fetching all #{level} alerts!"
    msg
      .http("https://superawesomecompany.logicmonitor.com/santaba/rpc/getAlerts?&type=alert&level=#{level}&#{exports.creds}")
      .get() (err, res, body) ->
        result = JSON.parse(body)
        data = result["data"]
        alerts = data["alerts"]
        total = data['total']
        msg.reply "There are a total of #{total} #{level} alerts.\nYou can find out more information by going to: https://superawesomecompany.logicmonitor.com/santaba/uiv3/alert/index.jsp"
        #counter = 0
        #while counter < total
        #  tempAlerts = "null"
        #  tempAlerts = alerts[counter]
        #  if (tempAlerts["__id__"] != null)
        #    metric = tempAlerts["dataSourceInstanceId"]
        #    link = "https://superawesomecompany.logicmonitor.com/santaba/uiv3/device/index.jsp#layer/i/#{metric}"
        #  else
        #    metric = tempAlerts["__id__"]
        #    link = "superawesomecompany.logicmonitor.com/santaba/uiv3/device/index.jsp#layer/s/#{metric}"
        #  msg.reply "The datasource is: #{tempAlerts.dataSource}\nThe level is: #{tempAlerts.level}\nThe thresholds are set to #{tempAlerts.thresholds} and the current value is #{tempAlerts.value}"
        #  counter += 1