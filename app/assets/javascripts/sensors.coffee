# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#sample_data_form').hide()
  $('#unhide_sample_data_form').on "click", ->
    $('#unhide_sample_data_form').hide()
    $('#sample_data_form').show()
