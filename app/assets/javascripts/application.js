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
//= require_tree .
//= require cocoon
//= require bootstrap-slider
//= require bootstrap-select

jQuery(document).ready(function($) {

/*
	adding custom formatters to sliders

*/	
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

	Select Trigger color

*/
	$('.triggercolor li').click(function(){
		$(this).siblings().removeClass('active');
		$(this).addClass('active');
		console.log('Triggercolor selected')	
	});
	

});