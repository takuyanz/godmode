
$(document).ready(function(e){


  var search_albums_offset_num = 0;
  $(document).on("click", "#load_more_albums_search", function(e){
    search_albums_offset_num = search_albums_offset_num + 5;

    $.ajax({
      url         : "/search/load_more_albums",
      type        : "GET",
      dataType    : "html",
      data        : {
        offset_num: search_albums_offset_num
      }
    }).done(function(data){
      $(".search-result-album-box").append($(data).fadeIn(1500));

      //#TODO
      // after ajax jquery wont work
      // this needs to be improved by creating functions maybe-later

      // zooming image
      $('img[rel*=leanModal]').leanModal({
        top:70,
        overlay:0.5
      });

      $('span[rel*=leanModal]').leanModal({
        top:100,
        overlay:0.5,
        closeButton: '.modal_close'
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
      
      if ($("#no_more_albums").length > 0) {
        $("#load_more_albums_search").css("display", "none");
      }
    });
  });

  var search_users_offset_num = 0;
  $(document).on("click", "#load_more_users_search", function(e){
    search_users_offset_num = search_users_offset_num + 5;
  
    $.ajax({
      url       : '/search/load_more_users',
      type      : "GET",
      dataType  : 'html',
      data      : {offset_num: search_users_offset_num}
    }).done(function(data) {
      $("#search_result_user_box").append($(data).fadeIn(1500));

      if ($("#no_user_found").length > 0) {
        $("#load_more_user_search").css("display", "none");
      }
    });
  });


});
