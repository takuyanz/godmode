
$(document).ready(function(e) {

  var ws_rails = new WebSocketRails(location.host + "/websocket");
   
  var offset_num = 0;
  var new_event_num = 0;
  ws_rails.bind("new_event", function(data){
    new_event_num = new_event_num + data;
    offset_num = offset_num + 1;
    $("#new_events").html("<span>" + new_event_num +" more posts</span>");
  });

  $(document).on("click", "#load_more", function(e){
    offset_num = offset_num + 5;
    $.ajax({
      url     : "/events",
      data    : {offset_num: offset_num},
      type    : "GET",
      dataType: "html"
    }).done(function(data){
      $("#events_box").append($(data).fadeIn(1500));
      
      // after ajax jquery wont work
      // this needs to be improved by creating functions maybe-later

      // zooming image
      $('img[rel*=leanModal]').leanModal({
        top:70,
        overlay:0.5
      });

      // modaling story
      $('a[rel*=leanModal]').leanModal({
        top:100,
        overlay:0.5,
        closeButton: '.modal_close'
      });

      // showing heart
      $('[data-toggle="tooltip"]').tooltip();
      
      // popover comment
      $('[data-toggle="popover"]').popover();

      if ($("#no_more_events").length > 0) {
        $("#load_more").css("display", "none");
      }

    });
  });

  $(document).on("click", "#reload", function(e){
    $("#new_events").empty();
    offset_num = 0; 
    new_event_num = 0;
    $.ajax({
      url     : "/events",
      data    : {offset_num: offset_num},
      type    : "GET",
      dataType: "html"
    }).done(function(data){
      $("#events_box").html($(data).fadeIn(1500));

       $("#load_more").show();

      // zooming image
      $('img[rel*=leanModal]').leanModal({
        top:70,
        overlay:0.5
      });

      // modaling story
      $('a[rel*=leanModal]').leanModal({
        top:100,
        overlay:0.5,
        closeButton: '.modal_close'
      });

      $('span[rel*=leanModal]').leanModal({
        top:100,
        overlay:0.5,
        closeButton: '.modal_close'
      });

      // showing heart
      $('[data-toggle="tooltip"]').tooltip();
      
      // popover comment
      $('[data-toggle="popover"]').popover();

    });
  });
})
