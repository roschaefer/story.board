// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs

//= require popper
//= require bootstrap-sprockets
//= require cocoon

//= require autosize
//= require choices
//= require multirange

//= require_tree .

//= require components/form
//= require components/editor

$(function() {
    autosize($('.field textarea'));
    autosize.update($('.field textarea'));
});

$(function() {
    if($('[data-choices]').length > 0) {
        new Choices('[data-choices]', {shouldSort: false});
    }
});

$(function() {
    $('.range').range();

    $('.trigger-conditions').on('cocoon:before-insert', function(e, item) {
        $(item).find('.range').range();
    });
});

$(function() {
    $('.modal .text-editor').editor();

    $('.qa').on('cocoon:after-insert', function(e, item) {
        $(item).find('.text-editor').editor();
    });
});