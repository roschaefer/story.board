// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var ready;
ready = function() {
  $('.resi-answer').hide();
  $('.resi-question').hide();
  $('.resi-thread .resi-question:first-child').show();
  $('.resi-question').click(function(){
    $(this).hide();
    var nextAnswer = $(this).nextAll('.resi-answer').first();
    var nextButton = $(this).nextAll('.resi-question').first();
    nextButton.show();
    nextAnswer.show();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
