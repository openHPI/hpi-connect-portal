  $(function() {
    $("#csshack_header_image").width($("body").width()*3/4-20);
    $("div.container").first().css({
    "margin-left": ($("body").width()/8-10) + "px"
    });
    $("div.bigheader").css({
        "margin-left": ($("body").width()/8) + "px"
    });
    $("div.smallheader.headwrapper").css({
      width: $("body").width()*3/4 +"px",
      height: "148px"
    });
})
