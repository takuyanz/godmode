// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.pjax
//= require bootstrap.min
//= require dropdowns-enhancement.js
//= require_tree .
//= require leanModal.min
//= require jquery.noty.packaged.min
//= require websocket_rails/main


$(document).ready(function(){

  $("img.picture-timeline").hide();

  // Lean Modal for zooming in pictures
  $('img[rel*=leanModal]').leanModal({
    top:70,
    overlay:0.5
  });

  // Lean Modal for Story Modal
  $('span[rel*=leanModal]').leanModal({
    top:100,
    overlay:0.5,
    closeButton: '.modal_close'
  });

  $('a[rel*=leanModal]').leanModal({
    top:100,
    overlay:0.5,
    closeButton: '.modal_close'
  });

  $('button[rel*=leanModal]').leanModal({
    top:100,
    overlay:0.5,
    closeButton: '.modal_close'
  });
 
  // Tooltip for nums of hearts
  $('[data-toggle="tooltip"]').tooltip();

  // Popover for popover comment
  $('[data-toggle="popover"]').popover();

  $(document).on("click", ".search", function(e){
    var search_keyword = $(".search-input").val().trim();
    if (search_keyword.length === 0) {
      e.preventDefault();
    } else {
      return true; 
    }
  });

  var header = $('#headerArea'),
  headerHeight = header.height(),
  treshold = 0,
  lastScroll = 0;

  $(document).on('scroll', function (evt) {
    var newScroll = $(document).scrollTop();

    if (newScroll < 0) {
      header.css('top', 0);
      lastScroll = 0;
      return;
    }
    var diff = newScroll-lastScroll;

    // normalize treshold range
    treshold = (treshold+diff>headerHeight) ? headerHeight : treshold+diff;
    treshold = (treshold < 0) ? 0 : treshold;

    header.css('top', (-treshold)+'px');

    lastScroll = newScroll;
  });

  
  $(document).on("click", "#upload_albums_button", function(e){
    var text_length = ($("#album_title_input").val().trim()).length;
    var file_num = $("#pictures_to_upload")[0].files.length;
    var errors = new Array();

    if (text_length > 20) {
      errors.push("Title needs to be less than 20 characters");
    }
    if (text_length == 0) {
      errors.push("Please write a title");
    }
    if (file_num > 3) {
      errors.push("No more than three pictures can be uploaded per album");
    }
    if (file_num == 0) {
      errors.push("Please select at least one picture");
    }

    if (errors.length > 0) {
      $(".error-upload").empty();
      $.each(errors, function(i, error){
        $(".error-upload").append("<p>" + error + "</p>");
      });
      return false;
    } else {
      $(".error-upload").empty();
      $("#upload_albums_button").after("<p>Uploading...</p>");
      $("#upload_albums_button").hide();
      return true;
    }
  }); 

  $(document).on("click", ".glyphicon-globe", function(e){
    $(this).css("color", "#1b5f36");
  });
    

});

