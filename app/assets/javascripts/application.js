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
//
// Base files (global javascript)
//= require base/global
//= require base/map
//= require base/nav
//= require base/user_login
//
// Buy Page specific files
//= require pages/buy/buy
//
// Sell Page specific files
//= require pages/sell/sell_main
//= require pages/sell/add_edit
//= require pages/sell/status_modals
//= require pages/sell/infinite_scroll
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
// Load Bower Package = Slick-Carousel
//= require slick-carousel/slick/slick
//
// Infinite Scolling/Pagination using Jquery
//= require jquery.infinite-pages
