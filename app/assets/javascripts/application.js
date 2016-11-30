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
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require cocoon
//= require bootstrap-slider
//= require bootstrap-select

jQuery(document).ready(function($) {


	var sliderTemperature = $(".slider-temperature").slider({
		formatter: function(value) {
			return value + ' °C';
		}	
	});
	sliderTemperature.slider('setValue',[33,66]);


	var sliderMinutes = $(".slider-minutes").slider({
		formatter: function(value) {
			return value + ' min';
		}	
	});
	sliderMinutes.slider('setValue',6);


	var sliderTimeRange = $(".slider-time-range").slider({
	    min: 0,
		max: 1439,
		range: true,
		step: 5,
		tooltip_split: true,
		ticks_tooltip: true,
		tooltip: 'always',
		formatter: function(value) {
			return minutesToTime(value);
		}	
	});
	sliderTimeRange.slider('setValue',[480,1020]);


	function minutesToTime(value){
		minutes = parseInt(value % 60, 10),
    	hours = parseInt(value / 60 % 24, 10);
    	if( minutes < 10){
    		minutes = '0' + minutes;
    	}
    	if( hours < 10){
    		hours = '0' + hours;
    	}
		return hours + ':' + minutes;
	}

/*

	example multi select pattern

*/

	$('.form-group#trigger2').addClass('hidden');	
	$('.add-trigger').addClass('hidden');

	setTimeout(function(){

		$('*[data-id="weather"]').parent().addClass('hidden');
		//$('*[data-id="triggertype"]').siblings().find('.selectpicker').on('change', function(){
		$('.selectpicker').on('change', function(){
			$('*[data-id="weather"]').parent().removeClass('hidden');
			$('*[data-id="neutral"]').parent().addClass('hidden');

			$('.add-trigger').removeClass('hidden');
			$('.add-trigger').click(function(event) {
				$('.form-group#trigger2').removeClass('hidden');
				$('.add-trigger').addClass('hidden');
			});
		});

	}, 2000);
	

	

});