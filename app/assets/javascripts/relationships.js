$(document).ready(function(){
  
  $(document).on('click', '.switch-follow', function(e){
    var other_user_id = $(this).attr("user_id");
    var button_text = $(this).text();

    if (button_text.replace(/\s+/g, "") == "Follow") {
      text = "Unfollow";
    } else {
      text = "Follow";
    }

    $(this).text(text);
    
    $.ajax({
      url      : "/relationships/" + other_user_id,
      type     : "PATCH",
      dataType : "json"
    }).done(function(data){
    });
  });

});
