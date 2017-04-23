// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var ready;
ready = function() {
  $('.resi-answer').hide();
  $('.resi-question').click(function(){
    $(this).hide();
    $(".resi-answer[data-resi='"+ $(this).attr('data-resi') +"']").show();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
