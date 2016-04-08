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
//= require turbolinks
//= require_tree .
//
// Loads all Semantic javascripts
//= require semantic-ui
<<<<<<< HEAD
$(document).ready(function() {
	//Declare variables/arrays etc
	var mapOptions = {
		zoom: 5,
		center: new google.maps.LatLng(37.09024, -100.712891)
	};

	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
});
=======
//
// Load Bower Packages (note, if we want to support old browser we should add pickadate/legacy to this list)
//= require pickadate/lib/picker
//= require pickadate/lib/picker.date
//= require pickadate/lib/picker.time
>>>>>>> 8edfb91573e38e15969eeb8437c0fd65ce1e1245
