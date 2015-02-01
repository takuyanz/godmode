$(document).ready(function(e){
  // onload
  var message_offset = 0;

  if ($(".message-box-height").length > 0) {
    $('.message-box-height').scrollTop($('.message-box-height')[0].scrollHeight);
  }

  // webscokect rails
  var ws_rails = new WebSocketRails(location.host + "/websocket");

  ws_rails.bind("print_seen", function(seen_data){
    var data = JSON.parse(seen_data);
   
    if($("#messaging_with").length > 0) {
      if($("#messaging_with").text() === data.user_nickname) {
        $("#message_seen_status").append("<p class='seen-status-style'>" + data.seen_message + "</p>");
        $('.message-box-height').scrollTop($('.message-box-height')[0].scrollHeight);
      }
    };
  });

  ws_rails.bind("websocket_message_to_current_user", function(message_data){
    $("#message_seen_status").children().remove();
    var data = JSON.parse(message_data);
    show_message(data);
  });

  ws_rails.bind("websocket_message_to_other_user", function(message_data){
    $("#message_seen_status").children().remove();
    var data = JSON.parse(message_data);
    if($("#messaging_with").length > 0) {
      if($("#messaging_with").text() === data.nickname) {
        show_message(data);
      }
    }
  });

  ws_rails.bind("offset_count_up", function(_){
    message_offset = message_offset + 1;
  });

  var show_message = function(data) {
    var div = document.createElement("div");
    div.className = "table-message";
    $(div).attr("message_id", data.message_id);

    var a = document.createElement("a");
    $(a).attr("href", "/users/" + data.nickname);

    var image = document.createElement("img");
    image.className = "message-image";
    $(image).attr("src", data.image_url);
    $(image).attr("alt", "Default profile 2 normal");
    
    a.appendChild(image);
    div.appendChild(a);

    var div_message = document.createElement("div");
    div_message.className = "message-content-box";

    var p_nickname = document.createElement("p");
    p_nickname.className = "message-nickname";

    var a_nickname = document.createElement("a");
    $(a_nickname).attr("href", "/users/" + data.nickname);
    var nickname_text = document.createTextNode(data.nickname);
    a_nickname.appendChild(nickname_text);

    var span_created_at = document.createElement("span");
    span_created_at.className = "message-created-at";
    span_created_at.appendChild(document.createTextNode(data.created_at));
     
    p_nickname.appendChild(a_nickname);
    p_nickname.appendChild(span_created_at);
    div_message.appendChild(p_nickname);

    var p_message = document.createElement("p");
    p_message.className = "message-text";
    if (data.message === '<span class="glyphicon glyphicon-thumbs-up"></span>') {
      var thumb_up = $.parseHTML(data.message);
      $(p_message).html(thumb_up);
    } else {
      var message_text = document.createTextNode(data.message);
      p_message.appendChild(message_text);
    }

    div_message.appendChild(p_message);
    div.appendChild(div_message);
    $(".message-show-box").append(div);
    $('.message-box-height').scrollTop($('.message-box-height')[0].scrollHeight);
  }
  
  var search_chattable_users = function(search_keywords){
    $.ajax({
      url      : "/messages/search_user",
      type     : "GET",
      data     : { search_keywords: search_keywords },
      datatype : "html"
    }).done(function(data){
      $("#search_user_result").html(data);
      $("#search_user_result").removeClass("hide");
      $('[data-toggle="tooltip"]').tooltip();
    });
  }

  // show avalible users to chat with
  $(document).on("focus", "#search_user", function(e){
    $("#search_user").unbind().bind().keydown(function(e){
      setTimeout(function(){
        var search_keywords = $("#search_user").val();
        var kw_length = search_keywords.length;

        if (kw_length == 0) {
          $("#search_user_result").addClass("hide");
        } else {
          search_chattable_users(search_keywords);
        }
      }, 1);
    });
  });

  if($("#search_user").size() === 1) {
    if ($("#search_user").val().trim() != "") {
      var search_keywords = $("#search_user").val().trim();;
      search_chattable_users(search_keywords);
    }
  }

  // start messaging by using pjax
  $(document).on("click", "a.message-pjax", function(e){
    message_offset = 0;
    var container = $("#message");
    $.pjax.click(e, {
      container: container,
      timeout: 4000 
    })
  });

  $(document).on("pjax:success", function(e){
    $('.message-box-height').scrollTop($('.message-box-height')[0].scrollHeight);
  });


  $(document).on("click", "#submit_message", function(e){
    $("#message_seen_status").children().remove();
    var message_to_id = $(this).attr("message_to_id");
    var message_text = $("#message_textarea").val();
    
    $("#message_textarea").val('');
    
    post_message(message_to_id, message_text);
  });

  // send a thumn up
  $(document).on("click", "#thumb_up", function(e){
    var thumb_up = $(this).html().trim();
    var message_to_id = current_message_to_id();
    
    post_message(message_to_id, thumb_up);
  });

  var post_message = function(message_to_id, message_text){
    $.ajax({
      url      : "/messages",
      type     : "POST",
      dataType : "html",
      data     : {
        message_to_id: message_to_id,
        message_text : message_text
      }
    });
  }

  // starting user
  $(document).on("click", ".star", function(e){
    var star = $(this);
    var stared_user_id = $(this).attr("user_id");
    
    $.ajax({
      url      : "/clips/switch",
      type     : "POST",
      dataType : "text",
      data     : { stared_user_id: stared_user_id}
    }).done(function(data){
      star.parent().parent().addClass("hide-user");
    }).fail(function(xhr, status, errorThrown){
    });
  });

  $(document).on("click", ".star", function(e){
    $.ajax({
      url      : "/messages/show_clipped",
      type     : "GET",
      dataType : "html"
    }).done(function(data){
      $("#clipped_users").html(data);
      $('[data-toggle="tooltip"]').tooltip();
    });
  });

  // Scoll focus at the bottom when load
  // TODO do this on lod of ajax or query... 

  $(document).on("click", "#message", function(e){
    var message_last_id = $(".table-message:last").attr("message_id");

    $.ajax({
      url       : "/messages/mark_seen",
      type      : "GET",
      data      : {message_id: message_last_id}
    });
  });

  $(document).on("keypress", function(e){
    if (e.which == 13 && $("#message_textarea").is(":focus") && $("#submit_by_enter").is(":checked")) { 
       e.preventDefault();
       if (!($("#message_textarea").val().trim().length === 0)) {
          $("#submit_message").trigger("click");
       }
    }
  });

  $(document).on("click", "#show_more_messages", function(e){
    message_offset = message_offset + 20;
    var message_with = $("#messaging_with").text();
    console.log(message_with);
    console.log(message_offset);
    $.ajax({
      url     : "/messages/load_more_messages",
      type    : "GET",
      data    : {
        offset: message_offset,
        message_with: message_with
      }
    }).done(function(data){
      //TODO does not work perfect
      var last_message = $(".table-message:first");
      $(".message-show-box").prepend(data);
      $('.message-box-height').scrollTop( $(last_message).offset().top );
      if ($(".no-messages-to-show").length > 0) {
        $("#show_more_messages").hide();
      }
      
    });
  });

  var current_message_to_id = function(e){
    return $("#submit_message").attr("message_to_id");
  }

});
