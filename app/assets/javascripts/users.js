$(document).ready(function(){

  $(document).on('click', '.a-tag', function(e){
    e.preventDefault();
  });

  $(document).on('dblclick', '#add_bio', function(e){
    default_bio = $(this).attr('default_bio');
    
    if (default_bio == "1") {
      var old_bio = "";
    } else {
      var old_bio = $(this).text();
    }
    $(this).html("<input type='text' id='update-bio' onfocus='this.value = this.value;' class='bio-input-style' value='" + old_bio + "'>");
    $('#update-bio').focus();
    var update_user_id = current_page_user_id();

    $('#update-bio').keypress(function(e){
      if (e.which == 13) {
        var short_bio = ($('#update-bio').val()).trim();
        var bio_status = null
        if (!short_bio) {short_bio = null; var bio_status = "default_bio"}

        $.ajax({
          url      : '/users/' + update_user_id,
          data     : {short_bio: short_bio},
          type     : 'PATCH',
          dataType : 'text'
        }).done(function(data){
          if (bio_status == "default_bio") {
            var default_bio_status = "1";
          } else {
            var default_bio_status = "0";
          }
          $('#add_bio').text(data);
          $('#add_bio').attr('default_bio', default_bio_status);
        });
      }
    });
  });

  var user_album_offset_num = 0;
  $(document).on("click", "#load_more_albums", function(e){
    user_album_offset_num = user_album_offset_num + 5;
    var user_id = current_page_user_id();

    $.ajax({
      url         : "/users/load_more_albums",
      type        : "GET",
      dataType    : "html",
      data        : {
        offset_num: user_album_offset_num,
        user_id   : user_id
      }
    }).done(function(data){
      $("#user_all_albums").append($(data).fadeIn(1500));

      //#TODO
      // after ajax jquery wont work
      // this needs to be improved by creating functions maybe-later

      // zooming image
      $('img[rel*=leanModal]').leanModal({
        top:70,
        overlay:0.5
      });

      // modaling story
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

      // showing heart
      $('[data-toggle="tooltip"]').tooltip();
      
      // popover comment
      $('[data-toggle="popover"]').popover();

      if ($("#no_more_albums").length > 0) {
        $("#load_more_albums").css("display", "none");
      }

    });
  });

  var current_page_user_id = function(e){
    return $('#current_page_user_id').attr('user_id');
  }
});
