
$(document).ready(function(){

  // chnage count of likes in database
  $(document).on("click", "#change_like", function(e){
    var album_heart = $(this)
    var album_id  = album_heart.parent().parent().attr("album_id");
    var total_likes = album_heart.attr("data-original-title");

     $.ajax({
      url       : "/likes/check_liked",
      data      : {album_id: album_id},
      type      : "GET",
      dataType  : "json"
    }).done(function(data){
      if(data == 1){
        total_likes--;
        album_heart.removeClass("liked");
      }else{
        total_likes++;
        album_heart.addClass("liked");
      }
      $(".tooltip-inner").text(total_likes);
      album_heart.attr("data-original-title", total_likes);

      change_likes(album_id, data);
    });
  });

  var change_likes = function(album_id, like_status) {

    $.ajax({
      url           : "/likes",
      data          : {
        album_id    : album_id,
        like_status : like_status,
      },
      type          : "POST",
      dataType      : "json"
    })
  }
  
  $(document).on("click", ".delete-album-button", function(e){
    var this_album_id = $(this).parent().attr("album_id");
    $("#album_box_" + this_album_id).fadeOut("slow");
    $("#lean_overlay").css("display", "none");

    $.ajax({
      url       : "/albums/" + this_album_id,
      type      : "DELETE"
    });
  });

  $(document).on("click", ".cancel-delete", function(e){
    $("#lean_overlay").trigger("click");
  })
    

  var current_page_user_id = function(e){
    return $('#current_page_user_id').attr('user_id');
  }
});

