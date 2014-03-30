  $(function() {
    $("#csshack_header_image").width($("body").width()*3/4-20);
    $("div.container").first().css({
    "margin-left": ($("body").width()/8-10) + "px",
    "width": $("body").width()*3/4+20 +"px"
    });
    $("footer div.container").css({
    "margin-left": ($("body").width()/8-10) + "px",
    "width": $("body").width()*3/4+20 +"px"
    });
    $("div.bigheader").css({
        "margin-left": ($("body").width()/8) + "px"
    });
    $("div#head_bottom").width($("body").width()*3/4-20);
    $("div.smallheader.headwrapper").css({
      width: $("body").width()*3/4 +"px",
      height: "148px"
    });
    $(".teaser.wrapper-12").width($("body").width()*3/4);
    $(".teaser.wrapper-12 .col-md-12").innerWidth($("body").width()*3/4-20);
})
