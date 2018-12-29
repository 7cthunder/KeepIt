export const time2String = function (time) {
  var t = new Date(parseInt(time * 1000))
  
  var hour = t.getHours()
  var minute = t.getMinutes()
  if (hour < 10) hour = '0' + hour
  if (minute < 10) minute = '0' + minute
  return hour + ':' + minute
}

export const string2Time = function (str) {
  var time = str.split(':')
  var hour = parseInt(time[0])
  var minute = parseInt(time[1])
  var newTime = new Date()
  newTime.setHours(hour)
  newTime.setMinutes(minute)
  return Math.round(newTime / 1000)
}