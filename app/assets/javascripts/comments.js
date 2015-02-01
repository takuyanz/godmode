
$(document).ready(function(){

  // show all comments in Freetalk tab
  $(document).on('click', '.freetalk', function(){
    var user_id = current_page_user_id();

    $.ajax({
      url       : "/comments/" + user_id,
      type      : "GET",
      dataType  : "html"
    }).done(function(data){
      console.log("aa");
      $('div#freetalk').html(data);
      // popover comment
      $('[data-toggle="popover"]').popover();

      // modal comment delete
      $('span[rel*=leanModal]').leanModal({
        top:100,
        overlay:0.5,
        closeButton: '.modal_close'
      });

    }).fail(function(errorThrown){
    });
  });


  // creating a new comment that is submitted from free talk tab
  $(document).on('click', '#submit_freetalk_comment', function(e){
    var comment = $('#freetalk_input').val().trim();
    
    // error if none
    if (comment.length == 0){
    
    } else {
      user_id = current_page_user_id();  

      $.ajax({
        url       : "/comments",
        type      : "POST",
        dataType  : "html",
        data      : {
          user_id : user_id,
          comment: comment
        }
      }).done(function(data){
        $("#freetalk_input").val("");
        $("div.all-comments-box").prepend($(data).fadeIn("slow"));
        $('[data-toggle="popover"]').popover();
        $('span[rel*=leanModal]').leanModal({
          top:100,
          overlay:0.5,
          closeButton: '.modal_close'
        });

        if ($("#no-comment-message").length > 0) {
          $("#no-comment-message").remove();
        }
      });
    }
  });

  // create a new comment which goes into freetalk
  $(document).on('click', '#popover_comment_submit', function(e){
    var user_id = $(this).attr("user_id");
    var comment = $(this).parent().prev().text().trim();
    $('[data-toggle="popover"]').popover('hide');

    $.ajax({
      url       : "/comments",
      type      : "POST",
      data      : {
        user_id : user_id,
        comment : comment
      }
    });
  });

  // creating a reply to a certain comment
  $(document).on('click', '#popover_reply_submit', function(e){
    var comment_id = $(this).attr("comment_id");
    var reply = $(this).parent().prev().text().trim();
    $('[data-toggle="popover"]').popover('hide');

    $.ajax({
      url     : '/replies',
      type    : 'POST',
      data    : {
        comment_id: comment_id,
        reply: reply
      }
    }).done(function(data){
      $("#reply-box-for-" + comment_id).append(data);
    });
  });

  // show all replies
  $(document).on('click', '.show_more_replies', function(e){
    var comment_id = $(this).attr("comment_id");
    var reply_num = $(this).attr("reply_num");

    if ($("#all_replies_" + comment_id).css("display") == "block"){
      if (reply_num == "1") {
        var word = " reply";
      } else {
        var word = " replies";
      }
      $(this).text("show " + reply_num + word);
      $("#all_replies_" + comment_id).slideUp("slow");
    } else {
      $("#all_replies_" + comment_id).slideDown("slow");
      $(this).text("hide");
    }
  });

  $(document).on('click', '.delete-comment-button', function(e){
    var this_comment_id = $(this).parent().attr("comment_id");
    var comment_box = $(".comment-box-" + this_comment_id);
    comment_box.fadeOut("slow", function(e){comment_box.remove()});
    $("#lean_overlay").css("display", "none");

    $.ajax({
      url       : "/comments/" + this_comment_id,
      type      : "DELETE"
    }).done(function(e){
      //#TODO why 1 not 0?
      if($(".all-comments-box").children().length == 1) {
        $(".all-comments-box").append("<div id='no-comment-message' style='display: block'><div class='align-center no-events-to-show-padding'><span class='glyphicon glyphicon-pencil'></span><h4 class='no-comments-text'>No Comments</h4></div></div>");
      }
    });
  });

  var current_page_user_id = function(e){
    return $('#current_page_user_id').attr('user_id');
  }

});
