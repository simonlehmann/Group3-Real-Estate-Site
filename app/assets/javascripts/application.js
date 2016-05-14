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
//= require jquery.turbolinks
//= require jquery_ujs
//
// Required for Papercrop
//= require jquery.jcrop
//= require papercrop
//
// Base files (global javascript)
//= require base/global
//= require base/map
//= require base/nav
//= require base/user_login
//
// Buy Page specific files
//= require pages/buy/buy
// Geocoding for header
//= require pages/buy/geolocate
//= require pages/buy/criteria
//
// Sell Page specific files
//= require pages/sell/sell_main
//= require pages/sell/add_edit
//= require pages/sell/status_modals
//= require pages/sell/infinite_scroll
//
// Search Page specific files
//= require pages/search/search
//
// Property Page specific files
//= require pages/property/property
//
// Dashboard Page specific files 
//= require pages/dashboard/dashboard
//
// Contact Page specific files
//= require pages/contact/contact
//
// Static Pages file
//= require pages/static/static_pages
//
// Loads all Semantic javascripts
//= require semantic-ui
//
// Load Bower Packages (note, if we want to support old browser we should add pickadate/legacy to this list)
// Load Bower Package = DateTime Picker
//= require pickadate/lib/picker
//= require pickadate/lib/picker.date
//= require pickadate/lib/picker.time
//
// Load Bower Package = Slick-Carousel
//= require slick-carousel/slick/slick
//
// Load Bower Package = Slick-Lightbox
//= require slick-lightbox/dist/slick-lightbox.min
//
// Infinite Scolling/Pagination using Jquery
//= require jquery.infinite-pages
//
// To Top Button
//= require base/to-top-button
//
// Moved turbolinks to bottom as suggested by jquery-turbolinks gem
//= require turbolinks
