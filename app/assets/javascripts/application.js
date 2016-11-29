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



	$(".slider-temperature").slider({
		formatter: function(value) {
			return value + ' °C';
		}	
	});

	$(".slider-minutes").slider({
		formatter: function(value) {
			return value + ' min';
		}	
	});


	$(".slider-time-range").slider({
	    min: 0,
		max: 1439,
		range: true,
		step: 15,
		tooltip_split: true,
		ticks_tooltip: true,
		tooltip: 'always',
		formatter: function(value) {
			//idea to prevent displaying unformatted value
			//showTip($(".slider-time-range"));
			return minutesToTime(value);
		}	
	});

	var showTipVar = false
	function showTip(elem){
		if( showTipVar ){ return; }
		$(".slider-time-range").prev(".slider").find(".tooltip").show();
		showTipVar = true;
	}

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
	$('#slider-time-range').slider().on('slide', slideTime).data('slider');

	function slideTime(event, ui){
	    var val0 = $("#slider-time-range").slider("values", 0), getAttribute
	        val1 = $("#slider-time-range").slider("values", 1),
	        minutes = parseInt(val0 % 60, 10),
	        hours = parseInt(val0 / 60 % 24, 10),
	        minutes1 = parseInt(val1 % 60, 10),
	        hours1 = parseInt(val1 / 60 % 24, 10);
	    startTime = getTime(hours, minutes);
	    endTime = getTime(hours1, minutes1);
	    $("#slider-time-range .tooltip-min").text(startTime + ' - ' + endTime);
	}
	function getTime(hours, minutes) {
	    var time = null;
	    minutes = minutes + "";
	    if (hours < 12) {
	        time = "AM";
	    }
	    else {
	        time = "PM";
	    }
	    if (hours == 0) {
	        hours = 12;
	    }
	    if (hours > 12) {
	        hours = hours - 12;
	    }
	    if (minutes.length == 1) {
	        minutes = "0" + minutes;
	    }
	    return hours + ":" + minutes + " " + time;
	}
	slideTime();		
	*/

});