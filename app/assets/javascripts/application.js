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
//= require turbolinks
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

/*
 * Tooltips
 */
$(document).on('turbolinks:load', function() {
    $('[data-toggle="tooltip"]').tooltip();
});

/*
 * Enhanced select fields
 */
$(document).on('turbolinks:load', function() {
    if($('[data-choices]').length > 0) {
        new Choices('[data-choices]', {shouldSort: false});
    }
});

/*
 * Autosize for textareas
 */
$(document).on('turbolinks:load', function() {
  autosize($('textarea[data-autosize]'));
})

/*
 * Range sliders for sensor conditions
 */
$(document).on('turbolinks:load', function() {
    $('.range').each(function() {
        var $elm = $(this);

        $elm.range({
            valueFormatter: function(value) {
                return value + ' ' + $elm.data('unit')
            }
        });
    });

    $('.trigger-conditions').on('cocoon:before-insert', function(e, item) {
        var $item = $(item);

        $item.find('.range').range();
    });

    $(document).on('change', 'select.choose_sensor', function(e) {
        var $select = $(e.target);
        var $fields = $select.parents('.nested-fields');

        var options = $select.find('option:selected').data();

        $fields.find('.range').data('range').reinit({
            min: options.rangeMin,
            max: options.rangeMax,
            step: options.rangeStep,
            valueFormatter: function(value) {
                return value + ' ' + options.rangeUnit;
            }
        });

    });
});

/*
 * Text editors for text components
 */
$(document).on('turbolinks:load', function() {
    $('.text-editor').editor();

    $('.links').on('cocoon:after-insert', function(e, item) {
        $(item).find('.text-editor').editor();
        autosize($('textarea[data-autosize]'));
    });
});

/*
 * Accordion forms for text components
 */
$(document).on('turbolinks:load', function() {
    $('.form').form();
});

/*
 * Select fields used as dropdowns
 */
$(document).on('turbolinks:load', function() {
    $('.nav-select').on('change', function() {
        Turbolinks.visit($(this).val());
    });
});