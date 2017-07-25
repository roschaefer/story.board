# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#sample_data_form').hide()
  $('#unhide_sample_data_form').on "click", ->
    $('#unhide_sample_data_form').hide()
    $('#sample_data_form').show()

  $('#sensor_reading_form').hide()
  $('#unhide_sensor_reading_form').on "click", ->
    $('#unhide_sensor_reading_form').hide()
    $('#sensor_reading_form').show()

  $('#sensor_reading_day, #sensor_reading_month, #sensor_reading_year, #sensor_reading_hour, #sensor_reading_minute, #sensor_reading_second').on "change", ->
    update_created_at()



update_created_at =  ->
  $('#sensor_reading_created_at').val($('#sensor_reading_year').val() + "-" + $('#sensor_reading_month').val() + "-" + $('#sensor_reading_day').val() + " " + $('#sensor_reading_hour').val() + ":" + $('#sensor_reading_minute').val() + ":" + $('#sensor_reading_second').val())

$(document).ready(ready)
$(document).on('page:load', ready)
