$(document).ready(function(e){

  var ws_rails = new WebSocketRails(location.host + "/websocket");

  ws_rails.bind("notification", function(data){
    $(".glyphicon-globe").css("color", "white");
    notification_li = create_notification_dom(data);
    display_notifications(notification_li);
  })

  var create_notification_dom = function(data) {

    var nf_data = JSON.parse(data);
    var li_ary = [];

    if (nf_data.length === 0) {
      var li = document.createElement("li");
      li.className = "notification-li";
      $(li).attr("role", "presentation");
      $(li).css("margin-left", "20px");
      li.appendChild(document.createTextNode("No Notifications to Show"));
      li_ary.push(li);

      return li_ary;
    } else {

      // do each
      $.each(nf_data, function(i, data){
        var li = document.createElement("li");
        li.className = "notification-li";
        $(li).attr("role", "presentation");

        var a = document.createElement("a");
        $(a).attr("tabindex", "-1");
        a.className = "notification-link";
        $(a).attr("href", data.link_to);

        var row_div = document.createElement("div");
        row_div.className = "row";

        var col_2_div = document.createElement("div");
        col_2_div.className = "col-md-2";
        
        var image = document.createElement("img");
        $(image).attr("src", data.image_url);
        $(image).attr("alt", "Default profile 2 normal");
        image.className = "notification-img";

        var col_10_div = document.createElement("div");
        col_10_div.className = "col-md-10 nf-msg-padding";

        var span = document.createElement("span");
        span.appendChild(document.createTextNode(data.nf_msg));

        col_2_div.appendChild(image);
        col_10_div.appendChild(span);

        row_div.appendChild(col_2_div);
        row_div.appendChild(col_10_div);

        a.appendChild(row_div);
        li.appendChild(a);

        li_ary.push(li);
      });

      return li_ary;
    }
  }

  var display_notifications = function(notification_lis){

    $.each($(notification_lis).get().reverse(), function(i, notification_li){
      $("#notification_box>li:first").after(notification_li);
    });
    while ($(".notification-li").length > 5) { $(".notification-li:last").remove();}

  }

  $(document).on("click", ".show-notifications", function(e){
    $(".notification-li").remove();
    $("#notification_box>li:first").after("<li class='notification-li' role='presentation'><a><img src='/assets/loading.gif'> loading..</a></li>");

    $.ajax({
      url      : "/notifications",
      type     : "GET",
      dataType : "html"
    }).done(function(data){
      $(".notification-li").remove();
      notification_lis = create_notification_dom(data);

      display_notifications(notification_lis);
    });
  });

});
